# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

setGeneric("transitionMatrix", function(transition, inflate) standardGeneric("transitionMatrix"))

setMethod ("transitionMatrix", signature(transition = "TransitionLayer", inflate="missing"),
	function(transition)
	{
		transitionMatrix(transition=transition, inflate=TRUE)
	}
)

setMethod ("transitionMatrix", signature(transition = "TransitionLayer", inflate="logical"),
	function(transition, inflate)
	{
		.tr(transition, inflate)
	}
)

setMethod ("transitionMatrix", signature(transition = "TransitionData", inflate="missing"),
	function(transition)
	{
		transitionMatrix(transition=transition, inflate=TRUE)
	}
)

setMethod ("transitionMatrix", signature(transition = "TransitionData", inflate="logical"),
	function(transition, inflate)
	{
		.tr(transition, inflate)
	}
)

.tr <- function(transition,inflate)
{
	if(inflate & length(transitionCells(transition)) != ncell(transition))
	{
		tr <- Matrix(0, ncell(transition),ncell(transition))
		cells <- transitionCells(transition)
		tr[cells,cells] <- transition@transitionMatrix
	}
	if(!inflate | length(transitionCells(transition)) == ncell(transition))
	{
		tr <- transition@transitionMatrix
	}
	return(tr)
}


setGeneric("transitionMatrix<-", function(transition, value) standardGeneric("transitionMatrix<-"))

setReplaceMethod ("transitionMatrix", signature(transition = "TransitionLayer", value = "sparseMatrix"),
	function(transition, value)
	{
		if(dim(value)[1] != dim(value)[2]){stop("sparse matrix has to be square")}
		if(dim(value)[1] != ncell(transition)[2]){stop("sparse matrix has to have ncell(transition) rows and columns")}
		transition@transitionMatrix <- value
		transition@transitionCells <- 1:ncell(transition)
		return(transition)
	}
)

setGeneric("transitionCells", function(transition) standardGeneric("transitionCells"))

setMethod ("transitionCells", signature(transition = "TransitionLayer"),
	function(transition)
	{
		return(transition@transitionCells)
	}
)

setGeneric("matrixValues", function(transition) standardGeneric("matrixValues"))

setMethod ("matrixValues", signature(transition = "TransitionLayer"),
	function(transition){transition@matrixValues}
)

setMethod ("matrixValues", signature(transition = "TransitionStack"),
	function(transition){stop("not implemented yet")}
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
		tm <- transitionMatrix(x)
		tm <- tm[i,j]
		return(tm)
	}
)

setMethod("[", signature(x = "TransitionLayer", i="matrix", j="missing", drop="missing"), function(x,i)
	{
		tm <- transitionMatrix(x)
		tm <- tm[i]
		return(tm)
	}
)

setMethod("[<-", signature(x = "TransitionLayer", i="matrix", j="missing", value="ANY"),
		function(x, i, value){
			tm <- transitionMatrix(x)
			tm[i] <- value
			x@transitionMatrix <- tm
			return(x)
		}
)

setMethod("[<-", signature(x = "TransitionLayer", i="numeric", j="numeric", value="ANY"),
		function(x, i, j, value)
		{
			tm <- transitionMatrix(x)
			tm[i,j] <- value
			transitionMatrix(x) <- tm
			return(x)
		}
)

setGeneric("transitionMatrix<-", function(transition, value) standardGeneric("transitionMatrix<-"))

setReplaceMethod ("transitionMatrix", signature(transition = "TransitionLayer", value = "sparseMatrix"),
	function(transition, value){
		if(dim(value)[1] != dim(value)[2]){stop("sparse matrix has to be square")}
		if(dim(value)[1] == ncell(transition)){transition@transitionMatrix <- value}
		else
		{
			if(dim(value)[1] == length(transitionCells(transition)))
			{
				trC <- transitionCells(transition)
				tr <- Matrix(0,ncell(transition),ncell(transition))
				tr[trC,trC] <- value
				transition@transitionMatrix <- tr
			}
			else{stop("value is of wrong dimensions; either ncell(transition) or length(transitionCells(transition))")}
		}
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
				result@transition <- x@transition[i]
			}
		}
		return(result)
	}
)

setMethod("[[<-", signature(x = "TransitionStack", i="numeric", j="missing", value="TransitionData"), function(x,i, value)
	{
		x@transition[[i]] <- value
		return(x)
	}
)

setGeneric("transitionData", function(transition) standardGeneric("transitionData"))

setMethod ("transitionData", signature(transition = "TransitionLayer"),
	function(transition){
		as(transition, "TransitionData")
	}
)

setMethod ("transitionData", signature(transition = "TransitionStack"),
	function(transition){
		transition@transition
	}
)