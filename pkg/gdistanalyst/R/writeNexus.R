writeNexus <- function(distObject, filenm = "")
{
    Diag <- attr(distObject, "Diag")
	distObject <- as.matrix(distObject)
	N <- dim(distObject)[1]
	if(!is.null(colnames(distObject)))	{taxNames <- colnames(distObject)}
	else{taxNames <- paste("taxon_", 1:N, sep="")}
	cat("#NEXUS\n", file = filenm)
    cat(paste("[R-package gdistanalyst, ", date(), "]\n\n", sep = ""),
        file = filenm, append = TRUE)
    cat("BEGIN TAXA;\n", file = filenm, append = TRUE)
    cat(paste("\tDIMENSIONS NTAX = ", N, ";\n", sep = ""),
        file = filenm, append = TRUE)
    cat("\tTAXLABELS\n", file = filenm, append = TRUE)
    cat(paste("\t\t", taxNames, sep = ""),
        sep = "\n", file = filenm, append = TRUE)
    cat("\t;\n", file = filenm, append = TRUE)
    cat("END;\n", file = filenm, append = TRUE)

	if (Diag)
	{
		cat("BEGIN DISTANCES;\n", file = filenm, append = TRUE)
		cat("FORMAT\n", file = filenm, append = TRUE)	
		cat("  TRIANGLE = LOWER\n", file = filenm, append = TRUE)		
		cat("  DIAGONAL\n", file = filenm, append = TRUE)	
		cat("  LABELS = LEFT;\n", file = filenm, append = TRUE)			
		cat("MATRIX\n", file = filenm, append = TRUE)		
		for (i in 1:N)
		{
			cat("  ", taxNames[i], distObject[i,1:i], file = filenm, append = TRUE)
			if(i == N) {cat(";", file = filenm, append = TRUE)}
			cat("\n", file = filenm, append = TRUE)
		}
		
	}
	
	if (!Diag)
	{
		cat("BEGIN DISTANCES;\n", file = filenm, append = TRUE)
		cat("FORMAT\n", file = filenm, append = TRUE)			
		cat("  TRIANGLE = LOWER\n", file = filenm, append = TRUE)				
		cat("  NO DIAGONAL\n", file = filenm, append = TRUE)		
		cat("  LABELS = LEFT;\n", file = filenm, append = TRUE)	
		cat("MATRIX\n", file = filenm, append = TRUE)
		cat("  ", taxNames[1],"\n", file = filenm, append = TRUE)
		for (i in 1:(N-1))
		{
			cat("    ", taxNames[i+1], distObject[(i+1),1:i], file = filenm, append = TRUE)
			if(i == N-1) {cat(";", file = filenm, append = TRUE)}
			cat("\n", file = filenm, append = TRUE)
		}
	}
	
    cat("END;\n", file = filenm, append = TRUE)
}