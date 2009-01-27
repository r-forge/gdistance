# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

distanceFromLevel <- function(levels,fun,diag=FALSE)
{
result <- matrix(NA,ncol=length(levels),nrow=length(levels))
rownames(result) <- names(levels)
colnames(result) <- names(levels)
index <- cbind(rep(1:length(levels), each=length(levels)),rep(1:length(levels), times=length(levels)))
result[index] <- apply(cbind(levels[index[,1]],levels[index[,2]]),1,fun)
return(as.dist(result, diag=diag))
}

