\name{passage}
\alias{passage}
\alias{passage,Transition,SpatialPoints,SpatialPoints,missing-method}
\alias{passage,Transition,SpatialPoints,SpatialPoints,numeric-method}
\alias{passage,Transition,RasterLayer,RasterLayer,missing-method}
\alias{passage,Transition,RasterLayer,RasterLayer,numeric-method}
\alias{passage,Transition,numeric,numeric,numeric-method}
\alias{passage,Transition,numeric,numeric,missing-method}
\alias{passage,Transition,matrix,matrix,numeric-method}
\alias{passage,Transition,matrix,matrix,missing-method}

\title{ Probability of passage }
\description{
  Calculates for each cell the number of passages of a random-walk or randomised shortest paths with given origin(s) and destination(s). Either the total or the net number of passages can be calculated.  In the case of multiple origins or destinations, each receives equal weight. 
}
\usage{
passage(transition, origin, goal, theta, ...)
}
\arguments{
  \item{transition}{Object of class Transition}
  \item{origin}{SpatialPoints object or RasterLayer object with origin cells set to TRUE}
  \item{goal}{SpatialPoints object or RasterLayer object with origin cells set to TRUE}
  \item{theta}{If theta is zero or missing random walk results, if a numeric value 0 < theta < 20 is given, randomised shortest paths are calculated}
  \item{...}{Additional arguments: totalNet ("total" or "net"), and output ("RasterLayer" or "Transition")}
}
\details{
  The net number of passages between i and j is defined as: | passages from i to j - passages from j to i |.
  
  Defaults for additional argument totalNet is "net" and for output it is "RasterLayer".
}
\value{
  RasterLayer or Transition object, depending on the output argument.
}
\references{ 
McRae B.H., B.G. Dickson, and T. Keitt. 2008. Using circuit theory to model connectivity in ecology, evolution, and conservation. \emph{Ecology} 89:2712-2724.
  
Saerens M., L. Yen, F. Fouss, and Y. Achbany. 2009. Randomized shortest-path problems: two related models. \emph{Neural Computation}, 21(8):2363-2404.
 }
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com}. Implementation of randomised shortest paths based on Matlab code by Marco Saerens.}

\seealso{ \code{\link[gdistance]{resistanceDistance}}, \code{\link[gdistance]{pathInc}} }
\examples{
#create a new raster and set all its values to unity.
raster <- raster(nrows=18, ncols=36) 
raster <- setValues(raster,rep(1,ncell(raster)))

#create a Transition object from the raster
tr <- TransitionFromRaster(raster,mean,4)
trC <- geoCorrection(tr, type="c")
trR <- geoCorrection(tr, type="r")

#create two coordinates
sP1 <- SpatialPoints(cbind(-105,55))
sP2 <- SpatialPoints(cbind(105,-55))

#randomised shortest paths with theta = 2
rSPraster <- passage(tr, sP1, sP2, 2)
plot(rSPraster)
points(sP1)
points(sP2)

#randomised shortest paths with theta = 0.05
#leaves the origin and often passes it again before arriving
rSPraster <- passage(trC, sP1, sP2, 0.05)
plot(rSPraster) 
points(sP1)
points(sP2)

#random walk
rwraster <- passage(trR, sP1, sP2)
plot(rwraster)
points(sP1)
points(sP2)
  }

\keyword{ spatial }
