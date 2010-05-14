# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2010
# Version 1.0
# Licence GPL v3

#permissible values totalNet and output
#TODO check if coordinate systems are equal (should throw warning)
#division by zero: warning?
#reconstructing dist matrix with names, etc. -> generic function?

#combining with passage functions and adding the same options (total flow, net flow, different/custom comparison functions)?

setGeneric("pathInc", function(transition, origin, fromCoords, toCoords, norml, type, theta, ...) standardGeneric("pathInc"))

setMethod("pathInc", signature(transition = "Transition", origin = "Coords", fromCoords = "Coords", toCoords = "missing", norml="logical", type="character", theta="missing"), def = function(transition, origin, fromCoords, norml, type, ...)
	{
		origin <- .coordsToMatrix(origin)
		from <- .coordsToMatrix(fromCoords)
		prepared <- .preparationFlow(transition, origin, fromCoords, norml, type)
		Intermediate <- .randomWalk(prepared)
		result <- .finishFlow(prepared, Intermediate)
		return(result)
	}
)

setMethod("pathInc", signature(transition = "Transition", origin = "Coords", fromCoords = "Coords", toCoords = "missing", norml="logical", type="character", theta="numeric"), def = function(transition, origin, fromCoords, norml, type, theta, ...)
	{
		if(theta < 0 | theta > 20 ) {stop("theta value out of range (between 0 and 20)")}
		prepared <- .preparationFlow(transition, origin, fromCoords, norml, type)
		Intermediate <- .randomSP(prepared, theta)
		result <- .finishFlow(prepared, Intermediate)
		return(result)
	}
)

.preparationFlow <- function(transition, origin, fromCoords, norml, type)
{
		if(!all(type %in% c("divergent","joint"))) {stop("type can only have values \'joint\' and/or \'divergent\'")}

		transition <- .transitionSolidify(transition)
		originCell <- cellFromXY(transition, origin)
		if (!(originCell %in% transitionCells(transition))) {stop("the origin was not found in the transition matrix")} 

		allFromCells <- cellFromXY(transition, fromCoords)
		fromCells <- allFromCells[allFromCells %in% transitionCells(transition)]
		if (length(fromCells) < length(allFromCells)) 
		{
			warning(length(fromCells)," out of ",length(allFromCells[,1])," locations were found inside the transition matrix. NAs introduced.")
		}
		fromCells <- unique(fromCells)

		indexCoords <- match(fromCells,transitionCells(transition))
		indexOrigin <- match(originCell,transitionCells(transition))

		A <- as(transitionMatrix(transition),"lMatrix")
		A <- as(A,"dMatrix")
		AIndex <- as(A, "dgTMatrix")
		index <- cbind(as.integer(AIndex@i+1),as.integer(AIndex@j+1))
		index <- index[index[,1] < index[,2],]
		Size <- length(index[,1])

		R <- 1/transitionMatrix(transition)[index] #or transition[index]?
		R[R == Inf] <- 0
		
		result <- list(transition=transition,
						type=type,
						norml=norml,
						fromCoords=fromCoords,
						allFromCells=allFromCells, 
						fromCells=fromCells,
						indexCoords=indexCoords, 
						indexOrigin=indexOrigin,
						index=index,
						Size=Size,
						A=A,
						R=R)
		return(result)
}

#setMethod("flow", signature(transition = "Transition", origin = "RasterLayer", fromCoords = "SpatialPoints", toCoords = "missing", norml="logical", type="character", algorithm="character"), def = function(transition, originCoord, fromCoords, norml, type, algorithm)
#	{
#	}

.randomWalk <- function(prepared)
{
	transition <- prepared$transition
	indexCoords <- prepared$indexCoords
	indexOrigin <- prepared$indexOrigin
	fromCells <- prepared$fromCells
	index <- prepared$index
	Size <- prepared$Size
	A <- prepared$A
	R <- prepared$R
		
	L <- .Laplacian(transition)
	Lr <- L[-dim(L)[1],-dim(L)[1]]
	n <- max(Lr@Dim)
	Lr <- Cholesky(Lr)

	if(FALSE)#((Size * length(fromCells) * 8) + 112)/1048576 > (memory.limit()-memory.size())/10) #depending on memory availability, currents are calculated in a piecemeal fashion or all at once
	{
		filenm=rasterTmpFile()
		Flow <- raster(nrows=length(fromCells), ncols=Size)
		Flow <- writeStart(Flow, filenm, overwrite=TRUE)
		for(i in 1:(length(fromCells)))
		{
			matrixRow <- .currentM(L, Lr, A, n, indexOrigin, indexCoords[i], index)
			Flow <- writeValues(Flow, matrixRow)
		}
		Flow <- writeStop(Flow)
	}
	else
	{
		Flow <- matrix(nrow=Size,ncol=length(fromCells))
		for(i in 1:(length(fromCells)))
		{
			Flow[,i] <- .currentM(L, Lr, A, n, indexOrigin, indexCoords[i], index)
		}
	}
	return(Flow)
}


.randomSP <- function(prepared, theta)
{
	transition <- prepared$transition
	cj <- prepared$indexCoords
	ci <- prepared$indexOrigin
	fromCells <- prepared$fromCells #only length is used. Also, cj should be equal in length to fromCells
	index <- prepared$index
	Size <- prepared$Size
	R <- prepared$R
		
	tr <- transitionMatrix(transition)
	tc <- transitionCells(transition)

	A <- as(transitionMatrix(transition),"lMatrix")
	A <- as(A,"dMatrix")
	AIndex <- as(A, "dgTMatrix")
	index <- cbind(as.integer(AIndex@i+1),as.integer(AIndex@j+1))
	index <- index[index[,1] < index[,2],]
	Size <- length(index[,1])
	
	trR <- tr
	trR[index] <- R 

	nr <- dim(tr)[1] 
	Id <- Diagonal(nr) 
	rs <- rowSums(tr)
	rs[rs>0] <- 1/rs[rs>0]
	P <- tr * rs

	W <- trR
	W@x <- exp(-theta * trR@x) #zero values are not relevant because of next step exp(-theta * trR@x) ; the logarithm is a small variation, which gives a natural random walk
	W <- W * P 

	if(((Size * length(fromCells) * 8) + 112)/1048576 > (memory.limit()-memory.size())/10) 
	#this does not take into account the exact memory needed for matrix solving...
	{
		filenm=rasterTmpFile()
		Flow <- raster(nrows=length(fromCells), ncols=Size)
		Flow <- writeStart(Flow, filenm, overwrite=TRUE)
		for(i in 1:(length(fromCells)))
		{
			matrixRow <- transitionMatrix(.probPass(transition, Id, W, nr, ci, cj[i], tc, totalNet="net", output="Transition"))[index]
			writeValues(Flow, matrixRow)
		}
		Flow <- writeStop(Flow)
	}
	else
	{
		Flow <- matrix(nrow=Size,ncol=length(fromCells))
		for(i in 1:(length(fromCells)))
		{
			Flow[,i] <- transitionMatrix(.probPass(transition, Id, W, nr, ci, cj[i], tc, totalNet="net", output="Transition"))[index]
		}
	}
	return(Flow)
}	

#.probPass <- function(Id, W, nr, ei, cj, index)
#{	
#	Ij <- Id
#	Ij[cbind(cj,cj)] <- 0
#	Wj <- Ij %*% W
#	IdMinusWj <- as((Id - Wj), "dgCMatrix")
#	zci <- solve(t(IdMinusWj),ei)

#	ej <- rep(0,times=nr)
#	ej[cj] <- 1
#	zcj <- solve(IdMinusWj, ej)
#	zcij <- sum(ei*zcj)
#	if(zcij < 1e-300){return(rep(0,times=length(index[,1])))}
#	else
#	{
#		# Computation of the matrix N, containing the number of passages through
#		# each arc
#		N <- (Diagonal(nr, as.vector(zci)) %*% Wj %*% Diagonal(nr, as.vector(zcj))) / zcij
#		result <- N[index]
#		return(result)
#	}
#}

.finishFlow <- function(prepared, Flow)
{
	fromCells <- prepared$fromCells
	allFromCells <- prepared$allFromCells
	fromCoords <- prepared$fromCoords
	type <- prepared$type
	norml <- prepared$norml
	
	Size <- prepared$Size
	R <- prepared$R
	
	if(class(Flow) == "RasterLayer")
	{
		nr <- min(10,nrow(Flow))
		end <- ceiling(length(fromCells)/nr)
		if("divergent" %in% type) {divFlow <- matrix(ncol=length(fromCells),nrow=length(fromCells))}
		if("joint" %in% type) {jointFlow <- matrix(ncol=length(fromCells),nrow=length(fromCells))}
		
		nrows1 <- nr
		startrow1 <- 1
		dataRows1 <- getValues(Flow, startrow=startrow1, nrows=nrows1)
		dataRows1 <- matrix(dataRows1,nrow=ncol(Flow)) #rows are cell transitions, columns are locations

		for(j in 1:end)
		{
			if("divergent" %in% type) 
			{
				for(k in 1:nrows1)
				{
					index <- startrow1+k-1
					divFlow[startrow1:(startrow1+nrows1-1),index] <- colSums(matrix(pmax(pmax(dataRows1[,k],dataRows1) * 
					   (1-pmin(dataRows1[,k],dataRows1)) - pmin(dataRows1[,k],dataRows1), 0), nrow= Size) * R)
					#this fills the lower triangle only (plus some upper triangle blocks of size nr around the diagonal)
				}
			}
			if("joint" %in% type) 
			{
				for(l in 1:nrows1)
				{
					index <- startrow1+l-1
					jointFlow[startrow1:(startrow1+nrows1-1),index] <- colSums(matrix((dataRows1[,l] * dataRows1), nrow=Size) * R)

				}
			}
			if(j != end)
			{
				for(m in (j+1):end)
				{
					nrows2 <- min(nr, length(fromCells) - (m - 1) * nr)
					startrow2 <- (m-1)*nr+1
					dataRows2 <- getValues(Flow, startrow=startrow2, nrows=nrows2)
					dataRows2 <- matrix(dataRows2,nrow=ncol(Flow))
				
					if("divergent" %in% type) 
					{
						for(n in 1:nrows1)
						{
							index <- startrow1+n-1 
							divFlow[startrow2:(startrow2+nrows2-1),index] <- colSums(matrix(pmax(pmax(dataRows1[,n],dataRows2) * 
							(1-pmin(dataRows1[,k],dataRows2)) - pmin(dataRows1[,n],dataRows2), 0), nrow= Size) * R)
						}
					}
					if("joint" %in% type) 
					{
						for(o in 1:nrows1)
						{
							index <- startrow1+o-1
							jointFlow[startrow2:(startrow2+nrows2-1),index] <- colSums(matrix((dataRows1[,l] * dataRows2), nrow=Size) * R)
						}
					}
				}
				nrows1 <- min(nr, length(fromCells) - j * nr)
				startrow1 <- j*nr+1
				dataRows1 <- matrix(getValues(dataRows1, row=startrow1, nrows=nrows1),nrow=ncol(Flow))
			}
		}
	}
	if(class(Flow) == "matrix")
	{
		if("divergent" %in% type)
		{
			divFlow <- matrix(ncol=length(fromCells),nrow=length(fromCells))
			for(j in 1:(length(fromCells)))
			{
				divFlow[j,] <- colSums(matrix(pmax(pmax(Flow[,j],Flow) * (1-pmin(Flow[,j],Flow)) - pmin(Flow[,j],Flow), 0), nrow= Size) * R)
			}
		}
		if("joint" %in% type)
		{
			jointFlow <- matrix(ncol=length(fromCells),nrow=length(fromCells))
			for(j in 1:(length(fromCells)))
			{
				jointFlow[j,] <- colSums((Flow[,j] * Flow) * R)
			}
		}
	}
	if (norml) 
	{
		if("divergent" %in% type) divFlow <- divFlow / sum(R)
		if("joint" %in% type) jointFlow <- jointFlow / sum(R)
	}
	index1 <- which(allFromCells %in% fromCells)
	index2 <- match(allFromCells[allFromCells %in% fromCells], fromCells)
		
	if("divergent" %in% type)
	{
		divFl <- matrix(nrow=length(allFromCells),ncol=length(allFromCells))
		rownames(divFl) <- rownames(fromCoords)
		colnames(divFl) <- rownames(fromCoords)
		divFlow <- as.matrix(as.dist(divFlow, diag=TRUE))
		divFl[index1,index1] <- divFlow[index2,index2]
		divFl <- as.dist(divFl)
		attr(divFl, "method") <- "divergent path"
	}
	if("joint" %in% type)
	{
		jointFl <- matrix(nrow=length(allFromCells),ncol=length(allFromCells))
		rownames(jointFl) <- rownames(fromCoords)
		colnames(jointFl) <- rownames(fromCoords)
		jointFlow <- as.matrix(as.dist(jointFlow, diag=TRUE))
		jointFl[index1,index1] <- jointFlow[index2,index2]
		jointFl <- as.dist(jointFl)
		attr(jointFl, "method") <- "joint path"		
	}
	if(length(type) > 1) {return(list(divergent=divFl, joint=jointFl))}
	if(length(type) == 1 & type == "divergent") {return(divFl)}
	if(length(type) == 1 & type == "joint") {return(jointFl)}
} 