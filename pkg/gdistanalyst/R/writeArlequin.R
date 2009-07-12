writeArlequin <- function(ssr, filenm, formt)
{
	ssr <- as.matrix(ssr)
	if(length(ssr[1,]) == 3 & formt == "freq") {colnames(ssr) <- c("Ind","Marker","Fragment")}
	if(length(ssr[1,]) == 4 & formt == "ms") {colnames(ssr) <- c("Sample","Ind","Marker","Fragment")}
	if(length(ssr[1,]) > 4 | length(ssr[1,]) < 3) {stop("ssr doesn't have 3 or 4 columns")}
	if((length(ssr[1,]) == 4 & formt != "ms") | (length(ssr[1,]) == 3 & formt != "freq")) {stop("number of columns does not coincide with file format")}
	Markers <- unique(ssr[,"Marker"])
	nM <- length(Markers)
	cat("[Profile]", file = filenm)
	if(formt == "freq")
	{
		cat("\n  Title = \" SSR allele frequencies. File created with the R package gdistanalyst \"", file = filenm, append = TRUE)
		cat("\n  NbSamples = ", nM, sep="", file = filenm, append = TRUE)
		cat("\n  GenotypicData = 0", file = filenm, append = TRUE)
		cat("\n  DataType = FREQUENCY", file = filenm, append = TRUE)
		cat("\n[Data]", file = filenm, append = TRUE)
		cat("\n[[Samples]]", file = filenm, append = TRUE)
		for (i in 1:nM)
		{
			Freqs <- as.vector(table(ssr[ssr[,"Marker"] == Markers[i],"Fragment"]))
			cat("\n    SampleName = \"", Markers[i], "\"", sep="", file = filenm, append = TRUE)
			cat("\n    SampleSize = ", sum(Freqs), sep="", file = filenm, append = TRUE)
			cat("\n    SampleData = {", file = filenm, append = TRUE)
			for (j in 1:length(Freqs)) {cat("\n    ", j, "  ", Freqs[j], file = filenm, append = TRUE)}
			cat("\n    }", file = filenm, append = TRUE)
		}
	}
	if(formt == "ms")
	{
		Samples <- unique(ssr[,"Sample"])
		nS <- length(Samples)
		cat("\n  Title = \" SSR data. File created with the R package gdistanalyst \"", file = filenm, append = TRUE)
		cat("\n  NbSamples = ", nS, sep="", file = filenm, append = TRUE)
		cat("\n  GenotypicData = 1", file = filenm, append = TRUE)
		cat("\n  DataType = MICROSAT", file = filenm, append = TRUE)
		cat("\n  GameticPhase = 0", file = filenm, append = TRUE)
		cat("\n  MissingData = \"?\"", file = filenm, append = TRUE)
		cat("\n  LocusSeparator=WHITESPACE", file = filenm, append = TRUE)
		cat("\n[Data]", file = filenm, append = TRUE)
		cat("\n[[Samples]]", file = filenm, append = TRUE)
		l <- max(nchar(ssr[,"Ind"]))
		for (i in 1:nS)
		{
			Individuals <- unique(ssr[ssr[,"Sample"] == Samples[i],"Ind"])
			sampleSize <- length(Individuals)
			cat("\n    SampleName = \"", Samples[i], "\"", sep="", file = filenm, append = TRUE)
			cat("\n    SampleSize = ", sampleSize, sep="", file = filenm, append = TRUE)
			cat("\n    SampleData = {", file = filenm, append = TRUE)
			for (j in 1:sampleSize) 
			{
				ssrInd <- subset(ssr, ssr[,"Ind"] == Individuals[j])
				IndFragments1 <- rep("  ?", times=nM)
				IndFragments2 <- rep("  ?", times=nM)
				index <- na.omit(cbind(1:nM,match(Markers, ssrInd[,"Marker"])))
				IndFragments1[index[,1]] <- ssrInd[index[,2],"Fragment"]
				ssrInd <- ssrInd[-index[,2],]
				index <- na.omit(cbind(1:nM,match(Markers, ssrInd[,"Marker"])))
				IndFragments2[index[,1]] <- ssrInd[index[,2],"Fragment"]
				IndFragments1[is.na(IndFragments1)] <- "?"
				IndFragments2[is.na(IndFragments2)] <- "?"
				cat("\n    ", Individuals[j], paste(rep(" ", times=l - nchar(Individuals[i])), sep=""), "1", IndFragments1, sep=" ", file = filenm, append = TRUE)
				cat("\n    ", paste(rep(" ", times = l),sep=""), " ", IndFragments2, sep=" ", file = filenm, append = TRUE)
			}
			cat("\n    }", file = filenm, append = TRUE)
		}
	}
}