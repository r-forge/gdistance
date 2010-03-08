# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  March 2010
# Version beta
# Licence GPL v3

setGeneric("normalize", function(transition) standardGeneric("normalize"))

setMethod("normalize", signature(transition = "Transition"), def = function(transition)
	{
		return(.normalize(transition))
	}
)