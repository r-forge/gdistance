# Author: Jacob van Etten, jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

.adjacency.from.transition <- function(transition)
{
	transition.dsC <- as(transition,"dsCMatrix")
	transition.dgT <- as(transition.dsC,"dgTMatrix")
	adjacency <- cbind(transitionCells(transition)[transition.dgT@i+1],transitionCells(transition)[transition.dgT@j+1])
	return(adjacency)
}

.connected.components <- function(transition)
{
	adj.graph <- graph.adjacency(transition@transitionMatrix)
	clustermembership <- cbind(transitionCells(transition),as.integer(clusters(adj.graph)$membership)+1)
	return(clustermembership)
}

.current <- function(L, Lr, A, n, indexFrom, indexTo) 
{
	e <- matrix(0, ncol=1, nrow=n)
	e[indexFrom,] <- 1
 	e[indexTo,] <- -1
	x <- solve(Lr,e)
	x <- as.vector(x)
	Lplusallrows <- c(x-sum(x/(n+1)),(sum(x)/(n+1)))
	V <- A * Lplusallrows
	d <- t(t(A) * diag(V))
	V <- - V + d
	Current <- colSums(abs(V)*-L)/2
	Current[indexFrom] <- 1
	Current[indexTo] <- 1
	return(Current)
}

.Laplacian <- function(transition) 
{
	Laplacian <- Diagonal(x = colSums(transitionMatrix(transition))) - transitionMatrix(transition)
	return(Laplacian)
}

.transitionSolidify <- function(transition)
{
	transition.dsC <- as(transition,"dsCMatrix")
	selection <- which(rowMeans(transition.dsC)>0)
	transition@transitionCells <- transition@transitionCells[selection]
	transition.dsC <- transition.dsC[selection,selection]
	transitionMatrix(transition) <- transition.dsC
	return(transition)
}

