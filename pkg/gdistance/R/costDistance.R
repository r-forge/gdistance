# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

#TODO check if coordinate systems are equal.
#TODO check if bounding box of coordinates falls inside bb of transition

setGeneric("costDistance", function(transition, fromCoords, toCoords) standardGeneric("costDistance"))

setMethod("costDistance", signature(transition = "TransitionLayer", fromCoords = "Coords", toCoords = "Coords"), def = function(transition, fromCoords, toCoords)
	{
		fromCoords <- .coordsToMatrix(fromCoords)
		toCoords <- .coordsToMatrix(toCoords)
		
		fromCoords <- coordinates(fromCoords)
		toCoords <- coordinates(toCoords)
		fromCoordsCells <- cellFromXY(transition, fromCoords)
		toCoordsCells <- cellFromXY(transition, toCoords)
		costDist <- matrix(NA, nrow=length(fromCoords[,1]),ncol=length(toCoords[,1]))
		rownames(costDist) <- rownames(fromCoords)
		colnames(costDist) <- rownames(toCoords)
		
		if(isSymmetric(transitionMatrix(transition))) {mode <- "undirected"} else {mode <- "directed"}
		adjacencyGraph <- graph.adjacency(transitionMatrix(transition), mode=mode, weighted=TRUE)
		
		E(adjacencyGraph)$weight <- 1/E(adjacencyGraph)$weight
		fromCells <- subset(fromCoordsCells, fromCoordsCells %in% transitionCells(transition))
		toCells <- subset(toCoordsCells, toCoordsCells %in% transitionCells(transition))
		if (length(fromCells) < length (fromCoordsCells)) 
		{
			warning(length(fromCells), " out of ", length(fromCoordsCells), " origin locations were found in the transition matrix.")
		}
		if (length(toCells) < length (toCoordsCells)) 
		{
			warning(length(toCells), " out of ", length(toCoordsCells), " destination locations were found in the transition matrix.")
		}
		uniqueFromCells <- unique(fromCells)
		uniqueToCells <- unique(toCells)		
		shortestPaths <- matrix(nrow=length(uniqueFromCells),ncol=length(uniqueToCells))
		index <- match(uniqueToCells,transitionCells(transition))
		for (i in 1:length(uniqueFromCells))
		{
			shortestPaths[i,] <- shortest.paths(adjacencyGraph, match(uniqueFromCells[i],transitionCells(transition))-1)[,index]
		}
		index1 <- which(fromCoordsCells %in% fromCells)
		index2 <- which(toCoordsCells %in% toCells)
		index3 <- match(fromCoordsCells[fromCoordsCells %in% fromCells],uniqueFromCells)
		index4 <- match(toCoordsCells[toCoordsCells %in% toCells],uniqueToCells)
		costDist[index1,index2] <- shortestPaths[index3,index4]
		return(costDist)
	}
)

setMethod("costDistance", signature(transition = "TransitionLayer", fromCoords = "Coords", toCoords = "missing"), def = function(transition, fromCoords)
	{
		fromCoords <- coordinates(fromCoords)
		fromCoordsCells <- cellFromXY(transition, fromCoords)
		costDist <- matrix(NA, nrow=length(fromCoords[,1]),ncol=length(fromCoords[,1]))
		rownames(costDist) <- rownames(fromCoords)
		colnames(costDist) <- rownames(fromCoords)
		
		if(isSymmetric(transitionMatrix(transition))) {mode <- "undirected"} else {mode <- "directed"}
		adjacencyGraph <- graph.adjacency(transitionMatrix(transition), mode=mode, weighted=TRUE)
		
		E(adjacencyGraph)$weight <- 1/E(adjacencyGraph)$weight
		fromCells <- subset(fromCoordsCells, fromCoordsCells %in% transitionCells(transition))
		if (length(fromCells) < length (fromCoordsCells)) 
		{
			warning(length(fromCells), " out of ", length(fromCoordsCells), " locations were found in the transition matrix.","\n")
		}
		uniqueFromCells <- unique(fromCells)
		shortestPaths <- matrix(ncol=length(uniqueFromCells),nrow=length(uniqueFromCells))
		index <- match(uniqueFromCells,transitionCells(transition))
		for (i in 1:length(uniqueFromCells))
		{
			shortestPaths[i,] <- shortest.paths(adjacencyGraph, index[i]-1)[,index]
		}
		index1 <- which(fromCoordsCells %in% fromCells)
		index2 <- match(fromCoordsCells[fromCoordsCells %in% fromCells],uniqueFromCells)
		costDist[index1,index1] <- shortestPaths[index2,index2]
		if(mode=="undirected") {costDist <- as.dist(costDist)}
		return(costDist)
	}
)

