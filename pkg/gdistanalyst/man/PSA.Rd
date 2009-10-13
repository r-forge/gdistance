\name{PSA}
\alias{PSA}
\title{Proportion of shared alleles}
\description{
  Calculates the proportion of shared alleles from a three column matrix with SSR data.
}
\usage{
PSA(data, nullAlleles, correction)
}
\arguments{
  \item{data}{SSR data as a matrix with three columns: sample ID, marker, fragment length}
  \item{nullAlleles}{how should fragment length = 0 be treated} 
  \item{correction}{correction for missing data} 
}
\details{
The function calculates 1 - PSA. Users can then calculate -log(1 - PSA) to get the logtransformed version.

nullAlleles can be given three values: missing (treats them as missing data), alike (counts 0 alleles as identical), or unlike (treats each 0 alleles as unique). 

If correction is set to TRUE (default) all PSA values Dij are divided by sqrt(Dii) * sqrt (Djj). This sets self-similarity to 1.
}
\value{
  distance matrix
}
\references{ 
Microsat software: http://hpgl.stanford.edu/projects/microsat/
 }
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com} 
 }
\note{
The function has been tested with the dataset available from the microsat website. 
}
\seealso{ }
\examples{

  }

\keyword{  }
