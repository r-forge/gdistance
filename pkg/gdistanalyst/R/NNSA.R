NNSA <- function(ssr, nullAlleles="missing")
{
	ssr <- na.omit(ssr)
	if(nullAlleles=="missing"){ssr <- subset(ssr,ssr[,3]!=0)}
	if(nullAlleles=="unlike"){ssr[,3][ssr[,3]==0] <- seq(from=max(ssr[,3])+1,to=max(ssr[,3])+length(ssr[,3][ssr[,3]==0]))}
	if(nullAlleles=="alike"){}
	accessionIndex <- unique(ssr[,1])
	n <- length(accessionIndex)
	
	markerFragment <- paste(ssr[,2],ssr[,3],sep="&")
	markerFragmentIndex <- unique(markerFragment)
	accMarkerFragment <- paste(ssr[,1],markerFragment,sep="_")
	markerFragmentTable <- table(accMarkerFragment)
		
	acc <- unlist(strsplit(names(markerFragmentTable),"_"))[seq(from=1,to=length(markerFragmentTable)*2,by=2)]
	markerFr <- unlist(strsplit(names(markerFragmentTable),"_"))[seq(from=2,to=length(markerFragmentTable)*2,by=2)]

	markerIndex <- unlist(strsplit(markerFragmentIndex, "&"))[seq(from=1,to=length(markerFragmentIndex)*2,by=2)]
	
	i <- match(acc,accessionIndex)-1
	j <- match(markerFr,markerFragmentIndex)-1
	x <- as.vector(markerFragmentTable)
	Dim1 <- n
	Dim2 <- length(markerFragmentIndex)
	dataMatrix <- new("dgTMatrix", i = as.integer(i), j = as.integer(j), x = as.numeric(x), Dim = as.integer(c(Dim1,Dim2)))
	dataMatrix <- as(dataMatrix,"dgCMatrix")
	dataMatrix <- as(dataMatrix,"lMatrix")
	
	#mininum number of markers with non-missing data (pairwise)
	
	minMarkers <- apply(dataMatrix, 1, function(x) {tapply(x, markerIndex, function(x) {sum(x>0)})})
	minMarkers <- colSums(minMarkers>0)
	minMarkersDist <- distanceFromLevel (minMarkers, min, diag=FALSE)
	
	Dist <- as.dist(matrix(0,ncol=n,nrow=n))
	index <- cbind(rep(1:n,times=n), rep(1:n,each=n))
	for(i in 1:length(Dist))
	{
		Dist[i] <- sum(abs(dataMatrix[matrIndex(i,n)[1],] - dataMatrix[matrIndex(i,n)[2],]))
	}
	Dist <- Dist / minMarkersDist
	return(Dist)
}