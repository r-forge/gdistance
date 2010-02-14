# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version beta
# Licence GPL v3

setGeneric("geoCorrection", function(transition, type, ...) standardGeneric("geoCorrection"))

setMethod("geoCorrection", signature(transition = "Transition", type="character"), def = function(transition, type, multpl=FALSE, scl=TRUE)
	{
		if(isLatLon(transition))
		{
			if (type != "c" & type != "r"){stop("type can only be c or r")}
			if (type == "r" & matrixValues(transition) != "conductance"){stop("matrix of Transition object must have conductance values")}
			adjacency <- .adjacency.from.transition(transition)
			correction <- cbind(xyFromCell(transition,adjacency[,1]),xyFromCell(transition,adjacency[,2]))
			scaleValue <- pointDistance(c(0,0),c(xres(transition),0),type="GreatCircle")
			if(matrixValues(transition) == "conductance") {correctionValues <- 1/(pointDistance(correction[,1:2],correction[,3:4],type='GreatCircle')/scaleValue)}
			if(matrixValues(transition) == "resistance") {correctionValues <- pointDistance(correction[,1:2],correction[,3:4],type='GreatCircle')/scaleValue}
			if (type=="r")
			{
				rows <- rowFromCell(transition,adjacency[,1]) != rowFromCell(transition,adjacency[,2])
				if(matrixValues(transition) == "conductance") {corrFactor <- cos((pi/180) * rowMeans(cbind(correction[rows,2],correction[rows,4])))} #low near the poles
				if(matrixValues(transition) == "resistance") {corrFactor <- 1 / (cos((pi/180) * rowMeans(cbind(correction[rows,2],correction[rows,4]))))} #high near the poles
				correctionValues[rows] <- correctionValues[rows] * corrFactor #makes conductance lower in N-S direction towards the poles
			}
		}
		else{stop("not yet implemented for this projection. Contact package author.")}
		i <- as.integer(adjacency[,1] - 1)
		j <- as.integer(adjacency[,2] - 1)
		x <- as.vector(correctionValues)
		dims <- ncell(transition)
		correctionMatrix <- new("dgTMatrix", i = i, j = j, x = x, Dim = as.integer(c(dims,dims)))
		correctionMatrix <- (as(correctionMatrix,"sparseMatrix"))
		if(class(transitionMatrix(transition)) == "dsCMatrix"){correctionMatrix <- forceSymmetric(correctionMatrix)}
		if(!multpl) 
		{
			transitionCorrected <- correctionMatrix * as(transition, "sparseMatrix")
			transitionMatrix(transition) <- transitionCorrected
			return(transition)
		}	
		if(multpl)
		{
			transitionMatrix(transition) <- correctionMatrix
			return(transition)
		}
	}
)