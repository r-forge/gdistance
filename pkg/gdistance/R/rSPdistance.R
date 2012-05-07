rSPDistance <- function(transition, from, to, theta)
{
	if(theta < 0 | theta > 20 ) {stop("theta value out of range (between 0 and 20)")}
	
	cellnri <- cellFromXY(transition, from)
	cellnrj <- cellFromXY(transition, to)
	transition <- .transitionSolidify(transition)
	tc <- transitionCells(transition)

	ci <- match(cellnri,tc)
	cj <- match(cellnrj,tc)
		
	tr <- transitionMatrix(transition, inflate=FALSE)
	
	.rSPDist(tr, ci, cj, theta, tc)
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

	D <- matrix(0, nrow=length(ci), ncol=length(cj))
	
	for(j in 1:length(cj))
	{
		Ij <- Diagonal(nr)
		Ij[cj[j],cj[j]] <- 0
		Wj <- Ij %*% W
		IdMinusWj <- as((Id - Wj), "dgCMatrix")		
		ej <- rep(0,times=nr)
		ej[cj[j]] <- 1

		for(i in 1:length(ci))
		{
			ei <- rep(0,times=nr)
			ei[ci[i]] <- 1
	
			zci <- solve(t(IdMinusWj),ei)
			zcj <- solve(IdMinusWj, ej)
			zcij <- sum(ei*zcj)

			# Computation of the cost dij between node i and node j
			D[i,j] <- as.vector((t(zci) %*% (trR * Wj) %*% zcj) / zcij)
		}
	}
	
	D
}