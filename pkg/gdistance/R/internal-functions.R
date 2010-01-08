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
	V1 <- A * Lplusallrows
	V2 <- t(t(A) * Lplusallrows)
	V <- abs(V1 - V2)
	Current <- colSums(V * -L)/2 #I = V * Conductance
	Current[indexFrom] <- 1
	Current[indexTo] <- 1
	return(Current)
}

.currentR <- function(L, Lr, A, n, indexFrom, indexTo)
{
	lf <- length(indexFrom)
	lt <- length(indexTo)
	C <- 1e-300 * n
	Cf <- C / lf #This should avoid too big floating points as "Voltage differences"
	Ct <- C / lt
	e <- matrix(0, ncol=1, nrow=n)
	e[indexFrom,] <- Cf
 	e[indexTo,] <- -Ct
	x <- solve(Lr,e)
	x <- as.vector(x)
	Lplusallrows <- c(x,x[length(x)]) / C
	V1 <- A * Lplusallrows
	V2 <- t(t(A) * Lplusallrows)
	V <- abs(V1 - V2)
	Current <- colSums(V * -L)/2 #I = V * Conductance
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
	V1 <- A * Lplusallrows
	V2 <- t(t(A) * Lplusallrows)
	V <- abs(V1 - V2)
	return(V)
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
	V1 <- A * Lplusallrows
	V2 <- t(t(A) * Lplusallrows)
	V <- abs(V1 - V2)
	Current <- V[index] * -L[index] #I = V * Conductance
	return(Current)
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