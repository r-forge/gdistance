\name{gdistance-package}
\alias{gdistance-package}
\alias{gdistance}
\docType{package}
\title{
gdistance: geographic distance calculations
}
\description{
The gdistance package calculates geographic distances based on graph theory and random-walk theory. These include cost distance, resistance distance, and joint-flow distance (a new distance measure).
}
\details{
\tabular{ll}{
Package: \tab gdistance\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2008-09-26\cr
License: \tab GPL-3\cr
LazyLoad: \tab yes\cr
}
Distances can be calculated following these steps. 

1. Read spatial grid data into the R environment, using the raster package. The resulting object can either be a RasterLayer or a RasterStack. All data have to be read into memory to be used by gdistance.

2. Construct from grid data an object of the class Transition. This object holds basic geographic information about the grid and a matrix with transition values for movements between grid cells. 

3. Correct the transition matrix for different distances between the cells due to diagonal movements and projection distortions.

4. Calculate distances from the Transition object. Outputs include matrices of mutual distances between spatial points or rasters with distance surfaces from one or more points.
}
\author{
Jacob van Etten \email{jacobvanetten@yahoo.com}
}
\references{
Ray, N. 2005. PATHMATRIX: a geographical information system tool to compute effective distances among samples. Molecular Ecology Notes 5, 177–180.
\url{http://cmpg.unibe.ch/software/pathmatrix/}

McRae, B.H. 2006. Isolation by resistance. Evolution 60(8), 1551-1561.
\url{http://www.circuitscape.org}
}
\keyword{package}
\keyword{spatial}
\seealso{
\code{\link[raster:raster-package]{raster}}
}
\examples{
#Create a raster (with raster package)

#Create a Transition object

#Correct for the projection distortion

#Calculate distances
}
