\name{ArithMath-methods}

\docType{methods}

\alias{Arith-methods}
\alias{Arith,ANY,TransitionLayer-method}
\alias{Arith,TransitionLayer,ANY-method}
\alias{Arith,TransitionLayer,TransitionLayer-method}
\alias{Arith,TransitionLayer,TransitionStack-method}
\alias{Math-methods}
\alias{Math,TransitionLayer-method}

\title{Arithmetic and mathematical operations with objects of class Transition}

\description{
  Standard arithmetic operators for computations with Transition* objects and numeric values. 
  Transition objects must have the same extent and resolution.
  All arithmetic and mathematical operations that work on the sparse matrices are available for Transition* objects. 
}

\value{
Transition* object or numeric.
}

\author{Jacob van Etten}

\examples{
  #create a new raster and set all its values to unity.
  raster <- raster(nrows=18, ncols=36) 
  raster <- setValues(raster,rep(1,ncell(raster)))

  #create TransitionLayer objects
  tr1 <- TransitionFromRaster(raster,mean,4)
  tr2 <- tr1

  #arithmetic operations
  tr3 <- tr1 * tr2
  tr4 <- tr3 * 4
}

\keyword{methods}
\keyword{math}
\keyword{spatial}
