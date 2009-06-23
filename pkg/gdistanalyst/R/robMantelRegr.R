RMReg <- function(distObjectY, distObjectX, p=0, iter=100, popSize=100, maxNoImprove=0, mutationNo=2, verbose=FALSE)
{
	.rbga.bin2(distObjectY, distObjectX, p=p, iter=iter, maxNoImprove=maxNoImprove, mutationNo=mutationNo, popSize=popSize, evalFunc = .evalFunc, verbose=verbose)
}

.evalFunc <- function(chromosome, distObjectY, distObjectX)
{
	distObjectY <- as.dist(as.matrix(distObjectY)[chromosome,chromosome])
	distObjectX <- as.dist(as.matrix(distObjectX)[chromosome,chromosome])
	summ <- summary(lm(distObjectY ~ distObjectX))
	return(list(r.squared = summ$r.squared, coeff = abs(summ$coefficients[,1])))
}

#adapted from genalg package by Egon Willighagen <e.willighagen@science.ru.nl>
#original code available under GNU licence version 2
#drastically rewritten to implement a version of Nunkesser & Morell 
#the algorithm is specific for distance matrices and deletes row/column combinations (i.e. samples) rather than individual distances
#wo other major differences with Nunkesser & Morell are that (1) operators are applies in fixed fractions (1/3 each) and that (2) after iteration 1 mutation of existing individuals is done instead creation of new individuals. If mutationNo is set very high, the same effect achieved, however.
#TODO adapt the function for more than one explanatory variable

.rbga.bin2 <- function(distObjectY, 
					distObjectX,
					p=0,
                    suggestions=NULL,
					popSize=100, 
					iters=100, 
					maxNoImprove=0,
                    mutationNo=2,
                    evalFunc=NULL,
					verbose=FALSE) 
{
	vars <- 1 
    n <- dim(as.matrix(distObjectY))[1]
	parentProb <- dnorm(1:popSize, mean=0, sd=(popSize/3))
	elite <- floor(popSize/4)
	
	if(maxNoImprove == 0) {maxNoImprove <- iters}
	
	if(p==0)
	{
		p <- floor(n/2) + 1
		if(verbose) {cat("p set to ", p, " (", round((p/n)*100),"% )\n")}
	}
	
    # sanity checks
    if (is.null(evalFunc)) stop("an evaluation function (evalFunc) must be provided")
	if(n<2) stop("distObjectY too small; algorithm intended for larger problems") 
	if (!(n == dim(as.matrix(distObjectX))[1])) stop("distObjectX and distObjectY have different dimensions")
	if(p >= n) stop ("p should be smaller than dimension of distObjects (n=",n,")")
	if(mutationNo<1) stop("mutationNo should be at least 1")
	if(mutationNo>p) stop("mutationNo cannot be bigger than p (",p,")")
    if (popSize < 5) stop("the population size must be at least 5")
	if (iters < 1) stop("the number of iterations must be at least 1")
	
	#initiate population
	if (verbose) cat("Creating initial population \n")
	population <- matrix(FALSE, nrow=popSize, ncol=n)
	Start <- 0
	if (!is.null(suggestions)) 
	{
		population[1:Start,] <- suggestions
		Start <- dim(suggestions)[1]
	}
	for (child in (Start+1):popSize) 
	{
		population[child,sample(1:n, p, replace=FALSE)] <- TRUE
	}

	#prepare results vectors and matrix
	bestEvals <- rep(NA, iters)
	meanEvals <- rep(NA, iters)
	evalVals <- rep(NA, popSize)
	evalPars <- matrix(NA, nrow=popSize, ncol=vars+1)
		
	# calculate evalVal of initial population
	if (verbose) cat("Calculating evaluation values of initial population ")
	for (object in 1:elite) 
	{
		evalVal <- .evalFunc(population[object,], distObjectY, distObjectX)
		evalVals[object] <- evalVal[[1]]
		evalPars[object,] <- evalVal[[2]]
		if (verbose) cat(".")
	}

	# do iterations
	for (iter in 1:iters) 
	{
		if (verbose & iter != 1) cat("\nCalculating evaluation values ")
		for (object in (elite+1):popSize) 
		{
			evalVal <- .evalFunc(population[object,],distObjectY, distObjectX)
			evalVals[object] <- evalVal[[1]]
			evalPars[object,] <- evalVal[[2]]
			if (verbose) cat(".")
		}

		bestEvals[iter] <- max(evalVals)
		meanEvals[iter] <- mean(evalVals)
		if (verbose) cat("iteration ", iter, ", R2: ", bestEvals[iter], "\n")
 
		#maximum number of iterations without improvement exceeded?
		if (iter>maxNoImprove)
		{
			if (all(bestEvals [(iter-maxNoImprove):iter] == max(bestEvals, na.rm=TRUE)))
			{
				cat("No improvement during", maxNoImprove, "iterations\n")
				break()
			}
		}
 
		if (iter<iters)
		{
		
			#create new generation
			if (verbose) cat("Creating next generation ")
			newPopulation <- matrix(FALSE, nrow=popSize, ncol=n)
			newEvalVals <- rep(NA, popSize)
			sortedEvaluations <- sort(evalVals, index.return=TRUE, decreasing=TRUE)
			sortedPopulation  <- population[sortedEvaluations$ix,]
                
			# keep the best
			newPopulation[1:elite,] <- sortedPopulation[1:elite,]
			newEvalVals[1:elite] <- sortedEvaluations$x[1:elite]

			#do residual-based re-ordering
			parentIDs <- sample(1:popSize, size = elite, prob=parentProb)
			for(child in (elite+1):(2*elite))
			{
				resdls <- abs((evalPars[parentIDs[child-elite],1] + evalPars[parentIDs[child-elite],2] * distObjectX) - distObjectY)
				resdls <- colSums(as.matrix(resdls))
				index <- sort(resdls, index.return = TRUE)$ix[1:p]
				newPopulation[child,index] <- TRUE
				if (verbose) cat(".")
			}

			# swapping by crossover
			for (child in (2*elite+1):(3*elite)) 
			{
				minL <- 0
				while (minL<3)
				{
					parentIDs <- sample(1:popSize, 2, prob=parentProb)
					parent1 <- as.vector(sortedPopulation[parentIDs[1],])
					parent2 <- as.vector(sortedPopulation[parentIDs[2],])
					candidates1 <- which(parent1 & !parent2)
					candidates2 <- which(!parent1 & parent2)
					minL <- min(length(candidates1), length(candidates2))
				}
				swapNo <- sample(2:(minL-1),1)
				newChild <- parent1
				newChild[sample(candidates1, swapNo)] <- FALSE
				newChild[sample(candidates2, swapNo)] <- TRUE
				newPopulation[child,] <- newChild
				if (verbose) cat(".")
			}

			# swapping by mutation
			parentIDs <- sample(1:popSize, size = length((3 * elite + 1):popSize), prob=parentProb)
			for (child in (3 * elite + 1):popSize) 
			{
				newChild <- sortedPopulation[parentIDs[child - 3 * elite],]
				index1 <- sample(which(newChild), mutationNo, replace=FALSE)
				index2 <- sample(which(!newChild), mutationNo, replace=FALSE)
				newChild[index1] <- FALSE
				newChild[index2] <- TRUE
				newPopulation[child,] <- newChild
				if (verbose) cat(".")
			}

			#replace old values by the new ones
			population <- newPopulation
			evalVals   <- newEvalVals

		}

	}

	#result
    result = list(type="binary chromosome", size=size,
                  popSize=popSize, iters=iter, suggestions=suggestions,
                  population=population, elite=elite, mutationNo=mutationNo,
                  evaluations=evalVals, best=bestEvals, mean=meanEvals, finalEval=max(bestEvals, na.rm=TRUE))
    class(result) = "rbga"

    return(result)
}