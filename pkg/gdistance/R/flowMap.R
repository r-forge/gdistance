# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

flowMap <- function(originCoord,goalCoord,transition)
{
	originCell <- cellFromXY(transition, originCoord)
	goalCell <- cellFromXY(transition, goalCoord)
	L <- .Laplacian(transition)
	Lr <- L[-dim(L)[1],-dim(L)[1]]
	A <- as(L,"lMatrix")
	A <- as(A,"dMatrix")
	n <- max(dim(Lr))
	indexGoal <- match(goalCell,transitionCells(transition))
	indexOrigin <- match(originCell,transitionCells(transition))
	Current <- .current(L, Lr, A, n, indexOrigin, indexGoal)
	result <- as(transition,"RasterLayer")
	dataVector <- rep(NA,times=ncells(result))
	dataVector[transitionCells(transition)] <- Current
	result <- setValues(result, dataVector)
	return(result)
}