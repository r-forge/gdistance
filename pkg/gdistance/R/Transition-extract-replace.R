# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

setGeneric("transitionMatrix", function(transition) standardGeneric("transitionMatrix"))

setMethod ("transitionMatrix", signature(transition = "TransitionLayer"),
	function(transition){
		transition@transitionMatrix
	}
)

setMethod ("transitionMatrix", signature(transition = "TransitionData"),
	function(transition){
		transition@transitionMatrix
	}
)

setGeneric("transitionMatrix<-", function(transition, value) standardGeneric("transitionMatrix<-"))

setReplaceMethod ("transitionMatrix", signature(transition = "TransitionLayer", value = "sparseMatrix"),
	function(transition, value){
		if(dim(value)[1] != dim(value)[2]){stop("sparse matrix has to be square")}
		transition@transitionMatrix <- value
		return(transition)
	}
)

setGeneric("transitionCells", function(transition = "TransitionLayer") standardGeneric("transitionCells"))

setMethod ("transitionCells", signature(transition = "TransitionLayer"),
	function(transition){
		transition@transitionCells
	}
)

setGeneric("matrixValues", function(transition = "TransitionLayer") standardGeneric("matrixValues"))

setMethod ("matrixValues", signature(transition = "TransitionLayer"),
	function(transition){
		transition@matrixValues
	}
)

setGeneric("matrixValues<-", function(transition, value) standardGeneric("matrixValues<-"))

setReplaceMethod ("matrixValues", signature(transition = "TransitionLayer", value = "character"),
	function(transition, value){
		if (value == "resistance" | value == "conductance") 
		{
			transition@matrixValues <- value
			return(transition)
		}
		else {stop("matrixValues can only be set to resistance or conductance")}
	}
)

setMethod("[", signature(x = "TransitionLayer", i="numeric", j="numeric", drop="missing"), function(x,i,j)
	{
		i <- as.integer(i)
		if (!((all(i %in% transitionCells(x)) || all(-i %in% transitionCells(x))) && (all(j %in% transitionCells(x)) || all(-j %in% transitionCells(x))))){stop("wrong cell numbers")}
		else
		{
			if (all(i %in% transitionCells(x)))
			{
				indi <- match(i,transitionCells(x))
				indj <- match(j,transitionCells(x))
				tm <- transitionMatrix(x)
				tm <- tm[indi,indj]
			}
			if (all(-i %in% transitionCells(x)))
			{
				indi <- match(-i,transitionCells(x))
				indj <- match(-j,transitionCells(x))
				tm <- transitionMatrix(x)
				tm <- tm[-indi,-indj]
			}
		}
	return(tm)
	}
)

setMethod("[", signature(x = "TransitionLayer", i="matrix", j="missing", drop="missing"), function(x,i)
	{
		if (!(all(i[,1] %in% transitionCells(x))  && all(i[,2] %in% transitionCells(x)))){stop("wrong cell numbers")}
		else
		{
			indi <- match(i[,1],transitionCells(x))
			indj <- match(i[,2],transitionCells(x))
			ind <- cbind(indi,indj)
			tm <- as(x,"sparseMatrix")
			tm <- tm[ind]
		}
	return(tm)
	}
)

setMethod("[<-", signature(x = "TransitionLayer", i="matrix", j="missing", value="ANY"),
		function(x, i, value){
			if (!all(i[,1] %in% transitionCells(x)) || !all(i[,2] %in% transitionCells(x))){stop("wrong cell numbers")}
			else
			{
				if (!all(i %in% transitionCells(x)))
				{
					ind1 <- match(i[,1],transitionCells(x))
					ind2 <- match(i[,2],transitionCells(x))
					ind <- cbind(ind1,ind2)
					tm <- transitionMatrix(x)
					tm[ind] <- value
					x@transitionMatrix <- tm
				}
			}
			return(x)
		}
)

setMethod("[<-", signature(x = "TransitionLayer", i="numeric", j="numeric", value="ANY"),
		function(x, i, j, value)
		{
			#stop("not yet implemented; request package author to implement this method")
			i <- as.integer(i)
			j <- as.integer(j)
			if (!((all(i %in% transitionCells(x)) || all(-i %in% transitionCells(x))) && (all(j %in% transitionCells(x)) || all(-j %in% transitionCells(x))))){stop("wrong cell numbers")}
			else
			{
				ind1 <- match(i,transitionCells(x))
				ind2 <- match(j,transitionCells(x))
				tm <- transitionMatrix(x)
				tm[ind1,ind2] <- value
				transitionMatrix(x) <- tm
			}
			return(x)
		}
)

setGeneric("transitionMatrix<-", function(transition, value) standardGeneric("transitionMatrix<-"))

setReplaceMethod ("transitionMatrix", signature(transition = "TransitionLayer", value = "sparseMatrix"),
	function(transition, value){
		if(dim(value)[1] != dim(value)[2]){stop("sparse matrix has to be square")}
		transition@transitionMatrix <- value
		return(transition)
	}
)

setMethod('nlayers', signature(object='TransitionStack'), 
	function(object)
	{
		return(length(object@transition)) 
    }
)


setMethod("[[", signature(x = "TransitionStack", i="numeric", j="missing"), function(x,i)
	{
		if (!(all(i %in% 1:nlayers(x)))){stop("indices should correspond to layers")}
		else
		{
			if(length(i)==1)
			{
				result <- new("TransitionLayer", nrows=nrow(x),ncols = ncol(x),xmin = xmin(x),xmax = xmax(x),
				ymin = ymin(x), ymax = ymax(x), projection=projection(x))
				result@transitionMatrix <- x@transition[[i]]@transitionMatrix
				result@transitionCells <- x@transition[[i]]@transitionCells
				result@matrixValues <- x@transition[[i]]@matrixValues
			}			
			if(length(i)>1)
			{
				result <- x
				result@transition <- x@transition[[i]]
			}
		}
	return(result)
	}
)