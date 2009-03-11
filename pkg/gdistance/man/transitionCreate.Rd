\name{transitionCreate }
\alias{transitionCreate }
\title{ Create an object of the class Transition }
\description{
  Transition objects are created from Raster* objects. Conductance values will be calculated based on the grid values with a user-defined function.
}
\usage{
transitionCreate (object, transition.function, outer.meridian.connect)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{ RasterLayer or RasterStack }
  \item{transition.function}{ Function to calculate conductance values from grid values}
}
\value{
Transition
}
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com}}
\examples{}
\keyword{ spatial }

