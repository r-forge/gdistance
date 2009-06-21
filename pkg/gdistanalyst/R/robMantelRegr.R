robMantelRegr <- function(distObjectY, distObjectX, p, iter=100, verbose=FALSE)
{
	.rbga.bin2(distObjectY, distObjectX, p=p, iter=iter, evalFunc = .evalFunc, verbose=verbose)
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

.rbga.bin2 <- function(distObjectY, 
					distObjectX,
					p,
                    suggestions=NULL,
					popSize=100, 
					iters=100, 
                    mutationNo=2,
                    evalFunc=NULL,
					verbose=FALSE) {

	vars <- 1 #TODO adapt the function for more than one explanatory variable
    n <- dim(as.matrix(distObjectY))[1]
	parentProb <- dnorm(1:popSize, mean=0, sd=(popSize/3))
	elite <- floor(popSize/4)
    
    # sanity checks
    if (is.null(evalFunc)) stop("An evaluation function must be provided. See the evalFunc parameter.")
	if(n<2) stop("distObjectY too small; algorithm intended for larger problems") 
	if (!(n == dim(as.matrix(distObjectX))[1])) stop("distObjectX and distObjectY have different dimensions")
	if(mutationNo<1)stop("mutationNo should be at least 1")
    if (popSize < 5) stop("The population size must be at least 5.")
	if (iters < 1) stop("The number of iterations must be at least 1.")
	
	#initiate population
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
	if (verbose) cat("Calculating evaluation values ")
	for (object in 1:popSize) 
	{
		if (is.na(evalVals[object])) 
		{
			evalVal <- .evalFunc(population[object,], distObjectY, distObjectX)
			evalVals[object] <- evalVal[[1]]
			evalPars[object,] <- evalVal[[2]]
			if (verbose) cat(".")
		}
	}

	# do iterations
	for (iter in 1:iters) 
	{
		bestEvals[iter] <- max(evalVals)
		meanEvals[iter] <- mean(evalVals)
		if (verbose) cat("iteration ", iter, ", R2: ", bestEvals[iter], "\n")
 
		if (verbose) cat("Creating next generation ")
		newPopulation <- matrix(FALSE, nrow=popSize, ncol=n)
		newEvalVals <- rep(NA, popSize)
		sortedEvaluations <- sort(evalVals, index.return=TRUE, decreasing=TRUE)
		sortedPopulation  <- population[sortedEvaluations$ix,]
                
		# keep the best
		newPopulation[1:elite,] <- sortedPopulation[1:elite,]
		newEvalVals[1:elite] <- sortedEvaluations$x[1:elite]

		#do residual based calculations
		for(child in (elite+1):(2*elite))
		{
			resdls <- abs((evalPars[child-elite,1] + evalPars[child-elite,2] * distObjectX) - distObjectY)
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
                
		population <- newPopulation
		evalVals   <- newEvalVals

		if (verbose) cat("\n","Calculating evaluation values... ")
		for (object in (elite+1):popSize) 
		{
			evalVal <- .evalFunc(population[object,],distObjectY, distObjectX)
			evalVals[object] <- evalVal[[1]]
			evalPars[object,] <- evalVal[[2]]
			if (verbose) cat(".")
		}
	}

	#result
    result = list(type="binary chromosome", size=size,
                  popSize=popSize, iters=iters, suggestions=suggestions,
                  population=population, elite=elite, mutationNo=mutationNo,
                  evaluations=evalVals, best=bestEvals, mean=meanEvals)
    class(result) = "rbga"

    return(result)
}