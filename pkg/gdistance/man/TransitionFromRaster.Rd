\name{TransitionFromRaster }
\alias{TransitionFromRaster }
\alias{TransitionFromRaster,RasterLayer-method}
\alias{TransitionFromRaster,RasterBrick-method}
\title{ Create an object of the class Transition }
\description{
  Create a Transition object from a RasterLayer or RasterBrick object. Transition values are calculated with a user-defined function from the grid values.
}
\usage{
TransitionFromRaster (object, transitionFunction, directions, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{ RasterLayer or RasterBrick }
  \item{transitionFunction}{ Function to calculate transition values from grid values}
  \item{directions}{ Directions in which cells are connected (4, 8, 16, or other), see \code{\link[raster]{adjacency}} }
  \item{...}{ Additional arguments, see below }
}
\details{
When a symmetric transition matrix is required, the user should supply a transitionFunction f that obeys f(a,b) = f(b,a) (a commutative function). TransitionFromRaster() does no commutativity check.

To obtain an asymmetric transition matrix, an additional argument `symm' should be set to FALSE.
}
\value{
Transition object
}

\author{ Jacob van Etten \email{jacobvanetten@yahoo.com}}
\examples{
#create a new raster and set all its values to unity.
r <- raster(nrows=18, ncols=36) 
r <- setValues(r, runif(ncell(r)))

#create a Transition object from the raster
tr <- TransitionFromRaster(r, transitionFunction=mean, directions=4)
tr #the sparse matrix is of class dsCMatrix (symmetric)

#create an asymmetric transition matrix
#first, an arbitrary non-commutative function 
f <- function(x) max(x) - x[1] + x[2] 
tr2 <- TransitionFromRaster(r, f, 4, symm=FALSE)
tr2 #the sparse matrix is of class dgCMatrix (asymmetric)
}
\keyword{ spatial }

