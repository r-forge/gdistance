\name{geoCorrection}
\alias{geoCorrection}
\alias{geoCorrection,Transition,character,logical-method}
\title{ Geographic Correction }
\description{ Correct Transition objects taking into account local distances
}

\usage{
geoCorrection(transition, type, multpl)
}
\arguments{
  \item{transition}{transition matrix (class Transition)}
  \item{type}{type of correction: "c" or "r" (see below)}  
  \item{multpl}{matrix with correction factor (TRUE) or corrected values (FALSE)}

}
\details{
Geographic correction is necessary for all objects of the class Transition that are either:
(1) based on a grid in a geographic projection (latlon) and covering a large area
(2) made with directions > 4.

The function will correct for map distortion, as well as for diagonal connections between grid cells (which cover a longer distance than vertical or horizontal connections).

When working with latlon grids, users should also anticipate whether they will use methods based on either least cost or random walks. In the case of random walks there will be an additional correction which reduces the conductance in North-South direction.

For repetitive correction of similar Transition objects, it is helpful to have a Transition matrix with just the correction factors. Set multpl to TRUE if you want the corrected values directly. Set multpl to FALSE if you want the correction factors. Correction is achieved by multiplying the original matrix with the matrix with correction factors. 
}
\value{
  Transition object
}
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com} }
\examples{
r <- raster(ncol=36,nrow=18)
r <- setValues(r,rep(1,times=ncell(r)))
tr <- TransitionFromRaster(r, mean, directions=8)
tr1 <- geoCorrection(tr, type="c", multpl=FALSE)
trCorr <- geoCorrection(tr, type="c", multpl=TRUE)
tr2 <- tr * trCorr
}
\keyword{methods}
\keyword{spatial}