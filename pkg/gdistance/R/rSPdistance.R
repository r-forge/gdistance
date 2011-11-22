rSPDistance <- function(transition, fromCoords, toCoords)
{
	if(theta < 0 | theta > 20 ) {stop("theta value out of range (between 0 and 20)")}
	
	cellnri <- cellFromXY(transition, origin)
	cellnrj <- cellFromXY(transition, goal)
	transition <- .transitionSolidify(transition)
	tc <- transitionCells(transition)

	ci <- match(cellnri,tc)
	cj <- match(cellnrj,tc)
		
	tr <- transitionMatrix(transition, inflate=FALSE)
	
}

.rSPDist <- function(tr, ci, cj, theta, tc)
{
	trR <- tr
	trR@x <- 1 / trR@x 
	nr <- dim(tr)[1] 
	Id <- Diagonal(nr) 
	rs <- rowSums(tr)
	rs[rs>0] <- 1/rs[rs>0]
	P <- tr * rs

	W <- trR
	W@x <- exp(-theta * trR@x) #zero values are not relevant because of next step exp(-theta * trR@x) 
	W <- W * P 


	Ij <- Diagonal(nr)
	Ij[cbind(cj,cj)] <- 1 - 1 / length(cj)
	Wj <- Ij %*% W
	
	ei <- rep(0,times=nr)
	ei[ci] <- 1 / length(ci)
	
	ej <- rep(0,times=nr)

	ej[cj] <- 1 / length(cj)
	
	IdMinusWj <- as((Id - Wj), "dgCMatrix")
	
	zci <- solve(t(IdMinusWj),ei)
	zcj <- solve(IdMinusWj, ej)
	zcij <- sum(ei*zcj)

	# Computation of the cost dij between node i and node j
	dij <- (t(zci) %*% (trR * Wj) %*% zcj) / zcij

}