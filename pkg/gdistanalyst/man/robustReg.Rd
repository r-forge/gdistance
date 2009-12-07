\name{permRegDist}
\alias{permRegDist}
\title{Permutational regression with distance data}
\description{
  Robust regression with distance data, excluding outliers using a genetic algorithm.
}
\usage{
robustReg(forml, dat, p, iter, popSize, maxNoImprove mutationNo, verbose)
}
\arguments{
  \item{forml}{regression formula}
  \item{dat}{data} 
  \item{p}{number of observations to be included}
  \item{iter}{number of iterations}
  \item{popSize}{population size}
  \item{maxNoImprove}{maximum number of iterations without improvement}
  \item{mutationNo}{number of mutations}
  \item{verbose}{detailed reporting of progress}  
}
\details{
If p is 0 (default), it is set to floor(n/2) + 1, in which n is the dimension of the distance matrix.

The algorithm was inspired by Nunkesser & Morell (2009). The algorithm was adapted to distance matrices in which cases correspond to rows and columns. Two other major differences with Nunkesser & Morell (2009) are that (1) operators are applies in fixed fractions (1/3 each) and that (2) after iteration 1 mutation of existing individuals is done instead creation of new individuals. If mutationNo is set very high, the same effect achieved, however.

The genetic algorithm was inspired by the genalg package by Egon Willighagen <e.willighagen@science.ru.nl>. The original code was available under GNU licence version 2.
}
\value{

}
\references{ 
Nunkesser, R., & O. Morell. 2009. Evolutionary algorithms for robust methods. Sonderforschungsbereich (SFB) 475.
 }
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com} 
 }
\note{
 
}
\seealso{ }
\examples{

  }

\keyword{  }