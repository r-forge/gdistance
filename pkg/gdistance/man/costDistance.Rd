\name{costDistance}
\alias{costDistance}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Cost distance (least-cost distance) }
\description{
Calculates the least-cost distance between points. }
\usage{
costDistance(transition, fromCoords, toCoords)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{transition}{ transition matrix (class Transition) }
  \item{fromCoords}{ first set of point locations (of SpatialPoints class)}  
  \item{toCoords}{ second, optional set of point locations (of SpatialPoints class)}
}
\details{
Cost units between cells are defined as the reciprocal of the values in the transition matrix (in transition argument).

The function uses Dijkstra's algorithm, as implemented in the igraph package.

A projection correction is needed for accuracy in the case of grid data for a large area in a geographic (latlon) projection (see function \code{\link{geoCorrection}}). 
}
\value{
distance matrix
}
\references{ 
E.W. Dijkstra. 1959. A note on two problems in connexion with graphs. \emph{Numerische Mathematik} 1, 269-271.

}
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com} }
\note{ 
}
\seealso{ \code{\link{geoCorrection}} }
\examples{
#create a new raster and set all its values to unity.
raster <- raster(nrows=18, ncols=36) 
raster <- setValues(raster,rep(1,ncell(raster)))

#create a Transition object from the raster
tr <- TransitionFromRaster(raster,mean,4)

#create two sets of coordinates
sP1 <- SpatialPoints(cbind(c(65,5,-65),c(55,35,-35)))
sP2 <- SpatialPoints(cbind(c(50,15,-40),c(80,20,-5)))

#from and to identical
costDistance(tr,sP1)

#from and to different
costDistance(tr,sP1,sP2)
}
\keyword{ spatial }

