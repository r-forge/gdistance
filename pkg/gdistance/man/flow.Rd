\name{flow}
\alias{flow}
\alias{flow,Transition,SpatialPoints,SpatialPoints,missing,logical,character,missing-method}
\alias{flow,Transition,SpatialPoints,SpatialPoints,missing,logical,character,numeric-method}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Flow: path overlap and non-overlap}
\description{
Calculate the overlap and non-overlap of two paths departing from a common origin. Two algorithms are available: random walk and randomised shortest paths.}
\usage{
flow(transition, origin, fromCoords, toCoords, norml, type, theta)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{transition}{transition matrix (class Transition)}
  \item{origin}{coordinates of the origin (one point location, SpatialPoints class)}  
  \item{fromCoords}{coordinates of the destinations (SpatialPoints class)}
  \item{toCoords}{second set of coordinates of the destinations (only "missing" implemented)}
  \item{norml}{normalisation to values between 0 and 1}
  \item{type}{a vector of one or two calculation types c("divergent","joint")}  
  \item{theta}{theta value between 0 and 20 (randomised shortest path) or missing (random walk)}
}
\details{
This function calculates the overlap and non-overlap in the random walk trajectories originating in a single point to sets of other locations.

Probabilities of joint passage or divergence are calculated for each cell-to-cell connection. These are multiplied by the resistance (1/conductance) of each connection and summed.
}
\value{
dist object (when toCoords lacks) or matrix (when toCoords is given)
}
\references{
  McRae B.H., B.G. Dickson, and T. Keitt. 2008. Using circuit theory to model connectivity in ecology, evolution, and conservation. \emph{Ecology} 89:2712-2724.
  
  Saerens M., L. Yen, F. Fouss, and Y. Achbany. 2009. Randomized shortest-path problems: two related models. \emph{Neural Computation}, 21(8):2363-2404.
}
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com}. Implementation of randomised shortest paths based on Matlab code by Marco Saerens. }
\note{ 

The function needs to be optimized and requires much calculation time when Transition objects are large.
}
\examples{
#create Transition object
r <- raster(ncol=36,nrow=18)
r <- setValues(r,rep(1,times=ncell(r)))
tr <- TransitionFromRaster(r,mean,directions=4)

#two different types of correction are required
trR <- geoCorrection(tr, type="r", multpl=FALSE)
trC <- geoCorrection(tr, type="c", multpl=FALSE)

#points for origin and coordinates between which to calculate path (non)overlaps
sP0 <- SpatialPoints(cbind(0,0))
sP1 <- SpatialPoints(cbind(c(65,5,-65),c(-55,35,-35)))

#randomised shortest paths
trC <- trC / max(transitionMatrix(trC)) #rescale as needed; exp(-theta * trC) should give reasonable values
flow(trC, origin=sP0, fromCoords=sP1, norml=FALSE, type=c("divergent","joint"), theta=2)

#random walk
flow(trR, origin=sP0, fromCoords=sP1, norml=FALSE, type=c("divergent","joint"))

}
\keyword{ spatial }

