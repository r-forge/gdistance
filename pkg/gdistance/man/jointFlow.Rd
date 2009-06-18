\name{jointFlow}
\alias{ jointFlow }
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Joint-trajectory distance }
\description{
  Calculates the joint-flow distance between points.
}
\usage{
jointFlow (transition, originCoord, fromCoords, toCoords)
}

\arguments{
  \item{transition}{ object of class Transition }
  \item{originCoord}{ origin of flow point location (of SpatialPoints class)} 
  \item{fromCoords}{ first set of point locations (of SpatialPoints class)}  
  \item{toCoords}{ second, optional set of point locations (of SpatialPoints class)} 
  \item{type}{ type of coefficient to be calculated: normalized dot product ("ndp") or Jaccard-Tanimoto ("JT")}
}
\details{
  The joint-flow distance is a similarity measure of the trajectories of flow from a common origin to two different locations.
  
  For each point the function calculates a flow trajectory from the origin (see function flowMap). Subsequently it calculates the similarity of the trajectories for each pair of points. 
  
  The trajectory similarity can be calculated as the dot product, normalized dot product (cosine similarity) or the Jaccard-Tanimoto coefficient of the two vectors with flow intensity values.
}
\value{
  distance matrix (if only fromCoords is supplied) or matrix (if both fromCoords and toCoords are supplied).
}
\references{ 
J. van Etten & R.J. Hijmans. forthcoming.
}
\author{ jacobvanetten@yahoo.com \email{jacobvanetten@yahoo.com} }
\note{ 
}
\seealso{ The function \code{\link{flowMap}} demonstrates the calculation of flow trajectories. }
\examples{
#create a new raster and set all its values to unity.
raster <- raster(nrows=18, ncols=36) 
raster <- setValues(raster,rep(1,ncell(raster)))

#create a Transition object from the raster
tr <- TransitionFromRaster(raster,mean,4)

#create origin coordinate and two sets of coordinates
sPorg <- SpatialPoints(t(matrix(c(0,0))))
sP1 <- SpatialPoints(cbind(c(65,5,-65),c(55,35,-35)))
sP2 <- SpatialPoints(cbind(c(50,15,-40),c(80,20,-5)))

#from and to identical
jointFlow(tr, sPorg, sP1, type="ndp")

#from and to different -- to be implemented
#jointFlow(tr,sPorg, sP1, sP2)
}

\keyword{ spatial }

