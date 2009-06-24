distIndex <- function(i,j,n){n*(j-1) - j*(j-1)/2 + i-j}

matrIndex <- function(i,n){
	cc <- cumsum(seq((n-1),1))
	out <- matrix(nrow=length(i),ncol=2)
	for(index in 1:length(i))
	{
		out[index,2] <- min(which((cc-i[index])>=0))
		out[index,1] <- -c(0,cc)[out[index,2]] + i[index] + out[index,2]
	}
	return(out)
}