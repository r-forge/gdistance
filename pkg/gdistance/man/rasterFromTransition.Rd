\name{TransitionMap}
\alias{TransitionMap}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ RasterLayer from Transition* object }
\description{
  This function converts the Transition object into a RasterLayer with the mean of the non-zero values of the transition matrix as raster values.
  It is meant to quickly visualize a Transition object as a map.  
}
\usage{
TransitionMap(transition)
}
\arguments{
  \item{transition}{ object of class Transition }
}
\value{
RasterLayer
}
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com}}

\examples{
#example
}
\keyword{ spatial }