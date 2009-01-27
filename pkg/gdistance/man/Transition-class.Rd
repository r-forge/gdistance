\name{Transition-class}
\docType{class}
\alias{Transition-class}
\alias{Arith,Transition,transition-method}
\alias{coerce,Transition,dsCMatrix-method}
\alias{initialize,Transition-method}
\alias{show,Transition-method}

\title{Class "Transition" }
\description{The class transition contains a transition matrix with transition values between connected cells in a raster. It also contains the geographic references of the underlying raster (bounding box, number of rows and columns). }
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("Transition", nrows, ncols, xmin, xmax, ymin, ymax)}.
}
\section{Slots}{
	\describe{
    \item{\code{transitionMatrix}:}{Object of class \code{"dsCMatrix"} ~~ }
    \item{\code{transitioncells}:}{Object of class \code{"integer"} ~~ }
    \item{\code{projection}:}{Object of class \code{"character"} ~~ }
    \item{\code{ncols}:}{Object of class \code{"integer"} ~~ }
    \item{\code{nrows}:}{Object of class \code{"integer"} ~~ }
    \item{\code{xmin}:}{Object of class \code{"numeric"} ~~ }
    \item{\code{xmax}:}{Object of class \code{"numeric"} ~~ }
    \item{\code{ymin}:}{Object of class \code{"numeric"} ~~ }
    \item{\code{ymax}:}{Object of class \code{"numeric"} ~~ }
    \item{\code{crs}:}{Object of class \code{"CRS"} ~~ }	
  }
}
\section{Extends}{
Class \code{"\linkS4class{Raster}"}.
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
\references{ ~put references to the literature/web site here ~ }
\author{ Jacob van Etten <jacobvanetten@yahoo.com> }
\note{ ~~further notes~~ }

 

\seealso{
	~~objects to See Also as \code{\link{~~fun~~}}, ~~~
	or \code{\linkS4class{CLASSNAME}} for links to other classes
}
\examples{
showClass("Transition")
}
\keyword{classes}
