# Author: Jacob van Etten, jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

setClass(Class="Transition",
		contains = "Raster",
		representation = representation(
			transitionMatrix = "dsCMatrix",
			transitionCells = "integer"
		),
		validity = function(object){
			cond <- (nrow(object) * ncol(object)) >= object@transitionMatrix@Dim[1]
			return(cond)
	}
)

setMethod ("show" , "Transition", 
		function(object) {
			cat("class     :" , class(object), "\n")
			cat("nrows     :" , nrow(object), "\n")
			cat("ncols     :" , ncol(object), "\n")
			cat("ncells    :" , nrow(object) * ncol(object), "\n")
			cat("xmin      :" , xmin(object), "\n")
			cat("xmax      :" , xmax(object), "\n")
			cat("ymin      :" , ymin(object), "\n")
			cat("ymax      :" , ymax(object), "\n")
			cat("xres      :" , (xmax(object) - xmin(object)) / ncol(object) , "\n")
			cat("yres      :" , (ymax(object) - ymin(object)) / nrow(object)  , "\n")
			cat("projection:", projection(object))
			cat ("\n")
		}
)

setMethod ("initialize", "Transition",
		function(.Object,nrows,ncols,xmin,xmax,ymin,ymax,projection)
		{
			ncells <- as.integer(nrows*ncols)
			bbox <- newBbox(xmin, xmax, ymin, ymax)
			.Object@bbox <- bbox
			.Object@nrows <- as.integer(nrows)
			.Object@ncols <- as.integer(ncols)
			.Object@crs <- projection
			.Object@transitionMatrix@uplo <- "U"
			.Object@transitionMatrix@p <- as.integer(rep(0,ncells+1))
			.Object@transitionMatrix@i <- integer(0)
			.Object@transitionMatrix@Dim <- as.integer(c(ncells,ncells))
			#.Object@transitionMatrix@x can stay this way?
			.Object@transitionCells <- 1:ncells
			return(.Object)
		}
)

setAs("Transition", "dsCMatrix", function(from){from@transitionMatrix})

setAs("Transition", "RasterLayer", function(from)
	{
		newRaster(xmn=xmin(from), xmx=xmax(from), ymn=ymin(from), ymx=ymax(from), nrows=nrow(from), ncols=ncol(from), projstring=projection(from))
	}
)

setAs("RasterLayer", "Transition", function(from)
	{
		new("Transition",nrows=from@nrows,ncols=from@ncols,xmin=from@xmin,xmax=from@xmax,ymin=from@ymin,ymax=from@ymax,projstring=from@crs)
	}
)
	
