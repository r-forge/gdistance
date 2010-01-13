# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

TransitionMap <- function(transition)
{
	rs <- as(transition,"RasterLayer")
	dataVector <- vector(length=ncell(transition))
	dataVector[transitionCells(transition)] <- colSums(as(transition,"sparseMatrix")) #should be divided by the number of connections (non-zero values)
	rs <- setValues(rs, dataVector) 
	return(rs)
}