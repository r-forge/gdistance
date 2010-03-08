\name{normalize}
\alias{normalize}
\alias{normalize,Transition-method}
\title{ normalize }
\description{  Normalize the transition matrix.
}

\usage{
normalize(transition)
}
\arguments{
  \item{transition}{transition matrix (class Transition)}
 }
\details{
Normalization of the weighted adjacency matrix in the Transition object to obtain the transition probabilities.

von Luxburg (2007) refers to this normalization as the "random walk" normalization.
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

}
\keyword{methods}
\keyword{spatial}