# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009, code added January 2010
# Version 1.0
# Licence GPL v3

#check if Transition and RasterLayers coincide, etc.

setGeneric("shortestPath", function(transition, origin, goal) standardGeneric("shortestPath"))

setMethod("shortestPath", signature(transition = "Transition", origin = "Coords", goal = "Coords"), def = function(transition, origin, goal)
	{
		origin <- .coordsToMatrix(origin)
		goal <- .coordsToMatrix(goal)
		return(.shortestPath(transition, origin, goal))		
	}
)

.shortestPath <- function(transition, origin, goal)
{
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