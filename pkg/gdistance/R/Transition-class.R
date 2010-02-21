# Author: Jacob van Etten, jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

setClass(Class="Transition",
		contains = "Raster",
		representation = representation(
			transitionMatrix = "sparseMatrix",
			transitionCells = "integer",
			matrixValues = "character"
		),
		validity = function(object){
			cond1 <- (nrow(object) * ncol(object)) >= object@transitionMatrix@Dim[1]
			cond2 <- (object@matrixValues == "resistance" | object@matrixValues == "conductance")
			return(cond)
	}
)

setMethod ("show" , "Transition", 
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
			cat("matrix class:", class(transitionMatrix(object)))
			cat ("\n")
		}
)

setMethod ("initialize", "Transition",
		function(.Object,nrows,ncols,xmin,xmax,ymin,ymax,projection="")
		{
			ncells <- as.integer(nrows*ncols)
			extent <- extent(xmin, xmax, ymin, ymax)
			.Object@extent <- extent
			.Object@nrows <- as.integer(nrows)
			.Object@ncols <- as.integer(ncols)
			if(class(projection) != "CRS"){projection <- CRS(projection)}
			.Object@crs <- projection
			.Object@transitionMatrix <- Matrix(0,ncells,ncells)
			.Object@transitionCells <- 1:ncells
			return(.Object)
		}
)

setAs("Transition", "sparseMatrix", function(from){from@transitionMatrix})

setAs("Transition", "RasterLayer", function(from)
	{
		raster(xmn=xmin(from), xmx=xmax(from), ymn=ymin(from), ymx=ymax(from), nrows=nrow(from), ncols=ncol(from), projs=projection(from))
	}
)

setAs("RasterLayer", "Transition", function(from)
	{
		new("Transition",nrows=from@nrows,ncols=from@ncols,xmin=from@xmin,xmax=from@xmax,ymin=from@ymin,ymax=from@ymax,crs=projection(from,asText=FALSE))
	}
)
	
