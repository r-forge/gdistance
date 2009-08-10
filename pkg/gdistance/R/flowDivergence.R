# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

#TODO check if coordinate systems are equal (should throw warning)

setGeneric("flowDivergence", function(transition, originCoord, fromCoords, toCoords, norml) standardGeneric("flowDivergence"))

setMethod("flowDivergence", signature(transition = "Transition", originCoord = "SpatialPoints", fromCoords = "SpatialPoints", toCoords = "missing", norml="logical"), def = function(transition, originCoord, fromCoords, norml)
	{
		originCoord <- coordinates(originCoord)
		fromCoords <- coordinates(fromCoords)

		transition <- .transitionSolidify(transition)
		originCell <- cellFromXY(transition, originCoord)
		if (originCell %in% transitionCells(transition)) {} 
		else 
		{
			stop("the origin was not found in the transition matrix")
		}
		fromCoordsCells <- cbind(fromCoords,cellFromXY(transition, fromCoords))
		fromCells <- fromCoordsCells[,3][fromCoordsCells[,3] %in% transitionCells(transition)]
		if (length(fromCells) < length(fromCoordsCells[,1])) 
		{
			warning(length(fromCells)," out of ",length(fromCoordsCells[,1])," locations were found inside the transition matrix. NAs introduced.")
		}
		fromCells <- unique(fromCells)
		L <- .Laplacian(transition)
		Lr <- L[-dim(L)[1],-dim(L)[1]]
		A <- as(L,"lMatrix")
		A <- as(A,"dMatrix")
		n <- max(Lr@Dim)
		flDivergence <- matrix(ncol=length(fromCells),nrow=length(fromCells))
		indexCoords <- match(fromCells,transitionCells(transition))
		indexOrigin <- match(originCell,transitionCells(transition))
		Lr <- Cholesky(Lr)
		AIndex <- as(A, "dgTMatrix")
		index <- cbind(as.integer(AIndex@i+1),as.integer(AIndex@j+1))
		index <- index[index[,1] < index[,2],]
		Size <- length(index[,1])
		rm(AIndex)
		R <- 1/-L[index]
		R[R == Inf] <- 0

		if( ((Size * length(fromCells) * 8) + 112)/1048576 > (memory.limit()-memory.size())/10) #depending on memory availability, currents are calculated in a piecemeal fashion or all at once
		{
			for (i in 1:(length(fromCells))) 
			{
				Flowi <- .currentM(L, Lr, A, n, indexOrigin, indexCoords[i], index)
				for (j in i:length(fromCells))
				{
					Flowj <- .currentM(L, Lr, A, n, indexOrigin, indexCoords[j], index)
					flDivergence[j,i] <- sum((Flowi*(1-Flowj) + (1-Flowi) * Flowj) * R)
				}
			}
		}
		else
		{
			sqrtR <- sqrt(R)
			Flow <- matrix(nrow=Size,ncol=length(fromCells))
			for(i in 1:(length(fromCells)))
			{
				Flow[,i] <- .currentM(L, Lr, A, n, indexOrigin, indexCoords[i], index)
			}
			Flow <- Flow * sqrtR
			for(j in 1:(length(fromCells)))
			{
				flDivergence[j,] <- (colSums((1-Flow[,j])*Flow) + colSums(Flow[,j]*(1-Flow)))
			}
		}

		if (norml) {flDivergence <- flDivergence / sum(R)}
		
		flDiv <- matrix(nrow=length(fromCoordsCells[,1]),ncol=length(fromCoordsCells[,1]))
		rownames(flDiv) <- rownames(fromCoords)
		colnames(flDiv) <- rownames(fromCoords)
		index1 <- which(fromCoordsCells[,3] %in% fromCells)
		index2 <- match(fromCoordsCells[,3][fromCoordsCells[,3] %in% fromCells],fromCells)
		flDiv[index1,index1] <- flDivergence[index2,index2]
		flDiv <- as.dist(flDiv)
		attr(flDiv, "method") <- "flowDivergence"
		return(flDiv)

	}
)