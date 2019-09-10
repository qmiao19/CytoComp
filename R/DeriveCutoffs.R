.DeriveCutoffs <- function(data, cols, n){
  data_sample <- data[sample(1:nrow(data), n, replace = FALSE), ]
  data_work <- data_sample[,cols]
  cutoffs <- .DeriveCutoffsHelper(x = data_work, emt = 0.001, quantile = 0.1)
  return(cutoffs)
}

.DeriveCutoffsHelper <- function(x, emt, quantile) {
  # arguments: x: data matrix, emt: EM criterion
  # em, cutoff are the functions from package cutoff which are edited to suit the current R version
  cutoffs <- rep(NA, dim(x)[2])
  for (i in 1:dim(x)[2]) {
    a <- x[, i][which(x[, i] > 0)]
    a_asinh <- asinh(a / 5)
    if (diptest::dip.test(a_asinh)[2] > 0.05) {
      cutoff_channeli <- quantile(a_asinh, probs = quantile)
    } else {
      fit_channeli <- try(em(a_asinh, "normal", "log-normal", t = 0.001), silent=TRUE)
      if (isTRUE(class(fit_channeli) == "try-error")) {
        cutoff_channeli <- quantile(a_asinh, probs = quantile)
      } else {
        cutoff_channeli <- try(cutoff(fit_channeli, t = 0.001, nb = 10, distr = 1, type1 = 0.05, level = 0.95))
        if (isTRUE(class(cutoff_channeli) == "try-error")) {
          cutoff_channeli <- fit_channeli$param[1] + fit_channeli$param[2]
        } else{
          cutoff_channeli <- cutoff_channeli[1]
        }
      }
    }
    cutoff_channeli <- (sinh(cutoff_channeli)) * 5
    if (cutoff_channeli <= min(a)){
      cutoff_channeli <- quantile(a[which(a > 0)], probs = quantile)
    }
    cutoffs[i] <- cutoff_channeli
  }
  return(cutoffs)
}
