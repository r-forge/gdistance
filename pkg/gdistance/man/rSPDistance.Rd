\name{rSPDistance}
\alias{ rSPDistance }
\alias{rSPDistance,TransitionLayer,Coords-method}

\title{ Randomized shortest path distance }
\description{
Calculates the randomized shortest path distance between points. }
\usage{
rSPDistance (transition, from, to, theta)
}

\arguments{
  \item{transition}{ \code{TransitionLayer} object) }
  \item{from}{ point locations coordinates (of SpatialPoints, matrix or numeric class)}  
  \item{to}{ point locations coordinates (of SpatialPoints, matrix or numeric class)}
  \item{theta}{ theta is the degree from which the path randomly deviates from the shortest path, 0 < theta < 20}  
}
\details{

  The function implements the algorithm given by Saerens et al. (2009)

}
\value{
distance matrix (S3 class dist or matrix)
}

\references{ 
Saerens M., L. Yen, F. Fouss, and Y. Achbany. 2009. Randomized shortest-path problems: two related models. \emph{Neural Computation}, 21(8):2363-2404.

}
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com} }
\seealso{ \code{\link{geoCorrection}} }
\examples{
#Create a new raster and set all its values to unity.
r <- raster(nrows=18, ncols=36) 
r <- setValues(r,rep(1,ncell(raster)))

#Create a Transition object from the raster
tr <- transition(r,mean,4)

#Create two sets of coordinates
sP1 <- SpatialPoints(cbind(c(65,5,-65),c(55,35,-35)))
sP2 <- SpatialPoints(cbind(c(50,15,-40),c(80,20,-5)))

#Calculate the RSP distance between the points
rSPDistance(tr, sP1, sP2, 1)

}
\keyword{ spatial }