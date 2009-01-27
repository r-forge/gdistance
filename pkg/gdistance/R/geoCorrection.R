# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version beta
# Licence GPL v3

setGeneric("geoCorrection", function(transition, ...) standardGeneric("geoCorrection"))

#a simple diagonal correction should be added: sqrt(2*d) for bishop moves; function name  becomes geographicCorrection
#this wont work for Transition with transitionCells not 1:n

setMethod("geoCorrection", signature(transition = "Transition"), def = function(transition, type)
	{
		if(isLatLon(transition)){}
		else{warning("projection not geographic; are you sure you want to do this?")}
		if (type== "resistance" | type=="cost"){}else{stop("unknown type of projection correction; only 'cost' and 'resistance' are defined")}
		adjacency <- .adjacency.from.transition(transition)
		correction <- cbind(xyFromCell(transition,adjacency[,1]),xyFromCell(transition,adjacency[,2]))
		correctionValues <- 1/apply(correction,1,function(x){distanceGreatcircle(x[1:2],x[3:4])})
		if (type=="resistance")
		{
			rows <- rowFromCell(adjacency[,1]) != rowFromCell(adjacency[,2])
			correctionValues[rows] <- 1/(correctionValues[rows] * cos((pi/180) * rowMeans(cbind(correction[rows,2],correction[rows,4])))) 
		}
		i <- as.integer(adjacency[,1] - 1)
		j <- as.integer(adjacency[,2] - 1)
		x <- as.vector(correctionValues)
		dims <- ncell(transition)
		correctionMatrix <- new("dgTMatrix", i = as.integer(i), j = as.integer(j), x = as.numeric(x), Dim = as.integer(c(dims,dims)))
		correctionMatrix <- (as(correctionMatrix,"symmetricMatrix"))
		correctionMatrix <- (as(correctionMatrix,"dsCMatrix"))
		transitionCorrected <- correctionMatrix * as(transition, "dsCMatrix")
		transitionMatrix(transition) <- transitionCorrected
		return(transition)
	}
)