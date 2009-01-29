\name{flowMap}
\alias{ flowMap }
\title{ Flow map }
\description{
  Calculates for each cell the retrospective probability of passage of a random-walk particle originating from a single source cell and detected in a single goal cell.
}
\usage{
flowMap (transition, originCoord, goalCoord)
}
\arguments{
  \item{transition}{ object of class Transition }
  \item{originCoord}{ coordinates of the origin cell }
  \item{goalCoord}{ coordinates of the goal cell }
}
\details{

}
\value{
  RasterLayer object
}
\references{ 
See resistanceDistance, jointTrajectory
 }
\author{ Jacob van Etten }
\note{ 
}
\seealso{ ~~objects to See Also as \code{\link{resistanceDistance}}, ~~~ }
\examples{

  }
}

\keyword{ spatial }
