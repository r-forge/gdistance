# Author: Jacob van Etten, jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

setClass(Class="TransitionData",
		representation = representation(
			transitionMatrix = "sparseMatrix",
			transitionCells = "integer",
			matrixValues = "character"
		),
		validity = function(object){
			#cond1 <- (nrow(transitionMatrix(object)) == ncol(transitionMatrix(object))) 
			#cond2 <- (object@matrixValues == "resistance" | object@matrixValues == "conductance")
			#cond3 <- length(transitionCells(object)) == object@transitionMatrix@Dim[1]
			#cond <- cond1 & cond2 & cond3 
			cond <- TRUE
			return(cond)
	}
)
setClass(Class="TransitionLayer",
		contains = c("Raster", "TransitionData"),
		validity = function(object){
			cond <- (nrow(object) * ncol(object)) >= max(transitionCells(object))
			return(cond)
	}
)

setClass ("TransitionStack",
	contains = "Raster",
	representation (
			transition = "list"
		),
	validity = function(object) {return(TRUE)}
)

setMethod ("initialize", "TransitionData", function(.Object,...){
			return(.Object)
		}
)

setMethod ("initialize", "TransitionLayer",
		function(.Object,nrows,ncols,xmin,xmax,ymin,ymax,projection=""){
			ncells <- as.integer(nrows*ncols)
			extent <- extent(xmin, xmax, ymin, ymax)
			.Object@extent <- extent
			.Object@nrows <- as.integer(nrows)
			.Object@ncols <- as.integer(ncols)
			if(class(projection) != "CRS"){projection <- CRS(projection)}
			.Object@crs <- projection
			.Object@transitionMatrix <- Matrix(0,ncells,ncells)
			.Object@transitionCells <- 1:ncells
			.Object@matrixValues <- "conductance"
			return(.Object)
		}
)

setMethod ("initialize", "TransitionStack",
		function(.Object,nrows,ncols,xmin,xmax,ymin,ymax,projection=""){
			ncells <- as.integer(nrows*ncols)
			extent <- extent(xmin, xmax, ymin, ymax)
			.Object@extent <- extent
			.Object@nrows <- as.integer(nrows)
			.Object@ncols <- as.integer(ncols)
			if(class(projection) != "CRS"){projection <- CRS(projection)}
			.Object@crs <- projection
			#.Object@transitionMatrix <- NULL
			#.Object@transitionCells <- NULL
			#.Object@matrixValues <- NULL
			return(.Object)
		}
)

setMethod ("show" , "TransitionLayer", 
		function(object) {
			cat("class       :" , class(object), "\n")
			cat("nrows       :" , nrow(object), "\n")
			cat("ncols       :" , ncol(object), "\n")
			cat("ncells      :" , nrow(object) * ncol(object), "\n")
			cat("xmin        :" , xmin(object), "\n")
			cat("xmax        :" , xmax(object), "\n")
			cat("ymin        :" , ymin(object), "\n")
			cat("ymax        :" , ymax(object), "\n")
			cat("xres        :" , (xmax(object) - xmin(object)) / ncol(object), "\n")
			cat("yres        :" , (ymax(object) - ymin(object)) / nrow(object), "\n")
			cat("projection  :", projection(object), "\n")
			cat("values      :", matrixValues(object), "\n")
			cat("matrix class:", class(transitionMatrix(object)), "\n")
		}
)

setMethod ("show" , "TransitionStack", 
		function(object) {
			cat("class       :" , class(object), "\n")
			cat("nrows       :" , nrow(object), "\n")
			cat("ncols       :" , ncol(object), "\n")
			cat("ncells      :" , nrow(object) * ncol(object), "\n")
			cat("xmin        :" , xmin(object), "\n")
			cat("xmax        :" , xmax(object), "\n")
			cat("ymin        :" , ymin(object), "\n")
			cat("ymax        :" , ymax(object), "\n")
			cat("xres        :" , (xmax(object) - xmin(object)) / ncol(object), "\n")
			cat("yres        :" , (ymax(object) - ymin(object)) / nrow(object), "\n")
			cat("projection  :", projection(object), "\n")
			cat("layers      :", nlayers(object), "\n")
		}
)

setAs("TransitionLayer", "sparseMatrix", function(from){from@transitionMatrix})

setAs("TransitionData", "sparseMatrix", function(from){from@transitionMatrix})

setAs("TransitionLayer", "RasterLayer", function(from)
	{
		raster(xmn=xmin(from), xmx=xmax(from), ymn=ymin(from), ymx=ymax(from), nrows=nrow(from), ncols=ncol(from), crs=projection(from))
	}
)

setAs("RasterLayer", "TransitionLayer", function(from){
		new("TransitionLayer",nrows=from@nrows,ncols=from@ncols,xmin=from@xmin,xmax=from@xmax,ymin=from@ymin,ymax=from@ymax,projection=projection(from,asText=FALSE))
	}
)

setAs("TransitionLayer", "TransitionStack", function(from){
		TS <- new("TransitionStack", nrows=nrow(from), ncols=ncol(from), 
			xmin=xmin(from), xmax=xmax(from), 
			ymin=ymin(from), ymax=ymax(from), 
			projection=projection(from))
		TS@transition <- list(as(from, "TransitionData"))
		return(TS)
	}
)

setAs("TransitionLayer", "TransitionData", function(from){
		TD <- new("TransitionData")
		TD@transitionMatrix <- from@transitionMatrix
		TD@transitionCells <- from@transitionCells
		TD@matrixValues <- from@matrixValues
		return(TD)
	}
)