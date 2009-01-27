# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

setMethod("Arith", signature(e1 = "Transition", e2 = "Transition"),
		function(e1, e2){
			if(as(e1, "BasicRaster") == as(e2, "BasicRaster"))
				{
					matrix.dsC <- callGeneric(as(e1,"dsCMatrix"),as(e2,"dsCMatrix"))
					transitionMatrix(e1) <- matrix.dsC
					return(e1)
				}
			else {stop("transition matrices do not coincide in resolution, extent and/or projection")}
		}
)

setMethod("Arith", signature(e1 = "Transition", e2 = "ANY"),
		function(e1, e2){
			matrix.dsC <- callGeneric(as(e1,"dsCMatrix"),e2)
			transitionMatrix(e1) <- matrix.dsC
			return(e1)
		}
)

setMethod("Arith", signature(e1 = "ANY", e2 = "Transition"),
		function(e1, e2){
			matrix.dsC <- callGeneric(e1,as(e2,"dsCMatrix"))
			transitionMatrix(e1) <- matrix.dsC
			return(e1)
		}
)

setMethod("Math", signature(x = "Transition"),
		function(x){
			transitionMatrix(x) <- callGeneric(transitionMatrix(x))
			return(x)
		}
)

setMethod("==", signature(e1 = "Transition", e2 = "Transition"),
		function(e1, e2){
			c1 <- e1@transitionMatrix == e2@transitionMatrix
			c2 <- as(e1, "BasicRaster") == as(e2, "BasicRaster")
			cond <- c1 & c2
			return(cond)
		}
)