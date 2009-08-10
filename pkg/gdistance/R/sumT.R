sumT <- function(transition1, transition2)
{
	if(matrixValues(transition1) == "resistance") transition1@transitionMatrix@x <- 1 / transition1@transitionMatrix@x
	if(matrixValues(transition2) == "resistance") transition2@transitionMatrix@x <- 1 / transition2@transitionMatrix@x
	newTransition <- transition1 + transition2
	newTransition@transitionMatrix@x <- 1 / newTransition@transitionMatrix@x
	return(newTransition)
}
