\name{shortestPath}
\alias{shortestPath}
\alias{shortestPath,Transition,SpatialPoints,SpatialPoints-method}
\alias{shortestPath,Transition,numeric,numeric-method}
\alias{shortestPath,Transition,matrix,matrix-method}

\title{ Shortest path }
\description{
  Calculates the shortest path from an origin to a goal. 
}
\usage{
shortestPath(transition, origin, goal)
}
\arguments{
  \item{transition}{Object of class Transition}
  \item{origin}{SpatialPoints object, vector or matrix with coordinates}
  \item{goal}{SpatialPoints object, vector or matrix with coordinates}
}
\details{
  If there is more than one path, transition values get values below 1.
}
\value{
  Transition object.
}

\author{ Jacob van Etten \email{jacobvanetten@yahoo.com}. Implementation of randomised shortest paths based on Matlab code by Marco Saerens.}

\seealso{ \code{\link[gdistance]{costDistance}}, \code{\link[gdistance]{accCost}} }
\examples{
#create a new raster and set all its values to a random value.
raster <- raster(nrows=18, ncols=36) 
raster <- setValues(raster,runif(ncell(raster), 0.4, 0.6))

#create a Transition object from the raster
tr <- TransitionFromRaster(raster,mean,8)
trC <- geoCorrection(tr, type="c")

#create two coordinates
sP1 <- SpatialPoints(cbind(-105,55))
sP2 <- SpatialPoints(cbind(105,-55))

#calculate the shortest path
sPath <- shortestPath(tr, sP1, sP2)
plot(TransitionMap(sPath))
}

\keyword{ spatial }
