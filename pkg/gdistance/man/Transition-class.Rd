\name{Transition class}
\docType{class}
\alias{Transition-class}
\alias{Arith,Transition,transition-method}
\alias{coerce,Transition,dsCMatrix-method}
\alias{initialize,Transition-method}
\alias{show,Transition-method}

\title{Class "Transition" }
\description{


An object of the class Transition contains two main elements:
1. a transition matrix with transition values between connected cells in a raster - an object of class sparseMatrix (package Matrix); 
2. information on the extent, resolution and projection of the underlying raster - an object of class Raster (package raster).

Slot transitionCells contains cell numbers of cells included in the transition matrix. 
Slot matrixValues indicates if the nonzero values of the transition matrix contains conductance or resistance values.
}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("Transition", nrows, ncols, xmin, xmax, ymin, ymax, projection)}.
}
\section{Slots}{
	\describe{
    \item{\code{transitionMatrix}:}{Object of class \code{"sparseMatrix"}}
    \item{\code{transitionCells}:}{Object of class \code{"integer"}}
    \item{\code{matrixValues}:}{Object of class \code{"character"}}
    \item{\code{ncols}:}{Object of class \code{"integer"}}
    \item{\code{nrows}:}{Object of class \code{"integer"}}
    \item{\code{crs}:}{Object of class \code{"CRS"} (sp package)}	
    \item{\code{extent}:}{Object of class \code{"Extent"}}
	\item{\code{layernames}:}{Object of class \code{"vector"}}
  }
}
\section{Extends}{
Class \code{"\linkS4class{Raster}"}.
}
%\section{Methods}{
%  \describe{
%    \item{Arith}{\code{signature(e1 = "Transition", e2 = "Transition")} }
%    \item{coerce}{\code{signature(from = "Transition", to = "sparseMatrix")}}
%    \item{initialize}{\code{signature(.Object = "Transition")}}
%    \item{Math}{\code{signature(x = "Transition")} }
%    \item{show}{\code{signature(object = "Transition")} }
%	 }
%}

\author{ Jacob van Etten <jacobvanetten@yahoo.com> }
\examples{
showClass("Transition")

tr <- new("Transition",nrows=36,ncols=18,xmin=-180,xmax=180,ymin=-90,ymax=90,projection=CRS("+proj=longlat +datum=WGS84"))

tr <- new("Transition",nrows=36,ncols=18,xmin=-180,xmax=180,ymin=-90,ymax=90,projection="")
}
\keyword{classes}
