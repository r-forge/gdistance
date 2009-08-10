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
	C <- 1e-300 * n #This should avoid too big floating points as "Voltage differences"
	e <- matrix(0, ncol=1, nrow=n)
	e[indexFrom,] <- C
 	e[indexTo,] <- -C
	x <- solve(Lr,e)
	x <- as.vector(x)
	Lplusallrows <- c(x,x[length(x)]) / C
	V <- A * Lplusallrows
	d <- t(t(A) * diag(V))
	V <- - V + d
	Current <- colSums(abs(V)*-L)/2 #I = V * R
	Current[indexFrom] <- 1
	Current[indexTo] <- 1
	return(Current)
}

.potential <- function(L, Lr, A, n, indexFrom, indexTo) 
{
	C <- 1e-300 * n #This should avoid too big floating points as "Voltage differences"
	e <- matrix(0, ncol=1, nrow=n)
	e[indexFrom,] <- C
 	e[indexTo,] <- -C
	x <- solve(Lr,e)
	x <- as.vector(x)
	Lplusallrows <- c(x,x[length(x)]) / C
	V <- A * Lplusallrows
	d <- t(t(A) * diag(V))
	V <- - V + d
	return(V)
}

.currentSqrtR <- function(L, Lr, A, n, indexFrom, indexTo, index, RSqrtR) 
{
	C <- 1e-300 * n #This should avoid too big floating points as "Voltage differences"
	e <- matrix(0, ncol=1, nrow=n)
	e[indexFrom,] <- C
 	e[indexTo,] <- -C
	x <- solve(Lr,e)
	x <- as.vector(x)
	Lplusallrows <- c(x,x[length(x)]) / C
	V <- A * Lplusallrows
	d <- t(t(A) * diag(V))
	V <- - V + d
	ISqrtR <- abs(V)* RSqrtR
	return(ISqrtR[index])
}

.currentM <- function(L, Lr, A, n, indexFrom, indexTo, index) 
{
	C <- 1e-300 * n #This should avoid too big floating points as "Voltage differences"
	e <- matrix(0, ncol=1, nrow=n)
	e[indexFrom,] <- C
 	e[indexTo,] <- -C
	x <- solve(Lr,e)
	x <- as.vector(x)
	Lplusallrows <- c(x,x[length(x)]) / C
	V <- A * Lplusallrows
	d <- t(t(A) * diag(V))
	V <- - V + d
	Current <- abs(V)*-L #I = V * R
	return(Current[index])
}

.Laplacian <- function(transition) 
{
	Laplacian <- Diagonal(x = colSums(transitionMatrix(transition))) - transitionMatrix(transition)
	Laplacian <- as(Laplacian, "symmetricMatrix")
	return(Laplacian)
}

.transitionSolidify <- function(transition)
{
	transition.dsC <- as(transition,"dsCMatrix")
	selection <- which(rowMeans(transition.dsC)>1e-40)
	transition@transitionCells <- transition@transitionCells[selection]
	transition.dsC <- transition.dsC[selection,selection]
	transitionMatrix(transition) <- transition.dsC
	return(transition)
}