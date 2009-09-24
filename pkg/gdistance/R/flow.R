# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

#TODO check if coordinate systems are equal (should throw warning)

setGeneric("flow", function(transition, originCoord, fromCoords, toCoords, norml, type) standardGeneric("flow"))

setMethod("flow", signature(transition = "Transition", originCoord = "SpatialPoints", fromCoords = "SpatialPoints", toCoords = "missing", norml="logical", type="character"), def = function(transition, originCoord, fromCoords, norml, type)
	{
		if(!all(type %in% c("divergent","joint"))) {stop("type can only have values \'joint\' and/or \'divergent\'")}
		
		originCoord <- coordinates(originCoord)
		fromCoords <- coordinates(fromCoords)

		transition <- .transitionSolidify(transition)
		originCell <- cellFromXY(transition, originCoord)
		if (originCell %in% transitionCells(transition)) {} 
		else 
		{
			stop("the origin was not found in the transition matrix")
		}
		allFromCells <- cellFromXY(transition, fromCoords)
		fromCells <- allFromCells[allFromCells %in% transitionCells(transition)]
		if (length(fromCells) < length(allFromCells)) 
		{
			warning(length(fromCells)," out of ",length(fromCoordsCells[,1])," locations were found inside the transition matrix. NAs introduced.")
		}
		fromCells <- unique(fromCells)
		L <- .Laplacian(transition)
		Lr <- L[-dim(L)[1],-dim(L)[1]]
		A <- as(L,"lMatrix")
		A <- as(A,"dMatrix")
		n <- max(Lr@Dim)
		if("divergent" %in% type) {divFlow <- matrix(ncol=length(fromCells),nrow=length(fromCells))}
		if("joint" %in% type) {jointFlow <- matrix(ncol=length(fromCells),nrow=length(fromCells))}
		indexCoords <- match(fromCells,transitionCells(transition))
		indexOrigin <- match(originCell,transitionCells(transition))
		Lr <- Cholesky(Lr)
		AIndex <- as(A, "dgTMatrix")
		index <- cbind(as.integer(AIndex@i+1),as.integer(AIndex@j+1))
		index <- index[index[,1] < index[,2],]
		Size <- length(index[,1])
		R <- 1/-L[index]
		R[R == Inf] <- 0

		if( ((Size * length(fromCells) * 8) + 112)/1048576 > (memory.limit()-memory.size())/10) #depending on memory availability, currents are calculated in a piecemeal fashion or all at once
		{
			cat("no memory available for optimized version\n")
			for (i in 1:(length(fromCells))) 
			{
				Flowi <- .currentM(L, Lr, A, n, indexOrigin, indexCoords[i], index)
				for (j in i:length(fromCells))
				{
					Flowj <- .currentM(L, Lr, A, n, indexOrigin, indexCoords[j], index)
					if("divergent" %in% type) {divFlow[j,i] <- divFlow[i,j] <- sum(pmax(pmax(Flowi, Flowj) * (1-pmin(Flowi,Flowj)) - pmin(Flowi, Flowj), 0) * R)}
					if("joint" %in% type) {jointFlow[j,i] <- jointFlow[i,j] <- sum(Flowi * Flowj * R)}
				}
			}
		}
		else
		{
			Flow <- matrix(nrow=Size,ncol=length(fromCells))
			for(i in 1:(length(fromCells)))
			{
				Flow[,i] <- .currentM(L, Lr, A, n, indexOrigin, indexCoords[i], index)
			}
			if("divergent" %in% type)
			{
				for(j in 1:(length(fromCells)))
				{
					divFlow[j,] <- colSums(matrix(pmax(pmax(Flow[,j],Flow) * (1-pmin(Flow[,j],Flow)) - pmin(Flow[,j],Flow), 0), nrow= Size) * R)
				}
			}
			if("joint" %in% type)
			{
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
			divFl[index1,index1] <- divFlow[index2,index2]
			divFl <- as.dist(divFl)
			attr(divFl, "method") <- "divergent flow"
		}
		if("joint" %in% type)
		{
			jointFl <- matrix(nrow=length(allFromCells),ncol=length(allFromCells))
			rownames(jointFl) <- rownames(fromCoords)
			colnames(jointFl) <- rownames(fromCoords)
			jointFl[index1,index1] <- jointFlow[index2,index2]
			jointFl <- as.dist(jointFl)
			attr(jointFl, "method") <- "joint flow"		
		}
		if(length(type) > 1) {return(list(divFl=divFl, jointFl=jointFl))}
		if(length(type) == 1 & type == "divergent") {return(divFl)}
		if(length(type) == 1 & type == "joint") {return(jointFl)}
	}
)