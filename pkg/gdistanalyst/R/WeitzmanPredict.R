WeitzmanPredict <- function(distObject, distDataframe, rqProcessObject, iters, popSize)
{
	WO <- .WeitzmanOrder(distObject, iters, popSize)
	Sequence <- WO[[1]]
	WeitzmanUncorr <- WO[[2]]
	WeitzmanCorr <- 0
	for(i in 1:(length(Sequence)-1))
	{
		index <- .distIndex(Sequence[i],Sequence[(i+1):n],n) #select from distDataframe all distances between Sequence[i] to those still in set and put in PredToExpDist
		WeitzmanCorr <- WeitzmanCorr + .PredToExpDist(rqProcessObject, distDataframe[index,]) #will it work when i=n-1?
	}
	return(list(WeitzmanUncorr=WeitzmanUncorr, WeitzmanCorr=WeitzmanCorr))
}

.distIndex <- function(i,j,n){n*(j-1) - j*(j-1)/2 + i-j}

.PredToExpDist <- function(rqProcessObject, distDataframe)
{
	stepFuns <- predict(rqProcessObject, newdata=distDataframe, stepfun=TRUE)
	stepFuns <- rearrange(stepFuns)
	DiscDistr <- .SFToDD(stepFuns[[1]])
	for(i in 2:length(stepFuns))
	{
		DiscDistr <- Minimum(DiscDistr, .SFToDD(stepFuns[[i]]))
	}
	return(E(DiscDistr))
}

.WeitzmanOrder <- function(distObject, iters, popSize)
{
	size <- attr(distObject, "Size")-1
	rgaObject <- .rbga.bin(distObject=distObject, size=size, popSize=popSize, iters=iters, evalFunc=WeitzmanCalc, mutationChance=.3, zeroToOneRatio=1)
	WeitzmanUtilityUncorrected <- rgaObject$best
	chrom <- rgaObject$population
	WUUncorr <- max(rgaObject$best)
	shortestSequence <- which(rgaObject$evaluations == WUUncorr)
	sampleOrder <- .reconstructOrder(shortestSequence, distObject)[[2]]
	return(list(sampleOrder,WUUncorr))
}

.SFToDD <- function(stepFun)
{
	knts <- knots(stepFun)
	intVals <- stepFun(knts)[-lengths(knts)]+.5*diff(stepFun(knts))
	intVal0 <- knts[1] - .5 * (((stepFun(knts[2])-stepFun(knts[2]))/(knts[2]-knts[1]))*knts[1])
	intVal1 <- knts[length(knts)] + .5 * (((stepFun(knts[length(knts)])-stepFun(knts[length(knts)]))/(knts[length(knts)]-knts[(lengths(knts)-1)])) * (1- knts[length(knts)]))
	supp <- c(intVal0,intVals,intVal1)
	probs <- c(0,knts,1)+.5*diff(c(0,knts,1))
	DiscDistr <- DiscreteDistribution(supp=supp,probs=probs)
	return(DiscDistr)
}

.reconstructOrder <- function(binarySeq,distObject) 
{
	n <- attr(distObject, "Size")
	distValue <- 0
	Links <- vector(length=length(binarySeq))
	LinksAux <- 1:length(binarySeq)
	for(i in 1:(length(binarySeq)))
	{
		distValue <- distValue + min(distObject)
		if(i<(length(binarySeq)))
		{
			Pair <- .matrIndex(which(distObject==min(distObject)),n+1-i)
			Link <- Pair[(binarySeq[i] + 1)]
			Links[i] <- LinkAux[Link]
			LinkAux <- LinkAux[-Link]
			if(Link>1){index1 <- .distIndex(Link,1:(Link-1),n+1-i)}else(index1<-NA)
			if(Link<(n+1-i)){index2 <- .distIndex((Link+1):(n+1-i),Link,n+1-i)}else(index2<-NA)
			index <- na.omit(c(index1,index2))
			distObject <- distObject[-index]
		}
	}
	return(list(distValue,Links))
}