# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009, code added January 2010
# Version 1.0
# Licence GPL v3

setGeneric("probPassage", function(transition, origin, goal, theta) standardGeneric("probPassage"))

setMethod("probPassage", signature(transition = "Transition", origin = "SpatialPoints", goal = "SpatialPoints", theta="missing"), def = function(transition, origin, goal)
	{
		transition <- .transitionSolidify(transition)
		tc <- transitionCells(transition)
		cellnri <- cellFromXY(transition, origin)
		cellnrj <- cellFromXY(transition, goal)
		ci <- match(cellnri,tc)
		cj <- match(cellnrj,tc)
		
		result <- .flowMap(transition, ci, cj, tc)
		return(result)
	}
)

setMethod("probPassage", signature(transition = "Transition", origin = "RasterLayer", goal = "RasterLayer", theta="missing"), def = function(transition, origin, goal)
	{
		#check if Transition and RasterLayers coincide
		transition <- .transitionSolidify(transition)
		tc <- transitionCells(transition)
		ci <- which(values(origin))
		cj <- which(values(goal))
		result <- .flowMap(transition, ci, cj, tc)
		return(result)
	}
)

.flowMap <- function(transition, originCell, goalCell, tc)
{
	L <- .Laplacian(transition)
	Lr <- L[-dim(L)[1],-dim(L)[1]]
	A <- as(L,"lMatrix")
	A <- as(A,"dMatrix")
	n <- max(dim(Lr))
	indexGoal <- match(goalCell,transitionCells(transition))
	indexOrigin <- match(originCell,transitionCells(transition))
	Current <- .currentR(L, Lr, A, n, indexOrigin, indexGoal)
	result <- as(transition,"RasterLayer")
	dataVector <- rep(NA,times=ncell(result))
	dataVector[tc] <- Current
	result <- setValues(result, dataVector)
	return(result)
}

# Author: Jacob van Etten jacobvanetten@yahoo.com, based on Matlab code by Marco Saerens
# IE School of Biology
# Date :  January 2010
# Version 1.0
# Licence GPL v3

setMethod("probPassage", signature(transition = "Transition", origin = "SpatialPoints", goal = "SpatialPoints", theta="numeric"), def = function(transition, origin, goal, theta)
	{
		transition <- .transitionSolidify(transition)
		tc <- transitionCells(transition)
		cellnri <- cellFromXY(transition, origin)
		cellnrj <- cellFromXY(transition, goal)
		ci <- match(cellnri,tc)
		cj <- match(cellnrj,tc)
		
		result <- .randomShPaths(transition, ci, cj, theta, tc)
		return(result)
	}
)

setMethod("probPassage", signature(transition = "Transition", origin = "RasterLayer", goal = "RasterLayer", theta="numeric"), def = function(transition, origin, goal, theta)
	{
		#check if Transition and RasterLayers coincide
		transition <- .transitionSolidify(transition)
		tc <- transitionCells(transition)
		ci <- which(values(origin))
		cj <- which(values(goal))
		result <- .randomShPaths(transition, ci, cj, theta, tc)
		return(result)
	}
)

.randomShPaths <- function(transition, ci, cj, theta, tc)
{
	if(theta<0 | theta > 20 ) {stop("theta value out of range (between 0 and 20)")}
	
	tr <- transitionMatrix(transition)
	
	trR <- tr
	trR@x <- 1 / trR@x 
	nr <- dim(tr)[1] 
	Id <- Diagonal(nr) 
	rs <- rowSums(tr)
	rs[rs>0] <- 1/rs[rs>0]
	P <- tr * rs

	W <- trR
	W@x <- exp(-theta * trR@x)
	W <- W * P 
	Ij <- Diagonal(nr)
	Ij[cbind(cj,cj)] <- 1 - 1 / length(cj)
	Wj <- Ij %*% W
	
	ei <- ej <- rep(0,times=nr)
	ei[ci] <- 1 / length(ci)
	ej[cj] <- 1 / length(cj)
	
	IdMinusWj <- as((Id - Wj), "dgCMatrix")
	
	zci <- solve(t(IdMinusWj),ei)
	zcj <- solve(IdMinusWj, ej)
	zcij <- sum(ei*zcj)
	
	# Computation of the cost dij between node i and node j
	# dij <- (t(zci) %*% (trR * Wj) %*% zcj) / zcij
	
	# Computation of the matrix N, containing the number of passages through
    # each arc
	N <- (Diagonal(nr, as.vector(zci)) %*% Wj %*% Diagonal(nr, as.vector(zcj))) / zcij

    # Computation of the vector n, containing the number of visits in
    # each node
	n <- rowSums(N)
	
	# Computation of the matrix Pr, containing the transition
    # probabilities
	#Pr <- N * (1 / n)
	
	result <- as(transition,"RasterLayer")
	dataVector <- rep(NA,times=ncell(result))
	dataVector[tc] <- n
	result <- setValues(result, dataVector)
	return(result)
}