# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

#TODO check if coordinate systems are equal.
#TODO check if bounding box of coordinates falls inside bb of transition

setGeneric("jointFlow", function(transition, originCoord, fromCoords, toCoords) standardGeneric("jointFlow"))

setMethod("jointFlow", signature(transition = "Transition", originCoord = "SpatialPoints", fromCoords = "SpatialPoints", toCoords = "missing"), def = function(transition, originCoord, fromCoords)
	{
		originCoord <- coordinates(originCoord)
		fromCoords <- coordinates(fromCoords)
		originCell <- cellFromXY(transition, originCoord)
		if (originCell %in% transitionCells(transition)) {} 
		else 
		{
			stop("the origin was not found in the transition matrix")
		}
		transition <- .transitionSolidify(transition)
		fromCoordsCells <- cbind(fromCoords,cellFromXY(transition, fromCoords))
		fromCells <- fromCoordsCells[,3][fromCoordsCells[,3] %in% transitionCells(transition)]
		cc <- .connected.components(transition)
		ccOrigin <- subset(cc,cc[,1] %in% originCell)
		fromCells <- subset(fromCells, fromCells %in% cc[,1][cc[,2]==ccOrigin[,2]])
		if (length(fromCells) <= 1) 
		{
			stop("no locations in the connected component of the origin")
		}
		else{}
		if (length(fromCells) < length(fromCoordsCells[,1])) 
		{
			warning(length(fromCells)," out of ",length(fromCoordsCells[,1])," locations were found inside the transition matrix and in the same connected component as the origin.")
		}
		else{}
		fromCells <- unique(fromCells)
		L <- .Laplacian(transition)
		Lr <- L[-dim(L)[1],-dim(L)[1]]
		A <- as(L,"lMatrix")
		A <- as(A,"dMatrix")
		n <- max(Lr@Dim)
		jtDistance <- matrix(ncol=length(fromCells),nrow=length(fromCells))
		cat("Progress Bar", "\n")
		cat("---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|","\n")
		onePercent <- ((length(fromCells)^2)-length(fromCells))/200
		count <- 0
		indexCoords <- match(fromCells,transitionCells(transition))
		indexOrigin <- match(originCell,transitionCells(transition))
		if( ((n * length(fromCells) * 8) + 112)/1048576 > (memory.limit()-memory.size())/10) #depending on memory availability, currents are calculated in a piecemeal fashion or all at once
		{
			for (i in 1:(length(fromCells)))
			{
				Currenti <- .current(L, Lr, A, n, indexOrigin, indexCoords[i])
				for (j in i:length(fromCells))
				{
					Currentj <- .current(L, Lr, A, n, indexOrigin, indexCoords[j])
					jtDistance[j,i] <- mean(Currenti*Currentj) #alternative, which represents the relative overlap: sum((pmin(Currenti,Currentj)))/sum(Currenti,Currentj) 
					count <- count+1
					if(count>=onePercent) {cat("|"); count<-count-onePercent}
				}
			}
		}
		else
		{
			Current <- matrix(nrow=n+1,ncol=length(fromCells))
			for(i in 1:(length(fromCells)))
			{
				Current[,i] <- .current(L, Lr, A, n, indexOrigin, indexCoords[i])
				count <- count+1
				if(count>=onePercent) {cat("|"); count<-count-onePercent}
			}
			for(j in 1:(length(fromCells)))
			{
				jtDistance[j,] <- colMeans(Current[,j]*Current)
			}
		}
		jtDistance <- jtDistance * sqrt(matrix(diag(jtDistance),nrow=length(fromCells),ncol=length(fromCells)) * t(matrix(diag(jtDistance),nrow=length(fromCells),ncol=length(fromCells)))) #this is to normalize the dot product to get a cosine similarity
		cat("|","\n")
		jtDist <- matrix(nrow=length(fromCoordsCells[,1]),ncol=length(fromCoordsCells[,1]))
		rownames(jtDist) <- rownames(fromCoords)
		colnames(jtDist) <- rownames(fromCoords)
		index1 <- which(fromCoordsCells[,3] %in% fromCells)
		index2 <- match(fromCoordsCells[,3][fromCoordsCells[,3] %in% fromCells],fromCells)
		jtDist[index1,index1] <- jtDistance[index2,index2]
		jtDist <- as.dist(jtDist)
		return(jtDist) #TODO as.dist, check which half is filled.
	}
)

setMethod("jointFlow", signature(transition = "Transition", originCoord = "SpatialPoints", fromCoords = "SpatialPoints", toCoords = "SpatialPoints"), def = function(transition, originCoord, fromCoords, toCoords)
	{
		stop("not yet implemented")
		originCoord <- coordinates(originCoord)
		fromCoords <- coordinates(fromCoords)
		toCoords <- coordinates(toCoords)
		originCell <- cellFromXY(transition, originCoord)
		if (originCell %in% transitionCells(transition)) {} 
		else 
		{
			stop("the origin was not found in the transition matrix")
		}
		transition <- .transitionSolidify(transition)
		fromCoordsCells <- cbind(fromCoords,cellFromXY(transition, fromCoords))
		toCoordsCells <- cbind(toCoords,cellFromXY(transition, toCoords))
		fromCells <- fromCoordsCells[,3][fromCoordsCells[,3] %in% transitionCells(transition)] 
		toCells <- toCoordsCells[,3][toCoordsCells[,3] %in% transitionCells(transition)] 
		cc <- .connected.components(transition)
		ccOrigin <- subset(cc,cc[,1] %in% originCell)
		fromCells <- subset(fromCells, fromCells %in% cc[,1][cc[,2]==ccOrigin[,2]])
		toCells <- subset(toCells, toCells %in% cc[,1][cc[,2]==ccOrigin[,2]])
		if (length(fromCells) <= 1) 
		{
			stop("no locations (fromCoords) in the connected component of the origin")
		}
		else{}
		if (length(fromCells) < length(fromCoordsCells[,1])) 
		{
			warning(length(fromCells)," out of ",length(fromCoordsCells[,1])," locations (fromCoords) were found inside the transition matrix and in the same connected component as the origin.")
		}
		else{}
		if (length(toCells) <= 1) 
		{
			stop("no locations (toCoords) in the connected component of the origin")
		}
		else{}
		if (length(toCells) < length(toCoordsCells[,1])) 
		{
			warning(length(toCells)," out of ",length(toCoordsCells[,1])," locations (toCoords) were found inside the transition matrix and in the same connected component as the origin.")
		}
		else{}
		uniqueCells <- unique(c(fromCells,toCells)) #This should be optimized; from and to should be kept separate throughout
		L <- .Laplacian(transition)
		Lr <- L[-dim(L)[1],-dim(L)[1]]
		A <- as(L,"lMatrix")
		A <- as(A,"dMatrix")
		n <- max(Lr@Dim)
		jtDistance <- matrix(nrow=length(uniqueCells),ncol=length(uniqueCells))
		cat("Progress Bar", "\n")
		cat("---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|","\n")
		onePercent <- ((length(fromCells)^2)-length(fromCells))/200
		count <- 0
		indexCoords <- match(uniqueCells,transitionCells(transition))
		indexOrigin <- match(originCell,transitionCells(transition))
		if( ((n * length(fromCells) * 8) + 112)/1048576 > (memory.limit()-memory.size())/10)
		{
			for (i in 1:(length(uniqueCells)))
			{
				Currenti <- .current(L, Lr, A, n, indexOrigin, indexCoords[i])
				for (j in i:length(uniqueCells))
				{
					Currentj <- .current(L, Lr, A, n, indexOrigin, indexCoords[j])
					jtDistance[j,i] <- mean(Currenti*Currentj)
					count <- count+1
					if(count>=onePercent) {cat("|"); count <- count-onePercent}
				}
			}
		}
		else
		{
			Current <- matrix(nrow=n+1,ncol=length(uniqueCells))
			for(i in 1:(length(uniqueCells)))
			{
				Current[,i] <- .current(L, Lr, A, n, indexOrigin, indexCoords[i])
				count <- count+1
				if(count>=onePercent) {cat("|"); count <- count-onePercent}
			}
			for(j in 1:(length(uniqueCells)))
			{
				jtDistance[j,] <- colMeans(Current[,j]*Current)
			}
		}
		jtDistance <- jtDistance * sqrt(matrix(diag(jtDistance),nrow=length(uniqueCells),ncol=length(uniqueCells)) * t(matrix(diag(jtDistance),nrow=length(uniqueCells),ncol=length(uniqueCells)))) #this is to normalize the dot product to get a cosine similarity
		cat("|","\n")
		jtDist <- matrix(nrow=length(fromCoordsCells[,1]),ncol=length(toCoordsCells[,1]))
		rownames(jtDist) <- rownames(fromCoords)
		colnames(jtDist) <- rownames(toCoords)
		index1 <- which(fromCoordsCells[,3] %in% uniqueCells)
		index2 <- which(toCoordsCells[,3] %in% uniqueCells)
		index3 <- match(fromCoordsCells[,3][fromCoordsCells[,3] %in% uniqueCells],uniqueCells)
		index4 <- match(toCoordsCells[,3][toCoordsCells[,3] %in% uniqueCells],uniqueCells)
		jtDist[index1,index2] <- jtDistance[index3,index4]
		return(jtDist) 
	}
)