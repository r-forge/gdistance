exclOutl <- function(ssr, fac=3, method="SD")
{
	ssr <- as.data.frame(ssr)
	ssr <- ssr[!is.na(ssr[,1]),]
	ssr <- ssr[!is.na(ssr[,2]),]
	index <- which(ssr[,3]== 0)
	if(length(index)>0){ssr[index,3] <- NA}
	if(method=="qt")
	{
		lowQ <- tapply(ssr[,3],as.character(ssr[,2]),function(x){quantile(x, probs=.25, na.rm = TRUE)})
		highQ <- tapply(ssr[,3],as.character(ssr[,2]),function(x){quantile(x, probs=.75, na.rm = TRUE)})
		low <- lowQ - fac * (highQ - lowQ) 
		high <- highQ + fac * (highQ - lowQ)
		markers <- names(lowQ)
	}
	if(method=="SD")
	{
		SDs <- tapply(ssr[,3],as.character(ssr[,2]),function(x){sd(x,na.rm=TRUE)})
		means <- tapply(ssr[,3],as.character(ssr[,2]),function(x){mean(x,na.rm=TRUE)})
		low <- means - fac * SDs
		high <- means + fac * SDs
		markers <- names(SDs)
	}
	if(method=="mad")
	{
		mads <- tapply(ssr[,3],as.character(ssr[,2]),function(x){mad(x,na.rm=TRUE)})
		medians <- tapply(ssr[,3],as.character(ssr[,2]),function(x){median(x,na.rm=TRUE)})
		low <- medians - fac * mads
		high <- medians + fac * mads
		markers <- names(mads)
	}
	for (i in 1:length(markers))
	{
		index <- which(ssr[,2] == markers[i] & (ssr[,3] < low[i] | ssr[,3] > high[i]))
		if(length(index) > 0){ssr[index,3] <- NA} 
	}
	return(ssr)
}