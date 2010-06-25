# Author: Jacob van Etten jacobvanetten@yahoo.com
# IE University
# Date :  June 2010
# Version 1.0
# Licence GPL v3

setMethod("stack", signature(x='TransitionLayer'), 
function(x, ...) {
		newStack <- as("TransitionStack", x)	
		x <- as(x, "TransitionData")
		TLs <- list(...)
		if (length(TLs) > 0)
		{
			#check if equal
			#method for ... = TransitionStack
			for(i in 1: length(TLs)) TLs[[i]] <- as("TransitionData", TLs[[i]])
			x <- c(x, TLs)
		}
		newStack@transition <- x
		newStack@nlayers <- length(x)
		return(newStack)	
	} 
)

#setMethod("stack", signature(x='TransitionStack'), 