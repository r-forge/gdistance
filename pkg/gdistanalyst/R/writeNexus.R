writeNexus <- function(distObject, file = "")
{
    Diag <- attr(distObject, "Diag")
	distObject <- as.matrix(distObject)
	N <- dim(distObject)[1]
	if(!is.null(colnames(distObject)))	{taxNames <- colnames(distObject)}
	else{taxNames <- paste("taxon_", 1:N, sep="")}
	cat("#NEXUS\n", file = file)
    cat(paste("[R-package gdistanalyst, ", date(), "]\n\n", sep = ""),
        file = file, append = TRUE)
    cat("BEGIN TAXA;\n", file = file, append = TRUE)
    cat(paste("\tDIMENSIONS NTAX = ", N, ";\n", sep = ""),
        file = file, append = TRUE)
    cat("\tTAXLABELS\n", file = file, append = TRUE)
    cat(paste("\t\t", taxNames, sep = ""),
        sep = "\n", file = file, append = TRUE)
    cat("\t;\n", file = file, append = TRUE)
    cat("END;\n", file = file, append = TRUE)

	if (Diag)
	{
		cat("BEGIN DISTANCES;\n", file = file, append = TRUE)
		cat("FORMAT\n", file = file, append = TRUE)	
		cat("  TRIANGLE = LOWER\n", file = file, append = TRUE)		
		cat("  DIAGONAL\n", file = file, append = TRUE)	
		cat("  LABELS = LEFT;\n", file = file, append = TRUE)			
		cat("MATRIX\n", file = file, append = TRUE)		
		for (i in 1:N)
		{
			cat("  ", taxNames[i], distObject[i,1:i], file = file, append = TRUE)
			if(i == N) {cat(";", file = file, append = TRUE)}
			cat("\n", file = file, append = TRUE)
		}
		
	}
	
	if (!Diag)
	{
		cat("BEGIN DISTANCES;\n", file = file, append = TRUE)
		cat("FORMAT\n", file = file, append = TRUE)			
		cat("  TRIANGLE = LOWER\n", file = file, append = TRUE)				
		cat("  NO DIAGONAL\n", file = file, append = TRUE)		
		cat("  LABELS = LEFT;\n", file = file, append = TRUE)	
		cat("MATRIX\n", file = file, append = TRUE)
		cat("  ", taxNames[1],"\n", file = file, append = TRUE)
		for (i in 1:(N-1))
		{
			cat("    ", taxNames[i+1], distObject[(i+1),1:i], file = file, append = TRUE)
			if(i == N-1) {cat(";", file = file, append = TRUE)}
			cat("\n", file = file, append = TRUE)
		}
	}
	
    cat("END;\n", file = file, append = TRUE)
}