\name{flow}
\alias{flow}
\alias{flow,Transition,SpatialPoints,SpatialPoints,missing,logical,character-method}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Flow: path overlap and non-overlap}
\description{
Calculate the overlap and non-overlap of two paths departing from a common origin.}
\usage{
flow(transition, originCoord, fromCoords, toCoords, norml, type)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{transition}{transition matrix (class Transition)}
  \item{originCoord}{coordinates of the origin (one point location, SpatialPoints class)}  
  \item{fromCoords}{coordinates of the destinations (SpatialPoints class)}
  \item{toCoords}{second set of coordinates of the destinations (optional, SpatialPoints class)}
  \item{norml}{normalisation to values between 0 and 1}
  \item{type}{a vector of one or two calculation types c("divergent","joint")}  
  
}
\details{
This function calculates the overlap and non-overlap in the random walk trajectories originating in a single point to sets of other locations.

Probabilities of joint passage or divergence are calculated for each cell-to-cell connection. These are multiplied by the resistance (1/conductance) of each connection and summed.
}
\value{
dist object (when toCoords lacks)
matrix (when toCoords is given)
}

\author{ Jacob van Etten \email{jacobvanetten@yahoo.com} }
\note{ 

The function needs to be optimized and requires much calculation time when Transition objects are large.
}
\examples{
r1 <- raster(ncol=36,nrow=18)
r2 <- r1
data <- rep(NA,length=ncell(r1))
data[500] <- 1
r1 <- setValues(r1,data)
r2 <- setValues(r2,rep(1,times=ncell(r2)))
tr <- TransitionFromRaster(r2,mean,directions=16)
tr <- geoCorrection(tr, type="r", multpl=FALSE)
#concrete example...
}
\keyword{ spatial }

