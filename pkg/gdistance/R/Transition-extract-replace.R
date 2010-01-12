# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

setGeneric("transitionMatrix", function(transition) standardGeneric("transitionMatrix"))

setMethod ("transitionMatrix", signature(transition = "Transition"),
	function(transition){
		transition@transitionMatrix
	}
)

setGeneric("transitionMatrix<-", function(transition, value) standardGeneric("transitionMatrix<-"))

setReplaceMethod ("transitionMatrix", signature(transition = "Transition", value = "sparseMatrix"),
	function(transition, value){
		#if(dim(transitionMatrix(transtion) != dim(sparseMatrix)){warning(unequal dimensions)}
		transition@transitionMatrix <- value
		return(transition)
	}
)

setGeneric("transitionCells", function(transition = "Transition") standardGeneric("transitionCells"))

setMethod ("transitionCells", signature(transition = "Transition"),
	function(transition){
		transition@transitionCells
	}
)

setGeneric("matrixValues", function(transition = "Transition") standardGeneric("matrixValues"))

setMethod ("matrixValues", signature(transition = "Transition"),
	function(transition){
		transition@matrixValues
	}
)

setGeneric("matrixValues<-", function(transition, value) standardGeneric("matrixValues<-"))

setReplaceMethod ("matrixValues", signature(transition = "Transition", value = "character"),
	function(transition, value){
		if (value == "resistance" | value == "conductance") 
		{
			transition@matrixValues <- value
			return(transition)
		}
		else {stop("matrixValues can only be set to resistance or conductance")}
	}
)

setMethod("[", signature(x = "Transition", i="index", j="missing", drop="missing"), function(x,i)
	{
		i <- as.integer(i)
		if (!(all(i %in% x@transitionCells) || all(-i %in% x@transitionCells))){stop("wrong cell numbers")}
		else
		{
			if (all(i %in% x@transitionCells))
			{
				ind <- match(i,x@transitionCells)
				tm <- as(x,"sparseMatrix")
				x@transitionMatrix <- tm[ind,ind]
				x@transitionCells <- i
			}
			if (all(-i %in% x@transitionCells))
			{
				ind <- match(-i,x@transitionCells)
				tm <- as(x,"sparseMatrix")
				x@transitionMatrix <- tm[-ind,-ind]
				x@transitionCells <- x@transitionCells[!(x@transitionCells %in% -i)]
			}
		}
	return(x)
	}
)

setMethod("[", signature(x = "Transition", i="index", j="index", drop="missing"), function(x,i,j)
	{
		i <- as.integer(i)
		if (!((all(i %in% x@transitionCells) || all(-i %in% x@transitionCells)) && (all(j %in% x@transitionCells) || all(-j %in% x@transitionCells)))){stop("wrong cell numbers")}
		else
		{
			if (all(i %in% x@transitionCells))
			{
				indi <- match(i,x@transitionCells)
				indj <- match(j,x@transitionCells)
				tm <- as(x,"sparseMatrix")
				tm <- tm[indi,indj]
			}
			if (all(-i %in% x@transitionCells))
			{
				indi <- match(-i,x@transitionCells)
				indj <- match(-j,x@transitionCells)
				tm <- as(x,"sparseMatrix")
				tm <- tm[-indi,-indj]
			}
		}
	return(tm)
	}
)

setMethod("[", signature(x = "Transition", i="matrix", j="missing", drop="missing"), function(x,i)
	{
		if (!(all(i[,1] %in% x@transitionCells)  && all(i[,2] %in% x@transitionCells))){stop("wrong cell numbers")}
		else
		{
			indi <- match(i[,1],x@transitionCells)
			indj <- match(i[,2],x@transitionCells)
			ind <- cbind(indi,indj)
			tm <- as(x,"sparseMatrix")
			tm <- tm[ind]
		}
	return(tm)
	}
)

setMethod("[<-", signature(x = "Transition", i="index", j="missing", value="sparseMatrix"),
		function(x, i, value){
			if (!all(i %in% x@transitionCells) && !all(-i %in% x@transitionCells)){stop("wrong cell numbers")}
			else
			{
				if (!all(i %in% x@transitionCells))
				{
					ind <- match(i,x@transitionCells)
					tm <- as(x,"sparseMatrix")
					tm[ind,ind] <- value
					x@transitionMatrix <- tm
				}
				if (!all(-i %in% x@transitionCells))
				{
					ind <- match(-i,x@transitionCells)
					tm <- as(x,"sparseMatrix")
					tm[-ind,-ind] <- value
					x@transitionMatrix <- tm
				}
			}
			return(x)
		}
)

setMethod("[<-", signature(x = "Transition", i="matrix", j="missing", value="ANY"),
		function(x, i, value){
			if (!all(i[,1] %in% x@transitionCells) || !all(i[,2] %in% x@transitionCells)){stop("wrong cell numbers")}
			else
			{
				if (!all(i %in% x@transitionCells))
				{
					ind1 <- match(i[,1],x@transitionCells)
					ind2 <- match(i[,2],x@transitionCells)
					ind <- cbind(ind1,ind2)
					tm <- as(x,"sparseMatrix")
					tm[ind] <- value
					x@transitionMatrix <- tm
				}
			}
			return(x)
		}
)

setMethod("[<-", signature(x = "Transition", i="index", j="index", value="ANY"),
		function(x, i, j, value){
		stop("not yet implemented; request package author to implement this method")
		}
)