# Author: Jacob van Etten jacobvanetten@yahoo.com
# Date :  November 2013
# Version 1.2
# Licence GPL v3

adjacencyFromTransition <- function(x)
{
  tc <- transitionCells(x)
  x <- transitionMatrix(x)
	transition.dgT <- as(x,"dgTMatrix")
	adjacency <- cbind(transition.dgT@i+1,transition.dgT@j+1)
  adjacency <- cbind(tc[adjacency[,1]], tc[adjacency[,2]])
	return(adjacency)
}