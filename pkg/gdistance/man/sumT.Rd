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
  \item{transition1}{transition matrix (class Transition)}
  \item{transition2}{transition matrix (class Transition)}  
}
\details{
This function is meant to sum Transition objects taking the resistance values instead of the conductance values. In other words, the function calculates the reciprocal of the summed reciprocals.
If matrixValues(transition) is equal to "conductance" the reciprocal of the values is taken (1/C), if it is equal to "resistance", the values are used.
To treat a Transition object as containing resistance values instead of conductance values, use matrixValues().
The result is always a Transition object containing conductance values.
}
\value{
Transition object
}

\author{ Jacob van Etten \email{jacobvanetten@yahoo.com} }
\note{ 
}
\seealso{ }
\examples{

}
\keyword{ spatial }

