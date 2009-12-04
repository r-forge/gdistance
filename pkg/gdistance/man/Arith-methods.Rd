\name{Arith-methods}

\docType{methods}

\alias{Arith-methods}
\alias{Arith,ANY,Transition-method}
\alias{Arith,Transition,ANY-method}
\alias{Arith,Transition,Transition-method}

\title{Arithmic with objects of class Transition}

\description{
  Standard arithmic operators for computations with Transition objects and numeric values. 
  Transition objects must have the same extent and resolution.
  All operations that work on the sparse (dsC) matrices are available. 
}

\value{
A Transition object.
}

\author{Jacob van Etten}

\examples{
  #create a new raster and set all its values to unity.
  raster <- raster(nrows=18, ncols=36) 
  raster <- setValues(raster,rep(1,ncell(raster)))

  #create Transition objects
  tr1 <- TransitionFromRaster(raster,mean,4)
  tr2 <- tr1

  #arithmetic operations
  tr3 <- tr1 * tr2
  tr4 <- tr3 * 4
}

\keyword{methods}
\keyword{math}
\keyword{spatial}
