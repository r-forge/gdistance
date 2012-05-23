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
The binary string determines which are the 'link species'. Given a sequence of link species it calculates a diversity index. The Weitzman index is defined as the maximum value that can be attained by changing the binary sequence. 

The function is provided here separately for users who want to use it in parallel processing. For instance, the package rgenoud provides a genetic algorithm that can be automatically parallelized in R. 

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

WeitzmanCalc(c(1,0,1), distObj)
WeitzmanCalc2(c(4,2,3,1), distObj)

# modified from example in ?optim
genseq <- function(sq, ...) {  # Generate new candidate sequence
    idx <- seq(1, length(sq))
    changepoints <- sample(idx, size=2, replace=FALSE)
    tmp <- sq[changepoints[1]]
    sq[changepoints[1]] <- sq[changepoints[2]]
    sq[changepoints[2]] <- tmp
    sq
}

optim(c(2,1,3,4), fn=WeitzmanCalc2, gr=genseq, distObject=distObj, method="SANN", control=list(fnscale=-1, maxit=100))

  }

\keyword{ spatial }
