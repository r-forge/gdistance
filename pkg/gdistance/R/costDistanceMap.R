# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

setGeneric("costDistanceMap", function(transition, object) standardGeneric("costDistanceMap"))

setMethod("costDistanceMap", signature(transition = "Transition", object = "SpatialPoints"), def = function(transition, object)
	{
		fromCoords <- coordinates(object)
		fromCoordsCells <- cellFromXY(transition, fromCoords)
		adjacencyGraph <- graph.adjacency(transitionMatrix(transition), mode="undirected", weighted=TRUE)
		E(adjacencyGraph)$weight <- 1/E(adjacencyGraph)$weight
		fromCells <- subset(fromCoordsCells, fromCoordsCells %in% transitionCells(transition))
		if (length(fromCells) < length (fromCoordsCells)) 
		{
			warning(length(fromCells), " out of ", length(fromCoordsCells), " locations were found in the transition matrix.","\n")
		}
		shortestPaths <- rep(Inf, times=length(transitionCells(transition)))	
		for (i in 1:length(fromCells))
		{
			shortestPaths <- pmin(shortestPaths,shortest.paths(adjacencyGraph, match(fromCells[i],transitionCells(transition))))
		}
		result <- as(transition, "RasterLayer")
		dataVector <- vector(length=ncell(result)) 
		dataVector[transitionCells(transition)] <- shortestPaths
		result <- setValues(result, dataVector)	
		return(result)
	}
)

setMethod("costDistanceMap", signature(transition = "Transition", object = "RasterLayer"), def =
cmd <- function(transition, object)
	{
		n <- ncell(transition)
		directions <- max(rowSums(as(transitionMatrix(transition),"lMatrix")))
		fromCells <- which(!is.na(values(object)))
		toCells <- which(is.na(values(object)))
		accCostDist <- rep(Inf,times=n)
		accCostDist[fromCells] <- 0
		while(length(fromCells)>0)
		{			
			adj <- adjacency(transition,fromCells=fromCells,toCells=toCells,directions=directions)
			transitionValues <- accCostDist[adj[,1]] + 1/transition[adj]
			tValSmaller <- transitionValues < accCostDist[adj[,2]]
			fromCells <- adj[tValSmaller,2]
			accCostDist <- igroupMins(c(transitionValues[tValSmaller],accCostDist),c(fromCells,1:n))
			fromCells <- unique(fromCells)
		}
		result <- as(transition, "RasterLayer")
		result <- setValues(result, accCostDist)	
		return(result)
	}
)