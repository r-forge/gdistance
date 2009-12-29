\name{sumT}
\alias{sumT}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Summing transition objects}
\description{
Special methods to sum Transition objects }
\usage{
sumT(transition1, transition2)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{transition1}{object of class Transition}
  \item{transition2}{object of class Transition}  
}
\details{
This function is meant to sum Transition objects taking the resistance values instead of the conductance values. In other words, the function calculates the reciprocal of the summed reciprocals. 

If matrixValues(transition) is equal to "conductance" the reciprocal of the values is taken (1 / conductance), if it is equal to "resistance", the values are used. 

Zero values are ignored, but caution is required with floating point operations resulting in near-zero values.

To treat a Transition object as containing resistance values instead of conductance values, use \code{matrixValues()<-"resistance"}.
}
\value{
Transition object containing conductance values.
}
\note{
This function is useful to create barriers (with a certain resistance), with the rest having no resistance (value 0). This is difficult to realize with conductance values, as a matrix mostly filled with Inf values would be needed, which would be a dense matrix, occupying much memory.
}
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com} }
\examples{
#example
}
\keyword{ spatial }

