ASD <- function(ssr,repeats=2)
{
	ssr <- ssr[!is.na(ssr[,1]),]
	ssr <- ssr[!is.na(ssr[,2]),]
	index <- which(ssr[,3]== 0)
	if(length(index)>0){ssr[index,] <- NA}
	accessions <- unique(ssr[,1])
	if(length(repeats)>1){stop("Not yet implemented.")} else {
		ssr[,3] <- ssr[,3]/repeats	
		markers <- unique(ssr[,2])
	}
	if(length(repeats)>1 && (!all(unique(ssr[,2]) %in% repeats) || !(length(unique(ssr[,2] == length(repeats)))))) {stop("repeats does not correspond to the second column of ssr")}
	accessionMarker <- paste(ssr[,1],ssr[,2],sep="-")
	AlleleMean <- tapply(ssr[,3],accessionMarker,function(x){mean(x,na.rm=TRUE)})
	AlleleMeanMatrix <- matrix(nrow=length(accessions),ncol=length(markers))
	IndexNames <- unlist(strsplit(names(AlleleMean),"-"))
	index <- cbind(match(IndexNames[seq(1,length(IndexNames)-1,by=2)],accessions),match(IndexNames[seq(2,length(IndexNames),by=2)],markers))
	AlleleMeanMatrix[index] <- AlleleMean

	AlleleVar <- tapply(ssr[,3],accessionMarker,function(x){var(x,na.rm=TRUE)})
	AlleleVarMatrix <- matrix(nrow=length(accessions),ncol=length(markers))
	AlleleVarMatrix[index] <- AlleleVar

	rownames(AlleleMeanMatrix) <- accessions
	rownames(AlleleVarMatrix) <- accessions
	
	nacc <- length(accessions)
	ASDDist <- as.dist(matrix(nrow=nacc,ncol=nacc))
	index1 <- cbind(rep(1:nacc,each=nacc),rep(1:nacc,times=nacc))
	index1 <- index1[index1[,1] > index1[,2],]
	index2 <- .distIndex(index1[,1],index1[,2],nacc)
	for(i in 1:length(index1[,1]))
	{
		dif <- (AlleleMeanMatrix[index1[i,1],] - AlleleMeanMatrix[index1[i,2],]) 
		dif <- dif * dif
		dif <- dif + (AlleleVarMatrix[index1[i,1],] + AlleleVarMatrix[index1[i,2],])
		ASDDist[index2[i]] <- sum(dif,na.rm=T)/sum(!is.na(dif))
	}
	return(ASDDist)
}
