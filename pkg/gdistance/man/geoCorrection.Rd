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
(1) based on a grid in a geographic (latlon) (non)projection and covering a large area; 
(2) made with directions > 4.

The function will correct for map distortion, as well as for diagonal connections between grid cells (which cover a longer distance than vertical or horizontal connections).

When working with latlon grids, users should also anticipate whether they will use methods based on either least cost or random walks, and set the \code{type} argument accordingly. In the case of random walks there will be an additional correction which reduces the conductance in North-South direction.

For repetitive correction of similar Transition objects, it is helpful to have a Transition matrix with just the correction factors. To achieve this, set \code{multpl} to TRUE (the default is FALSE). Correction is achieved by multiplying the original matrix with the matrix with correction factors. 
}
\value{
  Transition object
}
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com} }
\examples{
r <- raster(ncol=36,nrow=18)
r <- setValues(r,rep(1,times=ncell(r)))
tr <- TransitionFromRaster(r, mean, directions=8)

#directly
tr1 <- geoCorrection(tr, type="c", multpl=FALSE)

#the same, but with a separate correction matrix
trCorr <- geoCorrection(tr, type="c", multpl=TRUE)
tr2 <- tr * trCorr
}
\keyword{methods}
\keyword{spatial}