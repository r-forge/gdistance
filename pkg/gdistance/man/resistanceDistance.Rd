\name{resistanceDistance}
\alias{ resistanceDistance }
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Resistance distance }
\description{
Calculates the resistance distance between points. }
\usage{
resistanceDistance (transition, fromCoords, toCoords)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{transition}{ transition object (Transition class) }
  \item{fromCoords}{ first set of point locations (of SpatialPoints class)}  
  \item{toCoords}{ second, optional set of point locations (of SpatialPoints class)}  

}
\details{
Resistance distance is equivalent to the expected random-walk commute time between nodes in a graph (Chandra et al. 1997).

The function implements the algorithm given by Fouss et al. (2007).

In the case of grid data for a large area in a geographic (latlon) projection, a projection correction is needed for accuracy (see function \code{\link{geoCorrection}}). 
}
\value{
distance matrix
}
\references{ 
Chandra, A.K., Raghavan, P., Ruzzo, W.L., Smolensy, R. & Tiwari, P. 1996. The electrical resistance of a graph captures its commute and cover times. \emph{Computational Complexity}, 6(4), 312-340.

Fouss, F., Pirotte, A., Renders, J.-M. & Saerens, M. 2007. Random-walk computation of similarities between nodes of a graph with application to collaborative recommendation. \emph{IEEE Transactions on Knowledge and Data Engineering}, 19(3), 355-369.

McRae, B.H. 2006. Isolation by resistance. \emph{Evolution} 60(8), 1551-1561. 
\url{http://www.circuitscape.org}
}
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com} }
\note{ 

}
\seealso{ \code{\link{geoCorrection}}, ~~~ }
\examples{
#create a new raster and set all its values to unity.
raster <- newRaster(nrows=18, ncols=36) 
raster <- setValues(raster,rep(1,ncell(raster)))

#create a Transition object from the raster
tr <- TransitionFromRaster(raster,mean,4)

#create two sets of coordinates
sP1 <- SpatialPoints(cbind(c(65,5,-65),c(55,35,-35)))
sP2 <- SpatialPoints(cbind(c(50,15,-40),c(80,20,-5)))

#from and to identical
resistanceDistance(tr,sP1)

#from and to different
resistanceDistance(tr,sP1,sP2)

}
\keyword{ spatial }

