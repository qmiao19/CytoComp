#' @export
GetSpillMat <- function(data = NULL, cols, n, file = NULL, threshold = 0.1) {
  if (is.null(data)){
    data <- flowCore::exprs(flowCore::read.FCS(file, transformation = FALSE, truncate_max_range = FALSE))
  }
  cutoffs <- .DeriveCutoffs(data, cols, n)
  model <- .EstimateSpill(data, cutoffs, cols, upperbound = threshold)
  estimates <- model[[1]]
  xcols <- model[[2]]
  spillmat <- diag(length(xcols))
  for (i in 1:length(xcols)) {
    if (!is.na(xcols[[i]])) {
      for (j in 1:length(xcols[[i]])) {
        spillmat[xcols[[i]][j],i] <- ifelse(estimates[[i]][j] < threshold, estimates[[i]][j], threshold)
      }
    }
  }
  return(spillmat)
}
