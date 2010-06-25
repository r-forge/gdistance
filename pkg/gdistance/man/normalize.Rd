\name{normalize}
\alias{normalize}
\alias{normalize,TransitionLayer-method}
\title{ normalize }
\description{  Normalize the transition matrix.
}

\usage{
normalize(transition, ...)
}
\arguments{
  \item{transition}{transition matrix (class Transition*)}
  \item{...}{optional argument (see below)}
 }
\details{
Normalization of the weighted adjacency matrix in the Transition object to obtain the transition probabilities.

For random walk calculations a symmetric matrix is needed (symm = TRUE).
}
\value{
  Transition object
}
\references{
von Luxburg, U. 2007. A tutorial on spectral clustering. \emph{Statistics and Computing} 17(4), 395-416.
\url{http://arxiv.org/PS_cache/arxiv/pdf/0711/0711.0189v1.pdf}
}
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com} }
\examples{
r <- raster(ncol=36,nrow=18)
r <- setValues(r,rep(1,times=ncell(r)))
tr <- TransitionFromRaster(r, mean, directions=8)

tr1 <- normalize(tr)
tr2 <- normalize(tr, symm=TRUE)
}
\keyword{methods}
\keyword{spatial}