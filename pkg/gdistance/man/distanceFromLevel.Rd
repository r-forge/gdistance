\name{distanceFromLevel}
\alias{distanceFromLevel}
\title{ Distance from level }
\description{
  Convenience function to create a distance matrix from a vector of levels, using a function specified by the user
}
\usage{
distanceFromLevel(levels, fun, diag=TRUE)
}

\arguments{
  \item{levels}{ vector of values }
  \item{fun}{ distance function }
  \item{diag}{ logical value: should the diagonal be included? }
}
\details{
  Distance function should be commutative: f(a,b) = f(b,a).
}
\value{distance matrix
}
\author{Jacob van Etten \email{jacobvanetten@yahoo.com} }
\examples{
lv <- 1:5
dst <- distanceFromLevel(lv,function(x){abs(x[1]-x[2])},diag=FALSE)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ spatial }

