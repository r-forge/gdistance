\name{WeitzmanCalc}
\alias{WeitzmanCalc}
\title{Auxiliary function to calculate Weitzman's Utility Index}
\description{
  Function to be optimized given a distance matrix to obtain Weitzman's utility (diversity) index.
}
\usage{
WeitzmanCalc(binarySeq, distObject)
}
\arguments{
  \item{binarySeq}{binary sequence (vector of 0s and 1s)}
  \item{distObject}{ dist object } 
}
\details{
The binary string determines which are the 'link species'. Given a sequence of link species it calculates Weitzman's utility index. The true index is the maximum value that can be attained by changing the binary sequence. 

The function is provided here separately for users who want to optimize it using parallel processing. The package rgenoud can be used to do this. 

For small matrices, use the function WeitzmanUtility.
}
\value{
  single value
}
\references{ 
Thaon d'Arnoldi, C. J.-L. Foulley, L. Ollivier. 1998. An overview of the Weitzman approach to diversity. Genetics, Selection, Evolution 30, 149-161.
Weitzman, M.L. 1992. On diversity. Quarterly Journal of Economics 107(2), 363-405.
 }
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com} 
 }
\note{ 
}
\seealso{ }
\examples{
#Example from Thaon d'Arnoldi (1998), data originally presented in Weitzman (1992)

distObj <- dist(matrix(nrow=4,ncol=4))
distObj[] <- c(357,532,498,477,488,126)

WeitzmanUtility(distObj)

  }

\keyword{ spatial }
