# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

setGeneric("flowMap", function(transition, origin, goal) standardGeneric("flowMap"))

setMethod("flowMap", signature(transition = "Transition", origin = "SpatialPoints", goal = "SpatialPoints"), def = function(transition, origin, goal)
	{
		originCell <- cellFromXY(transition, origin)
		goalCell <- cellFromXY(transition, goal)
		L <- .Laplacian(transition)
		Lr <- L[-dim(L)[1],-dim(L)[1]]
		A <- as(L,"lMatrix")
		A <- as(A,"dMatrix")
		n <- max(dim(Lr))
		indexGoal <- match(goalCell,transitionCells(transition))
		indexOrigin <- match(originCell,transitionCells(transition))
		Current <- .current(L, Lr, A, n, indexOrigin, indexGoal)
		result <- as(transition,"RasterLayer")
		dataVector <- rep(NA,times=ncell(result))
		dataVector[transitionCells(transition)] <- Current
		result <- setValues(result, dataVector)
		return(result)
	}
)

setMethod("flowMap", signature(transition = "Transition", origin = "RasterLayer", goal = "RasterLayer"), def = function(transition, origin, goal)
	{
		originCell <- which(values(origin))
		goalCell <- which(values(goal))
		L <- .Laplacian(transition)
		Lr <- L[-dim(L)[1],-dim(L)[1]]
		A <- as(L,"lMatrix")
		A <- as(A,"dMatrix")
		n <- max(dim(Lr))
		indexGoal <- match(goalCell,transitionCells(transition))
		indexOrigin <- match(originCell,transitionCells(transition))
		Current <- .current(L, Lr, A, n, indexOrigin, indexGoal)
		result <- as(transition,"RasterLayer")
		dataVector <- rep(NA,times=ncell(result))
		dataVector[transitionCells(transition)] <- Current
		result <- setValues(result, dataVector)
		return(result)
	}
)