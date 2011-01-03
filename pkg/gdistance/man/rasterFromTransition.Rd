\name{raster}
\alias{raster}
%- THIS SHOULD BE A METHOD FILE, NOT DOCUMENTING A NEW FUNCTION
\title{ RasterLayer from TransitionLayer object }
\description{
  This function can be used to obtain a RasterLayer from a TransitionLayer.
}
\usage{
raster(transition, reduceMethod)
}
\arguments{
  \item{transition}{ object of class \code{TransitionLayer} }
  \item{reduceMethod}{the method to reduce the transition matrix; see below for details}
}
\value{
RasterLayer
}
\details{
  The following methods to ``reduce" the transition matrix are available (argument \code{reduceMethod}): 
  colSums
  rowSums
  colMeans
  rowMeans
  NZcolMeans
  NZrowMeans

  The latter two methods only take into account the non-zero entries in the transition matrix.
  
  The default is NZcolMeans.
}
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com}}

\examples{
#create a new raster and set all its values to unity.
r <- raster(nrows=18, ncols=36) 
r <- setValues(r,runif(ncell(r),0,1))

#create a Transition object from the raster
tr1 <- transition(r,mean,8)

#asymmetric
asf <- function(x) max(x) - x[1] + x[2]
tr2 <- transition(r,asf,8, symm=FALSE)

#create RasterLayer objects
r1 <- raster(tr1)
r2 <- raster(tr2)
r3 <- raster(tr1, "colMeans")
}
\keyword{ spatial }