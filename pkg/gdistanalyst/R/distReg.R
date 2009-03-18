permregression <- function (forml, permutations = 99, method="residual") 
{
	forml <- as.formula(forml)
	reference.summary <- summary(lm(forml)) 
	formterms <- rownames(attr(terms(forml,keep.order = TRUE), "factors"))[2:length(rownames(attr(terms(forml), "factors")))] 
	begincoeff <- 2*(length(formterms)+1)+2
	endcoeff <- 3*(length(formterms)+1)	
	statistic <- c(reference.summary$r.squared,abs(reference.summary$coefficients[begincoeff:endcoeff])) #Reference statistic
	if (method=="raw")
	{
		y <- as.dist(get(rownames(attr(terms(forml,keep.order = TRUE), "factors"))[1]))
		N <- attributes(y)$Size
	}
	if (method=="residual")
	{
		y <- reference.summary$residuals
	}
	perm <- matrix(0, nrow = permutations, ncol = (length(formterms)+1))
	permformula <- as.formula(paste("permvec ~",paste(formterms, collapse="+"))) 
	for (i in 1:permutations) 
	{
		take <- sample(N,N)
		permvec <- as.dist(as.matrix(y)[take, take])
		perm.summary <- summary(lm(permformula))
		perm[i,] <- as.vector(c(perm.summary$r.squared,abs(perm.summary$coefficients[begincoeff:endcoeff]))) #Reports the R2 and partial t's for each lm permutation
	}
	signif <- (rowSums(apply(perm,1,function(x){x>statistic}))+1)/(permutations+1)  #The "+1"s of the formula are due to Hope (1968) who added the reference value itself to the distribution to make the test slightly more "conservative" (Legendre et al. 1994). TODO use apply
	result <- list(permutations=permutations,r.squared=statistic[1],significance.r=signif[1],significance.terms=signif[2:length(signif)])
	return(result)
}