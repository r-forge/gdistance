\name{Transition-class}
\docType{class}
\alias{Transition-class}
\alias{Arith,Transition,transition-method}
\alias{coerce,Transition,dsCMatrix-method}
\alias{initialize,Transition-method}
\alias{show,Transition-method}

\title{Class "Transition" }
\description{An object of the class Transition contains a transition matrix with transition values between connected cells in a raster. It also contains information on the extent, resolution and projection of the underlying raster. }
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("Transition", nrows, ncols, xmin, xmax, ymin, ymax)}.
}
\section{Slots}{
	\describe{
    \item{\code{transitionMatrix}:}{Object of class \code{"dsCMatrix"}}
    \item{\code{transitionCells}:}{Object of class \code{"integer"}}
    \item{\code{matrixValues}:}{Object of class \code{"character"}}
    \item{\code{ncols}:}{Object of class \code{"integer"}}
    \item{\code{nrows}:}{Object of class \code{"integer"}}
    \item{\code{crs}:}{Object of class \code{"CRS"}}	
    \item{\code{extent}:}{Object of class \code{"Extent"}}
	\item{\code{layernames}:}{Object of class \code{"vector"}}
  }
}
\section{Extends}{
Class \code{"\linkS4class{BasicRaster}"}.
}
\section{Methods}{
  \describe{
    \item{Arith}{\code{signature(e1 = "Transition", e2 = "Transition")}: ... }
    \item{coerce}{\code{signature(from = "Transition", to = "dsCMatrix")}: ... }
    \item{initialize}{\code{signature(.Object = "Transition")}: ... }
    \item{Math}{\code{signature(x = "Transition")}: ... }
    \item{show}{\code{signature(object = "Transition")}: ... }
	 }
}

\author{ Jacob van Etten <jacobvanetten@yahoo.com> }
\examples{
showClass("Transition")
}
\keyword{classes}
