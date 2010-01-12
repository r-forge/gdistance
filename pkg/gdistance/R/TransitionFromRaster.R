# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

setGeneric("TransitionFromRaster", function(object, transitionFunction, directions, ...) standardGeneric("TransitionFromRaster"))

setMethod("TransitionFromRaster", signature(object = "RasterLayer"), def = function(object, transitionFunction, directions, symm=TRUE)
		{
			if(dataContent(object) != 'all'){stop("only implemented for rasters with all values in memory; use readAll() to read values")}
			transition <- new("Transition",nrows=nrow(object),ncols=ncol(object),xmin=xmin(object),xmax=xmax(object),ymin=ymin(object),ymax=ymax(object),projection=projection(object, asText=FALSE))
			transitionMatr <- as(transition,"sparseMatrix")
			adj <- adjacency(object,which(!is.na(values(object))),which(!is.na(values(object))),directions=directions)
			transition.values <- apply(cbind(values(object)[adj[,1]],values(object)[adj[,2]]),1,transitionFunction)
			if(!all(transition.values>=0)){warning("transition function gives negative values")}
			transitionMatr[adj] <- as.vector(transition.values)
			if(symm){transitionMatr <- try(as(transitionMatr, "symmetricMatrix"))}
			if(class(transitionMatr) != "dsCMatix")
			{
				warning("matrix does not seem symmetric. Applied forecedSymmetric()")
				forceSymmetric
			}
			transitionMatrix(transition) <- transitionMatr
			matrixValues(transition) <- "conductance"
			return(transition) 
		}
)

setMethod("TransitionFromRaster", signature(object = "RasterBrick"), def = function(object, transitionFunction="mahal", directions)
		{
			if(dataContent(object) != 'all'){stop("only implemented for rasters with all values in memory; use readAll() to read values")}
			if(transitionFunction != "mahal")
			{
				stop("only Mahalanobis distance method implemented for RasterBrick")
			}
			x <- cbind(1:ncell(object),values(object))
			x <- na.omit(x)
			dataCells <- x[,1]
			adj <- adjacency(object,dataCells,dataCells,directions=directions)
			x.minus.y <- x[match(adj[,1],x[,1]),-1]-x[match(adj[,2],x[,1]),-1]
			cov.inv <- solve(cov(x[,-1]))
			mahaldistance <- apply(x.minus.y,1,function(x){sqrt((x%*%cov.inv)%*%x)})
			mahaldistance <- mean(mahaldistance)/(mahaldistance+mean(mahaldistance))
			transitiondsC <- new("dsCMatrix", 
					p = as.integer(rep(0,ncell(object)+1)),
					Dim = as.integer(c(ncell(object),ncell(object))),
					Dimnames = list(as.character(1:ncell(object)),as.character(1:ncell(object)))
			)
			transitiondsC[adj] <- mahaldistance
			transition <- new("Transition",nrows=nrow(object),ncols=ncol(object),xmin=xmin(object),xmax=xmax(object),ymin=ymin(object),ymax=ymax(object),projection=projection(object, asText=FALSE), matrixValues="conductance")
			transitionMatrix(transition) <- transitiondsC
			return(transition)
		}
)