\name{WeitzmanUtility}
\alias{WeitzmanUtility}
\title{Weitzman's Utility Index}
\description{
  Calculates Weitzman's utility (diversity) index from a distance matrix.
}
\usage{
WeitzmanUtility(distObject, iters, popSize)
}
\arguments{
  \item{distObject}{ dist object }
  \item{iters}{number of iterations}
  \item{popSize}{population size}  
}
\details{
The index is calculated by optimizing the WeitzmanCalc function using a simple binary genetic algorithm.

}
\value{
  single value
}
\references{ 
Weitzman, M.L. 1992. On diversity. Quarterly Journal of Economics 107(2), 363-405.
Thaon d'Arnoldi, C. J.-L. Foulley, L. Ollivier. 1998. An overview of the Weitzman approach to diversity. Genetics, Selection, Evolution 30, 149-161.
}
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com} 
Optimization code adapted from genalg package by Egon Willighagen }
\note{ 
}
\seealso{ }
\examples{
#Example from Thaon d'Arnoldi (1998), data originally presented in Weitzman (1992)
   distObj <- dist(matrix(nrow=4,ncol=4))
   distObj[] <- c(357,532,498,477,488,126)
   WeitzmanUtility(distObj,iters=10,popSize=10)

#Having too few iterations and a small population can give suboptimal (e.g. too low) results
   a <- vector(length=100)
   for(i in 1:100){a[i] <- WeitzmanUtility(distObj,iters=1,popSize=5)}
   hist(a)
  }


\keyword{ spatial }
