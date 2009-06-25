# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version beta
# Licence GPL v3

setGeneric("geoCorrection", function(transition, ...) standardGeneric("geoCorrection"))

setMethod("geoCorrection", signature(transition = "Transition"), def = function(transition, type, multiplicationMatrix)
	{
		if(isLatLon(transition)){}
		if (type != 1 & type != 2){stop("type can only be 1 or 2")}
		adjacency <- .adjacency.from.transition(transition)
		correction <- cbind(xyFromCell(transition,adjacency[,1]),xyFromCell(transition,adjacency[,2]))
		correctionValues <- 1/pointDistance(correction[,1:2],correction[,3:4],type='GreatCircle')
		if (type==2)
		{
			rows <- rowFromCell(transition,adjacency[,1]) != rowFromCell(transition,adjacency[,2])
			corrFactor <- cos((pi/180) * rowMeans(cbind(correction[rows,2],correction[rows,4]))) #low near the poles
			correctionValues[rows] <- correctionValues[rows] * corrFactor #makes conductance lower in N-S direction towards the poles
		}
		i <- as.integer(adjacency[,1] - 1)
		j <- as.integer(adjacency[,2] - 1)
		x <- as.vector(correctionValues)
		dims <- ncell(transition)
		correctionMatrix <- new("dgTMatrix", i = i, j = j, x = x, Dim = as.integer(c(dims,dims)))
		correctionMatrix <- (as(correctionMatrix,"symmetricMatrix"))
		correctionMatrix <- (as(correctionMatrix,"dsCMatrix"))
		if(!multiplicationMatrix) 
		{
			transitionCorrected <- correctionMatrix * as(transition, "dsCMatrix")
			transitionMatrix(transition) <- transitionCorrected
			return(transition)
		}	
		if(multiplicationMatrix)
		{
			transitionMatrix(transition) <- correctionMatrix
			return(transition)
		}
	}
)