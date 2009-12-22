\name{TransitionFromRaster }
\alias{TransitionFromRaster }
\alias{TransitionFromRaster,RasterLayer-method}
\alias{TransitionFromRaster,RasterStack-method}
\title{ Create an object of the class Transition }
\description{
  Transition objects are created from Raster* objects. Conductance values will be calculated based on the grid values with a user-defined function.
}
\usage{
TransitionFromRaster (object, transitionFunction, directions)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{ RasterLayer or RasterStack }
  \item{transitionFunction}{ Function to calculate conductance values from grid values}
  \item{directions}{ Directions in which cells are connected (4, 8, 16) }
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
}
\keyword{ spatial }

