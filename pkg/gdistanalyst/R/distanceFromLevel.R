# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

distanceFromLevel <- function(level,fun,diag=FALSE)
{
result <- matrix(NA,ncol=length(level),nrow=length(level))
rownames(result) <- names(level)
colnames(result) <- names(level)
index <- cbind(rep(1:length(level), each=length(level)),rep(1:length(level), times=length(level)))
result[index] <- apply(cbind(level[index[,1]],level[index[,2]]),1,fun)
return(as.dist(result, diag=diag))
}

