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
  \item{type}{type of correction: ´c´ or ´r´, see below)}  
  \item{multpl}{matrix with correction factor (TRUE) or corrected values (FALSE)}

}
\details{
Geographic correction is necessary for all objects of the class Transition that are either:
(1) based on a grid in a geographic projection (latlon) and covering a large area
(2) made with directions > 4.

The function will correct for projection distortion of geographic projections, as well as for diagonal connections between grid cells (which cover a longer distance than vertical or horizontal connections).

Users should also anticipate whether they will use methods based on either least cost or random walks. In the case of random walks there will be an additional correction which reduces the conductance in North-South direction.

Set multpl to TRUE if you want the corrected values directly. Set multpl to FALSE if you want the correction factors. 

For repetitive correction of similar Transition objects, it is helpful to have a Transition matrix with just the correction factors. Correction is achieved by multiplying with this matrix. 
}
\value{
  Transition object
}
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com} }

\keyword{methods}
\keyword{spatial}