\name{permReg}
\alias{permReg}
\title{Permutational regression with distance data}
\description{
  Regression with distance data, determining significance by permuting row-columns in the distance matrix.
}
\usage{
permReg(forml, perm, method, dat)
}
\arguments{
  \item{forml}{regression formula}
  \item{perm}{number of permutations} 
  \item{method}{method to determine significance, "raw" or "residuals" (default)}
  \item{dat}{data}
}
\details{
The data can be constructed by binding the distance matrices into a dataframe (as.data.frame(cbind(dist1, dist2, dist3))). Alternatively, the default dat=NULL is used and the data are provided as dist objects in the environment from which the function is called.
}
\value{
  List with permutations, R2, p values of the whole equation and each term separately, and the regression coefficients

}
\references{ 
Legendre, P., F.-J. Lapointe & P. Casgrain. 1994. Modeling brain evolution from behavior: a permutational regression approach. Evolution 48: 1487-1499. 
 }
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com} 
 }
\note{
 
}
\seealso{ }
\examples{

  }

\keyword{  }
