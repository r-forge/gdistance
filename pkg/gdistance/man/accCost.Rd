\name{accCost}
\alias{accCost}
\alias{accCost,Transition,RasterLayer-method}
\alias{accCost,Transition,Coords-method}
\title{ Accumulated Cost Surface }
\description{
Calculates the accumulated cost surface from one or more origins. }
\usage{
accCost(transition, fromCoords)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{transition}{ object of class Transition }
  \item{fromCoords}{ origin point locations (SpatialPoints, matrix or numeric class) or surface (RasterLayer class) }
}
\details{
If more than one coordinate is supplied in fromCoords, the function calculates the minimum least-cost distance from any origin point.

The function uses Dijkstra's algorithm (as implemented in the igraph package) if an object of the class SpatialPoints is provided.

It uses an iterative algorithm implemented in this package, when an object of the class RasterLayer is provided.

A projection correction is needed for accuracy, if the Transition object is based on grid data for a large area in a geographic (latlon) projection (see function \code{\link{geoCorrection}}). 
}
\value{
RasterLayer
}
\references{
E.W. Dijkstra. 1959. A note on two problems in connexion with graphs. \emph{Numerische Mathematik} 1, 269 - 271.
}
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com}}
\seealso{ \code{\link[gdistance]{geoCorrection}}, \code{\link[gdistance]{costDistance}} }
\examples{
r1 <- raster(ncol=36,nrow=18)
r2 <- r1
data <- rep(NA,length=ncell(r1))
data[500] <- 1
r1 <- setValues(r1,data)
r2 <- setValues(r2,rep(1,times=ncell(r2)))
tr <- TransitionFromRaster(r2, mean, directions=4)
tr <- geoCorrection(tr, type="c", multpl=FALSE)
cmd1 <- accCost(tr, r1)

# Or directly
spObj <- SpatialPoints(xyFromCell(tr,500))
cmd2 <- accCost(tr, spObj)
}
\keyword{ spatial }
