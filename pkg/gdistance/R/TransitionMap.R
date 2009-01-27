# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

TransitionMap <- function(transition)
{
	rs <- as(transition,"RasterLayer")
	dataVector <- vector(length=ncells(transition))
	dataVector[transitionCells(transition)] <- colSums(as(transition,"dsCMatrix"))
	rs <- setValues(rs, dataVector) 
	return(rs)
}