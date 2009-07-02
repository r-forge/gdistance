MRD <- function(data, nullAlleles="missing")
{
	data <- na.omit(data)
	if(nullAlleles=="missing"){data <- subset(data,data[,3]!=0)}
	if(nullAlleles=="unlike"){data[,3][data[,3]==0] <- seq(from=max(data[,3])+1,to=max(data[,3])+length(data[,3][data[,3]==0]))}
	if(nullAlleles=="alike"){}
	accessionIndex <- unique(data[,1])
	n <- length(accessionIndex)

	markerFragment <- paste(data[,2],data[,3],sep="&")
	markerFragmentIndex <- unique(markerFragment)
	accMarkerFragment <- paste(data[,1],markerFragment,sep="_")
	markerFragmentTable <- table(accMarkerFragment)
	
	acc <- unlist(strsplit(names(markerFragmentTable),"_"))[seq(from=1,to=length(markerFragmentTable)*2,by=2)]
	markerFr <- unlist(strsplit(names(markerFragmentTable),"_"))[seq(from=2,to=length(markerFragmentTable)*2,by=2)]

	i <- match(acc,accessionIndex)-1
	j <- match(markerFr,markerFragmentIndex)-1
	x <- as.vector(markerFragmentTable)
	Dim1 <- n
	Dim2 <- length(markerFragmentIndex)
	dataMatrix <- new("dgTMatrix", i = as.integer(i), j = as.integer(j), x = as.numeric(x), Dim = as.integer(c(Dim1,Dim2)))
	dataMatrix <- as(dataMatrix,"dgCMatrix")

	markerIndex <- unlist(strsplit(markerFragmentIndex, "&"))[seq(from=1,to=length(markerFragmentIndex)*2,by=2)]
	noFragmentsPerMarker <- t(apply(dataMatrix, 1, function(x) tapply(x, markerIndex, sum)))
	nms <- names(tapply(dataMatrix[1,], markerIndex, sum))
	noFragmentsPerMarker <- noFragmentsPerMarker[,match(markerIndex,nms)] #This defeats the purpose of sparse matrices of course. For big files, this should be done in chunks with a loop.
	noFragmentsPerMarker[noFragmentsPerMarker == 0] <- Inf
	dataMatrix <- dataMatrix / noFragmentsPerMarker

	genDist <- as.dist(matrix(0,ncol=n,nrow=n))
	index <- cbind(rep(1:n,times=n), rep(1:n,each=n))
	for(i in 1:length(genDist))
	{
		genDist[i] <- sum(tapply((dataMatrix[matrIndex(i,n)[1],] - dataMatrix[matrIndex(i,n)[2],])^2, markerIndex, sum))
	}

	return(genDist)
}