\name{Transition* classes}
\docType{class}
\alias{TransitionLayer-class}
\alias{TransitionStack-class}
\alias{coerce,TransitionLayer,sparseMatrix-method}
\alias{coerce,TransitionLayer,RasterLayer-method}
\alias{coerce,TransitionLayer,TransitionStack-method}
\alias{coerce,TransitionData,TransitionLayer-method}
\alias{coerce,RasterLayer,TransitionLayer-method}

\alias{initialize,TransitionLayer-method}
\alias{initialize,TransitionStack-method}

\alias{show,TransitionLayer-method}

\alias{==,TransitionLayer,TransitionLayer-method}

\title{Transition* classes}
\description{


An object of the class TransitionLayer contains two main elements:
1. a transition matrix with transition values between connected cells in a raster - an object of class sparseMatrix (package Matrix); 
2. information on the extent, resolution and projection of the underlying raster - an object of class Raster (package raster).

All slots belong to these two elements from other package, except two additional slots:
1. slot transitionCells, which contains the cell numbers of the cells included in the transition matrix;
2. slot matrixValues indicates if the nonzero values of the transition matrix contains conductance or resistance values.
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
showClass("TransitionLayer")

tr <- new("TransitionLayer",nrows=36,ncols=18,xmin=-180,xmax=180,
          ymin=-90,ymax=90,projection=CRS("+proj=longlat +datum=WGS84"))

tr <- new("TransitionLayer",nrows=36,ncols=18,xmin=-180,xmax=180,
          ymin=-90,ymax=90,projection="")
}
\keyword{classes}
