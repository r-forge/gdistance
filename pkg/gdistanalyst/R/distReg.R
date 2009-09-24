permRegDist <- function (forml, perms = 99, method="residual", dat=NULL) 
{
	forml <- as.formula(forml)
	formterms <- rownames(attr(terms(forml,keep.order = TRUE), "factors"))[1:length(rownames(attr(terms(forml), "factors")))] 
	begincoeff <- 2*length(formterms)+2
	endcoeff <- 3*length(formterms)	
	if(!is.null(dat))
	{
		environment(forml) <- environment()
		nc <- length(dat[,1])
		n <- round(optimize(function(n) ( abs(n^2 -n - 2*nc)), interval = c(0, nc*3))[[1]])
		i <- rep(1:n,times=n)
		j <- rep(1:n,each=n)
		ij <- cbind(i,j)
		ij <- subset(ij,ij[,1]>ij[,2])
		for(i in 1:length(formterms))
		{
			value <- matrix(nrow=n,ncol=n)
			value[ij] <- unlist(dat[formterms[i]])
			value <- as.dist(value)
			assign(formterms[i], value)
		}
	}
	reference.summary <- summary(lm(forml)) 
	statistic <- c(reference.summary$r.squared,abs(reference.summary$coefficients[begincoeff:endcoeff])) #Reference statistic
	if (method=="raw")
	{
		y <- as.dist(get(rownames(attr(terms(forml,keep.order = TRUE), "factors"))[1]))
	}
	if (method=="residual")
	{
		y <- reference.summary$residuals
	}
	N <- attributes(y)$Size
	perm <- matrix(0, nrow = perms, ncol = length(formterms))
	permformula <- as.formula(paste("permvec ~",paste(formterms[2:length(formterms)], collapse="+"))) 
	for (i in 1:perms)
	{
		take <- sample(N,N)
		permvec <- as.dist(as.matrix(y)[take, take])
		perm.summary <- summary(lm(permformula))
		perm[i,] <- as.vector(c(perm.summary$r.squared,abs(perm.summary$coefficients[begincoeff:endcoeff]))) #Reports the R2 and partial t's for each lm permutation
	}
	signif <- (colSums(t(t(perm) > statistic)) + 1) / (perms+1)
	
	#signif <- (rowSums(apply(perm,1,function(x){x>statistic}))+1)/(perms+1)  #The "+1"s of the formula are due to Hope (1968) who added the reference value itself to the distribution to make the test slightly more "conservative" (Legendre et al. 1994). 
	
	result <- list(permutations=perm,r.squared=statistic[1],significance.r=signif[1],significance.terms=signif[2:length(signif)],coeff=reference.summary$coefficients[,1])
	return(result)
}