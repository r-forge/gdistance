\name{probPassage}
\alias{probPassage}
\alias{probPassage,Transition,SpatialPoints,SpatialPoints,missing-method}
\alias{probPassage,Transition,SpatialPoints,SpatialPoints,numeric-method}
\alias{probPassage,Transition,RasterLayer,RasterLayer,missing-method}
\alias{probPassage,Transition,RasterLayer,RasterLayer,numeric-method}

\title{ Probability of passage }
\description{
  Calculates for each cell the retrospective probability of passage of a random-walk or randomised shortest paths with given origin(s) and destination(s).  In the case of multiple origins or destinations, each receives equal weight. 
}
\usage{
probPassage(transition, origin, goal, theta)
}
\arguments{
  \item{transition}{object of class Transition}
  \item{origin}{SpatialPoints object or RasterLayer object with origin cells set to TRUE}
  \item{goal}{SpatialPoints object or RasterLayer object with origin cells set to TRUE}
  \item{theta}{missing (random walk) or numeric between 0 and 20 (randomised shortest paths)}
}
\value{
  RasterLayer object
}
\references{ 
  McRae B.H., B.G. Dickson, and T. Keitt. 2008. Using circuit theory to model connectivity in ecology, evolution, and conservation. \emph{Ecology} 89:2712-2724.
  
  Saerens M., L. Yen, F. Fouss, and Y. Achbany. 2009. Randomized shortest-path problems: two related models. \emph{Neural Computation}, 21(8):2363-2404.
 }
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com}. Implementation of randomised shortest paths based on Matlab code by Marco Saerens.}

\seealso{ \code{\link[gdistance]{resistanceDistance}} }
\examples{
#create a new raster and set all its values to unity.
raster <- raster(nrows=18, ncols=36) 
raster <- setValues(raster,rep(1,ncell(raster)))

#create a Transition object from the raster
tr <- TransitionFromRaster(raster,mean,4)

#create two coordinates
sP1 <- SpatialPoints(cbind(-105,55))
sP2 <- SpatialPoints(cbind(105,-55))

#randomised shortest paths with theta = 2
rSPraster <- probPassage(tr, sP1, sP2, 2)
plot(rSPraster)
points(sP1)
points(sP2)

#randomised shortest paths with theta = 0.05
#leaves the origin and often passes it again before arriving
rSPraster <- probPassage(tr, sP1, sP2, 0.05)
plot(rSPraster) 
points(sP1)
points(sP2)

#random walk
rwraster <- probPassage(tr, sP1, sP2)
plot(rwraster)
points(sP1)
points(sP2)
  }

\keyword{ spatial }
