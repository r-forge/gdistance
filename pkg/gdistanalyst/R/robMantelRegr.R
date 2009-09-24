#TODO remove ij

RMReg <- function(forml, dat=NULL, p=0, iter=100, popSize=100, maxNoImprove=0, mutationNo=2, verbose=FALSE)
{
	forml <- as.formula(forml)
	nc <- length(dat[,1])
	n <- round(optimize(function(n) ( abs(n^2 -n - 2*nc)), interval = c(0, nc*3))[[1]])
	formterms <- rownames(attr(terms(forml,keep.order = TRUE), "factors"))[1:length(rownames(attr(terms(forml), "factors")))] 
	dat <- dat[formterms]
	.rbga.bin2(forml, formterms, dat, p=p, iter=iter, maxNoImprove=maxNoImprove, mutationNo=mutationNo, popSize=popSize, evalFunc = .evalFunc, verbose=verbose, n=n)
}

.evalFunc <- function(chromosome, forml, formterms, dat, n)
{
	if(!is.null(dat))
	{
		environment(forml) <- environment()
		for(i in 1:length(formterms))
		{
			value <- as.dist(matrix(nrow=n,ncol=n))
			value[] <- unlist(dat[formterms[i]])
			value <- as.dist(as.matrix(as.dist(value))[chromosome,chromosome])
			assign(formterms[i], value)
		}
	}
	summ <- summary(lm(forml))
	return(list(r.squared = summ$r.squared, coeff = summ$coefficients[,1]))
}

#adapted from genalg package by Egon Willighagen <e.willighagen@science.ru.nl>
#original code available under GNU licence version 2
#drastically rewritten to implement a version of Nunkesser & Morell 
#the algorithm is specific for distance matrices and deletes row/column combinations (i.e. samples) rather than individual distances
#wo other major differences with Nunkesser & Morell are that (1) operators are applies in fixed fractions (1/3 each) and that (2) after iteration 1 mutation of existing individuals is done instead creation of new individuals. If mutationNo is set very high, the same effect achieved, however.

.rbga.bin2 <- function(forml,
					formterms,
					dat,
					p=0,
                    suggestions=NULL,
					popSize=100, 
					iters=100, 
					maxNoImprove=0,
                    mutationNo=2,
                    evalFunc=NULL,
					verbose=FALSE,
					n) 
{
	vars <- length(formterms) 
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
	if(n<2) stop("n too small; algorithm intended for larger problems") 
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
	evalPars <- matrix(NA, nrow=popSize, ncol=vars)
		
	# calculate evalVal of initial population
	if (verbose) cat("Calculating evaluation values of initial population ")
	for (object in 1:elite) 
	{
		evalVal <- .evalFunc(population[object,], forml, formterms, dat, n)
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
			evalVal <- .evalFunc(population[object,], forml, formterms, dat, n)
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
				resdls <- ((evalPars[parentIDs[child-elite],1] + rowSums(t(evalPars[parentIDs[child-elite],2:vars] * t(as.matrix(dat[,2:length(dat[1,])]))))) - dat[,1])^2
				resdlsDist <- as.dist(matrix(nrow=n,ncol=n))
				resdlsDist[] <- resdls
				resdls <- rowSums(as.matrix(resdlsDist), na.rm=TRUE)
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
    result <- list(type="binary chromosome", 
				size=size,
                popSize=popSize, 
				iters=iter, 
				suggestions=suggestions,
				population=population,
				elite=elite, 
				mutationNo=mutationNo,
				evaluations=evalVals,
				best=bestEvals,
				mean=meanEvals,
				finalEval=max(bestEvals, na.rm=TRUE))
				
    class(result) = "rbga"

    return(result)
}