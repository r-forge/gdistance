\name{flowMap}
\alias{flowMap}
\alias{flowMap,Transition,SpatialPoints,SpatialPoints-method}
\alias{flowMap,Transition,RasterLayer,RasterLayer-method}

\title{ Flow map }
\description{
  Calculates for each cell the retrospective probability of passage of a random-walk with given origin(s) and destination(s).  In the case of multiple origins or destinations, each receives equal weight. 
}
\usage{
flowMap (transition, origin, goal)
}
\arguments{
  \item{transition}{object of class Transition}
  \item{origin}{SpatialPoints object or RasterLayer object with origin cells set to TRUE}
  \item{goal}{SpatialPoints object or RasterLayer object with origin cells set to TRUE}
}
\value{
  RasterLayer object
}
\references{ 
  McRae, B.H. 2006. Isolation by resistance. \emph{Evolution} 60(8), 1551-1561. 
  McRae B.H., B.G. Dickson, and T. Keitt. 2008. Using circuit theory to model connectivity in ecology, evolution, and conservation. \emph{Ecology} 89:2712-2724.
 }
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com}}

\seealso{ \code{\link[gdistance]{resistanceDistance}} }
\examples{
#example
  }

\keyword{ spatial }
