# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  March 2010
# Version beta
# Licence GPL v3

setGeneric("normalize", function(transition, ...) standardGeneric("normalize"))

setMethod("normalize", signature(transition = "TransitionLayer"), def = function(transition, symm=FALSE)
	{
		return(.normalize(transition, symm))
	}
)

.normalize <- function(transition, symm)
	{
		tr <- transitionMatrix(transition)
		if(symm)
		{
			tr <- t(tr) 
			rs <- (rowSums(tr)^-.5)
			rs[rs == Inf] <- 0
			tr <- tr * rs
			tr <- t(tr)
			cs <- colSums(tr)^-.5
			cs[cs == Inf] <- 0
			tr <- tr * rs
		}
		else
		{
			rs <- 1 / rowSums(tr)
			rs[rs == Inf] <- 0
			tr <- tr * rs
		}
		transitionMatrix(transition) <- tr
		return(transition)
	}