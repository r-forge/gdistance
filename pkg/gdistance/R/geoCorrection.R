# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version beta
# Licence GPL v3

setGeneric("geoCorrection", function(transition, ...) standardGeneric("geoCorrection"))

setMethod("geoCorrection", signature(transition = "Transition"), def = 
gc<- function(transition, type)
	{
		if(isLatLon(transition)){}
		else{warning("projection not geographic; are you sure you want to do this?")}
		if (type== "resistance" | type=="cost"){}else{stop("unknown type of projection correction; only 'cost' and 'resistance' are defined")}
		adjacency <- .adjacency.from.transition(transition)
		correction <- cbind(xyFromCell(transition,adjacency[,1]),xyFromCell(transition,adjacency[,2]))
		correctionValues <- 1/pointDistance(correction[,1:2],correction[,3:4],type='GreatCircle')
		if (type=="resistance")
		{
			rows <- rowFromCell(transition,adjacency[,1]) != rowFromCell(transition,adjacency[,2])
			correctionValues[rows] <- 1/(correctionValues[rows] * cos((pi/180) * rowMeans(cbind(correction[rows,2],correction[rows,4])))) 
		}
		i <- as.integer(adjacency[,1] - 1)
		j <- as.integer(adjacency[,2] - 1)
		x <- as.vector(correctionValues)
		dims <- ncell(transition)
		correctionMatrix <- new("dgTMatrix", i = i, j = j, x = x, Dim = as.integer(c(dims,dims)))
		correctionMatrix <- (as(correctionMatrix,"symmetricMatrix"))
		correctionMatrix <- (as(correctionMatrix,"dsCMatrix"))
		transitionCorrected <- correctionMatrix * as(transition, "dsCMatrix")
		transitionMatrix(transition) <- transitionCorrected
		return(transition)
	}
)