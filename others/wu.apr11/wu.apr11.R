# ==========================================================================
# Tanimoto similarity
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ref <- tibble::as_tibble(data.table::fread("./NC.csv"))
sample <- tibble::as_tibble(data.table::fread("./Sample.csv"))

computeTS <- function(x, y) {
  normd <- function(x) dist(rbind(x, 0))[[1]]
  dp <- function(x, y) sum(x * y)
  xy <- dp(x, y)
  xy / (normd(x)^2 + normd(y)^2 - xy)
}

st <- function(data) {
  lst <- apply(data[, -1], 1, simplify = F,
    function(x) {
      ifelse(is.na(x), 0, x)
    })
  names(lst) <- data[[1]]
  lst
}

ref.st <- st(ref)
sample.st <- st(sample)

res <- pbapply::pblapply(sample.st,
  function(x) {
    vapply(ref.st, computeTS, numeric(1), y = x)
  })
res <- do.call(rbind, res)
res <- data.frame(res, check.names = F)
res <- dplyr::mutate(res, name = rownames(res))
res <- dplyr::relocate(res, name)
res <- tibble::as_tibble(res)

data.table::fwrite(res, "res.csv")
