.adjacency.from.transition <- function(transition)
{
	transitionMatr <- as(transition,"sparseMatrix")
	transition.dgT <- as(transitionMatr,"dgTMatrix")
	adjacency <- cbind(transition.dgT@i+1,transition.dgT@j+1)
	return(adjacency)
}