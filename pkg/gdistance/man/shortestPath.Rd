\name{shortestPath}
\alias{shortestPath}
\alias{shortestPath,TransitionLayer,Coords,Coords-method}

\title{ Shortest path }
\description{
  Calculates the shortest path from an origin to a goal. 
}
\usage{
shortestPath(transition, origin, goal, output)
}
\arguments{
  \item{transition}{\code{TransitionLayer} object}
  \item{origin}{SpatialPoints, vector or matrix with coordinates}
  \item{goal}{SpatialPoints, vector or matrix with coordinates}
  \item{output}{Class of desired output object; either "TransitionLayer" (default) or "SpatialLines"}
}
\details{
  If there is more than one path either (1) transition values in the TransitionLayer get values of 1 / number of paths or (2) the SpatialLines object will contain more than one line.
}
\value{
  Transition object.
}

\author{ Jacob van Etten \email{jacobvanetten@yahoo.com}.}

\seealso{ \code{\link[gdistance]{costDistance}}, \code{\link[gdistance]{accCost}} }
\examples{
  #Create a new raster and set all its values to a random value.
  r <- raster(nrows=18, ncols=36) 
  r <- setValues(r,runif(ncell(r), 0.4, 0.6))

  #Create a Transition object from the raster
  tr <- TransitionFromRaster(r,mean,8)
  trC <- geoCorrection(tr, type="c")

  #Create two sets of coordinates
  sP1 <- SpatialPoints(cbind(-105,55))
  sP2 <- SpatialPoints(cbind(105,-55))

  #Calculate the shortest path
  sPath1 <- shortestPath(tr, sP1, sP2)
  sPath2 <- shortestPath(tr, sP1, sP2, output="SpatialLines")
  plot(TransitionMap(sPath1))
  lines(sPath2)
}

\keyword{ spatial }
