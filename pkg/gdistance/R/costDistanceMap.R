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
		dataVector <- vector(length=ncells(result)) 
		dataVector[transitionCells(transition)] <- shortestPaths
		result <- setValues(result, dataVector)	
		return(result)
	}
)

setMethod("costDistanceMap", signature(transition = "Transition", object = "RasterLayer"), def = function(transition, object)
	{
		n <- ncell(transition)
		directions <- max(rowSums(as(transitionMatrix(transition),"lMatrix")))
		fromCells <- which(!is.na(values(object)))
		toCells <- which(is.na(values(object)))
		accCostDist <- rep(0,times=n)
		accCostDist[toCells] <- Inf
		while(length(fromCells)>0)
		{			
			adj <- adjacency(transition,fromCells=fromCells,toCells=toCells,directions=directions)
			transitionValues <- accCostDist[adj[,1]] + 1/transition[adj]
			transitionValues <- tapply(transitionValues,adj[,2],min)
			transitionValues <- transitionValues[transitionValues < Inf]
			index <- as.integer(names(transitionValues))
			fromCells <- index[transitionValues < accCostDist[index]]
			accCostDist[index] <- pmin(transitionValues,accCostDist[index])
		}
		result <- as(transition, "RasterLayer")
		result <- setValues(result, accCostDist)	
		return(result)
	}
)