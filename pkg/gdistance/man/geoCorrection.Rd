\name{geoCorrection-methods}
\docType{methods}
\alias{geoCorrection-methods}
\alias{geoCorrection,Transition-method}
\title{ Geographic Correction}
\description{
Geographic correction is necessary for all objects of the class Transition that are either:
(1) based on a grid in a geographic projection (latlon) and covering a large area
(2) made with directions > 4.

The function will correct for projection distortion of geographic projections, as well as for diagonal connections between grid cells (which cover a longer distance than vertical or horizontal connections).

Users should also anticipate whether they will use methods based on either least cost or random walks. In the case of random walks there will be an additional correction which reduces the conductance in North-South direction.
}
\section{Methods}{
\describe{

\item{transition = "Transition"}{ ~~describe this method here }
}}
\keyword{methods}
\keyword{spatial}
