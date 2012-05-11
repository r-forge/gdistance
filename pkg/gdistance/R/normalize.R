# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  March 2010
# Version beta
# Licence GPL v3

setGeneric("normalize", function(x, ...) standardGeneric("normalize"))

setMethod("normalize", signature(x = "TransitionLayer"), def = function(x, method="row")
	{
		tr <- transitionMatrix(x)
		tr <- .normalize(x, method)
		transitionMatrix(x) <- tr
		return(x)
	}
)

.normalize <- function(x, method)
	{
		
		if(!(method %in% c("row","col","symm"))){stop("invalid method argument")}
		if(method=="symm")
		{
			stop("not yet implemented.")
			rs <- (rowSums(tr)^-.5)
			rs[rs == Inf] <- 0
			tr <- tr * rs
			tr <- t(tr)
			cs <- colSums(tr)^-.5
			cs[cs == Inf] <- 0
			tr <- tr * cs
		}
		if(method=="row")
		{
			rs <- 1 / rowSums(x)
			rs[rs == Inf] <- 0
			tr <- x * rs
		}
		if(method=="col")
		{
			rs <- 1 / colSums(x)
			rs[rs == Inf] <- 0
			tr <- x * rs
		}

		return(tr)
	}