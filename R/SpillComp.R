#' @export
SpillComp <- function(file = NULL, data = NULL, cols, n, output) {
  if (is.null(data)){
    data <- flowCore::exprs(flowCore::read.FCS(file, transformation = FALSE, truncate_max_range = FALSE))
  }
  spillmat <- GetSpillMat(data, cols, n)
  data_compensated <- t(apply(data[,cols], 1, function(row) nnls::nnls(t(spillmat), row)$x))
  data_colnames <- colnames(data)
  data[,cols] <- data_compensated
  colnames(data) <- data_colnames
  flowCore::write.FCS(flowCore::flowFrame(data), filename = output)
  return(flowFrame(data))
}
