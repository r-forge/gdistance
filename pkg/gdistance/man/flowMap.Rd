\name{flowMap}
\alias{flowMap}
\alias{flowMap,Transition,SpatialPoints,SpatialPoints-method}
\alias{flowMap,Transition,RasterLayer,RasterLayer-method}

\title{ Flow map }
\description{
  Calculates for each cell the retrospective probability of passage of a random-walk originating from a certain origin going to a goal. Origins and goals can be either a single cell or multiple cells. In the case of multiple goal/origin cells, all cells contribute equally.
}
\usage{
flowMap (transition, origin, goal)
}
\arguments{
  \item{transition}{object of class Transition}
  \item{origin}{SpatialPoints or RasterLayer object with origin cells set to TRUE}
  \item{goal}{SpatialPoints or RasterLayer object with origin cells set to TRUE}
}
\value{
  RasterLayer object
}
\references{ 
McRae, B.H. 2006. Isolation by resistance. \emph{Evolution} 60(8), 1551-1561. 
 }
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com}}

\seealso{ \code{\link[gdistance]{resistanceDistance}} }
\examples{
#example
  }

\keyword{ spatial }
