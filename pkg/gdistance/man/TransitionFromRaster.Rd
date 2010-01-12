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
When a symmetric transition matrix is required, the user should supply a transitionFunction f that obeys f(a,b) = f(b,a) (a commutative function).

To obtain an asymmetric transition matrix, an additional argument `symm' should be set to FALSE. 
}
\value{
Transition object
}

\author{ Jacob van Etten \email{jacobvanetten@yahoo.com}}
\examples{
#create a new raster and set all its values to unity.
raster <- raster(nrows=18, ncols=36) 
raster <- setValues(raster,rep(1,ncell(raster)))

#create a Transition object from the raster
tr <- TransitionFromRaster(raster,mean,4)

#create an asymmetric transition matrix
f <- function(x) max(x) - x[1] + x[2] #an arbitrary non-commutative function 
tr <- TransitionFromRaster(raster,f,4,symm=FALSE)
}
\keyword{ spatial }

