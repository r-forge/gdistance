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
  \item{...}{optional argument method (see below)}
 }
\details{
Normalization of the weighted adjacency matrix in the Transition object.

Matrix values are divided by their respective row-sums, column-sums, or the product of the square-roots of both (symmetric normalization).

The default method is row-normalization. To use another normalization method, users can set the optional method argument to "col" or "symm".

For random walk calculations a symmetric matrix is needed (method = "symm").
}
\value{
  Transition object
}
\references{
von Luxburg, U. 2007. A tutorial on spectral clustering. \emph{Statistics and Computing} 17(4), 395-416.
\url{http://arxiv.org/PS_cache/arxiv/pdf/0711/0711.0189v1.pdf}

Chung, F. 1997. Spectral Graph Theory. Conference Board of the Mathematical Sciences, Washington.
}
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com} }
\examples{
r <- raster(ncol=36,nrow=18)
r <- setValues(r,rep(1,times=ncell(r)))
tr <- TransitionFromRaster(r, mean, directions=8)

tr1 <- normalize(tr)
tr2 <- normalize(tr, method="row")
}
\keyword{methods}
\keyword{spatial}