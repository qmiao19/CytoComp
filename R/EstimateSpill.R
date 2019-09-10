.EstimateSpill <- function(data, cutoffs, upperbound = 0.1) {
  results <- list()
  xcols <- .GetFmla(data, spill_cols = .SpillColsData(data))
  for (i in 1:ncol(data)) {
    if (!is.na(xcols[[i]][1])) {
      A = as.matrix(data[which(data[,i] < cutoffs[i]), xcols[[i]]])
      b = data[which(data[,i] < cutoffs[i]), i]
      x0 = runif(ncol(A), min = 0, max = upperbound)
      fn = function(x) {
        vec = A%*%x-b
        norm(vec, type = "2")
      }
      result = try(nloptr::slsqp(x0, fn, lower=rep(0, length(x0)), upper = rep(upperbound, length(x0))))
      if (isTRUE(class(result) == "try-error")) {
        result <- NULL
        xcols[[i]] <- NA
      } else{
        result <- result$par
      }
      results[[i]] <- result
    } else {
      results[[i]] <- NULL
    }
  }
  return(list(results, xcols))
}

.GetFmla <- function(data, spill_cols) {
  fmlacols <- list()
  cs <- c(1:ncol(data))
  for (i in 1:ncol(data)) {
    cols <- NULL
    for (j in seq_along(spill_cols)) {
      if (i %in% spill_cols[[j]]) {
        cols <- cbind(cols, j)
      }
    }
    if(is.null(cols)) {
      fmlacols[[i]] <- NA
    } else{
      fmlacols[[i]] <- cols
    }
  }
  return(fmlacols)
}

.SpillColsData <- function(data, l = CATALYST::isotope_list) {
  # get ms and mets
  chs <- colnames(data)
  # metal mass number like 167，***
  ms <- as.numeric(regmatches(chs, gregexpr("[0-9]+", chs)))
  # metal name
  mets <- gsub("[[:digit:]]+Di", "", chs)
  # get spillover cols
  spill_cols <- vector("list", length(ms))
  for (i in seq_along(ms)) {
    p1 <- p2 <- m1 <- m2 <- ox <- iso <- NULL
    if ((ms[i] + 1)  %in% ms) p1 <- which(ms == (ms[i] + 1))
    if ((ms[i] + 2)  %in% ms) p2 <- which(ms == (ms[i] + 2))
    if ((ms[i] - 1)  %in% ms) m1 <- which(ms == (ms[i] - 1))
    if ((ms[i] - 2)  %in% ms) m2 <- which(ms == (ms[i] - 2))
    if ((ms[i] + 16) %in% ms) ox <- which(ms == (ms[i] + 16))
    iso <- l[[mets[i]]]
    iso <- which(ms %in% iso[iso != ms[i]])
    spill_cols[[i]] <- unique(c(m1, m2, p1, p2, iso, ox))
  }
  return(spill_cols)
}
