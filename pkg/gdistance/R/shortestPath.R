# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009, code added January 2010
# Version 1.0
# Licence GPL v3

#check if Transition and RasterLayers coincide, etc.

setGeneric("shortestPath", function(transition, origin, goal) standardGeneric("shortestPath"))

setMethod("shortestPath", signature(transition = "Transition", origin = "numeric", goal = "numeric"), def = function(transition, origin, goal)
	{
		if(length(origin) == 2) origin <- SpatialPoints(t(as.matrix(origin))) else{stop("argument origin is a vector but does not have a length of two")}
		if(length(goal) == 2) goal <- SpatialPoints(t(as.matrix(goal)))	else{stop("argument goal is a vector but does not have a length of two")}
		return(shortestPath(transition, origin, goal))		
	}
)

setMethod("shortestPath", signature(transition = "Transition", origin = "matrix", goal = "matrix"), def = function(transition, origin, goal)
	{
		if(ncol(origin) == 2) origin <- SpatialPoints(origin) else{stop("argument origin is a matrix but does not have two columns")}
		if(ncol(goal) == 2) goal <- SpatialPoints(goal) else{stop("argument goal is a matrix but does not have two columns")}
		stop("multiple origin or goal cells not implemented")
		#return(shortestPath(transition, origin, goal))
	}	
)
	
setMethod("shortestPath", signature(transition = "Transition", origin = "SpatialPoints", goal = "SpatialPoints"), def = function(transition, origin, goal)
	{
		return(.shortestPath(transition, origin, goal))
	}
)

.shortestPath <- function(transition, origin, goal)
{
		origin <- coordinates(origin)
		goal <- coordinates(goal)
		originCells <- cellFromXY(transition, origin)
		goalCells <- cellFromXY(transition, goal)
		indexOrigin <- match(originCells,transitionCells(transition)) - 1
		indexGoal <- match(goalCells,transitionCells(transition)) - 1
		if(isSymmetric(transitionMatrix(transition))) {mode <- "undirected"} else {mode <- "directed"}
		adjacencyGraph <- graph.adjacency(transitionMatrix(transition), mode=mode, weighted=TRUE)
		E(adjacencyGraph)$weight <- 1/E(adjacencyGraph)$weight

		shortestPaths <- get.shortest.paths(adjacencyGraph, indexOrigin, indexGoal)
		
		result <- transition
		transitionMatrix(result) <- Matrix(0, ncol=ncell(transition), nrow=ncell(transition))
		
		sPVector <- (shortestPaths[[1]] + 1)
		adj <- cbind(sPVector[-(length(sPVector))], sPVector[-1])
		adj <- rbind(adj,cbind(adj[,2], adj[,1]))
		transitionMatrix(result)[adj] <- 1
		return(result)
}