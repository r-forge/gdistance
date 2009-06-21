robMantelRegr <- function(distObjectY, distObjectX, p, verbose=FALSE)
{
	.rbga.bin2(distObjectY, distObjectX, evalFunc = .evalFunc)
}

.evalFunc <- function(chromosome, distObjectY, distobjectX)
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
	if (!is.null(suggestions)) 
	{
		population[1:start,] <- suggestions
		start <- dim(suggestions)[1]
	}
	for (child in (start+1):popSize) 
	{
		population[child,sample(1:n, p, rep=FALSE)] <- TRUE
	}

	#prepare results vectors and matrix
	bestEvals <- rep(NA, iters)
	meanEvals <- rep(NA, iters)
	evalVals <- rep(NA, popSize)
	evalPars <- matrix(NA, nrow=popSize, ncol=vars+1)
		
	# calculate evalVal of initial population
	if (verbose) cat("Calculating evaluation values... ")
	for (object in 1:popSize) 
	{
		if (is.na(evalVals[object])) 
		{
			evalVal <- .evalFunc(population[object,],distObject)
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
 
		if (verbose) cat("Creating next generation...\n")
		newPopulation <- matrix(FALSE, nrow=popSize, ncol=n)
		newEvalVals <- rep(NA, popSize)
		sortedEvaluations <- sort(evalVals, index.return=TRUE)
		sortedPopulation  <- matrix(population[sortedEvaluations$ix,], ncol=n)
                
		# keep the best
		newPopulation[1:elite,] <- sortedPopulation[1:elite,]
		newEvalVals[1:elite] <- sortedEvaluations$x[1:elite]

		#do residual based calculations
		for(child in (elite+1):(2*elite))
		{
			index <- sort(abs((evalPars[1,child] + evalPars[2,child] * distObjectX) - distObjectY), index.return = T)$xi[p]
			newPopulation[child,index] <- TRUE
		}

		# swapping by crossover
		for (child in (2*elite+1):(3*elite)) 
		{
			minL <- NULL
			while (length(minL<3))
			{
				parentIDs <- sample(1:popSize, 2, prob=parentProb)
				parent1 <- sortedPopulation[parentIDs[1],]
				parent2 <- sortedPopulation[parentIDs[2],]
				candidates1 <- which(parent1 & !parent2)
				candidates2 <- which(!parent1 & parent2)
				minL <- min(length(candidates1)>0, length(candidates2>0))
			}
			swapNo <- sample(2:(minL-1),1)
			newChild <- parent1
			newChild[sample(candidates1, swapNo)] <- FALSE
			newChild[sample(candidates2, (minL - swapNo))] <- TRUE
			newPopulation[child,] <- newChild
		}

		# swapping by mutation
		parentIDs <- sample(1:popSize, length((3 * elite + 1):popSize), prob=parentProb)
		for (child in (3 * elite + 1):popSize) 
		{
			newChild <- sortedPopulation[parentsIDs[child - 3 * elite]]
			index1 <- sample(which(newChild),mutationNo)
			index2 <- sample(which(!newChild),mutationNo)
			newChild[index1] <- FALSE
			newChild[index2] <- TRUE
			newPopulation[child,] <- newChild
		}
                
		population <- newPopulation
		evalVals   <- newEvalVals

		if (verbose) cat("Calculating evaluation values... ")
		for (object in (elite+1):popSize) 
		{
			evalVal <- .evalFunc(population[object,],distObjectY, distObjectX)
			evalVals[object] <- evalVal[[1]]
			evalPars[object,] <- evalVal[[2]]
			if (verbose) cat("|")
		}
	}

	#result
    result = list(type="binary chromosome", size=size,
                  popSize=popSize, iters=iters, suggestions=suggestions,
                  population=population, elite=elite, mutationChance=mutationChance,
                  evaluations=evalVals, best=bestEvals, mean=meanEvals)
    class(result) = "rbga"

    return(result)
}