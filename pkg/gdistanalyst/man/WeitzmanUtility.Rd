\name{WeitzmanUtility}
\alias{WeitzmanUtility}
\title{Weitzman's Utility Index}
\description{
  Calculates Weitzman's utility (diversity) index from a distance matrix.
}
\usage{
WeitzmanUtility(distObject)
}
\arguments{
  \item{distObject}{ dist object }
  \item{iters}{number of iterations}
  \item{popSize}{population size}  
}
\details{

}
\value{
  single value
}
\references{ 
Weitzman, M.L. 1992. On diversity. Quarterly Journal of Economics 107(2), 363-405.
 }
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com} 
Optimization code adapted from genalg package by Egon Willighagen }
\note{ 
}
\seealso{ }
\examples{
distObj <- dist(matrix(nrow=4,ncol=4))
distObj[] <- c(357,532,498,477,488,126)

WeitzmanUtility(distObj)

  }
}

\keyword{ spatial }
