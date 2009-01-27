\name{flowMap}
\alias{ flowMap }
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
flowMap (transition, originCoord, goalCoord)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{transition}{ ~~Describe \code{transition} here~~ }
  \item{originCoord}{ ~~Describe \code{origin.xy} here~~ }
  \item{goalCoord}{ ~~Describe \code{goal.xy} here~~ }
}
\details{
  ~~ If necessary, more details than the description above ~~
}
\value{
  ~Describe the value returned
  If it is a LIST, use
  \item{comp1 }{Description of 'comp1'}
  \item{comp2 }{Description of 'comp2'}
  ...
}
\references{ ~put references to the literature/web site here ~ }
\author{ ~~who you are~~ }
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function(transition,origin.xy,goal.xy)
{
origin.cell <- raster.get.cell.from.xy(transition, origin.xy)
goal.cell <- raster.get.cell.from.xy(transition, goal.xy)
L <- Laplacian(transition)
Lr <- L[1:L@Dim[1]-1,1:L@Dim[2]-1]
A <- as(L,"lMatrix")
A <- as(A,"dMatrix")
n <- max(Lr@Dim)
e <- matrix(0, ncol=1, nrow=n)
rownames(e) <- rownames(transition)[1:n]
e[as.character(origin.cell),] <- 1 
e[as.character(goal.cell),] <- -1
x <- solve(Lr,e) 
x <- as.vector(x)
Lplusallrows <- c(x-sum(x/(n+1)),(sum(x)/(n+1)))
V <- A * Lplusallrows
d <- t(t(A) * diag(V))
V <- - V + d
Current <- colSums(abs(V)*-L)/2
names(Current) <- rownames(transition)
return(Current)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
