
devtools::load_all("~/utils.tool")
setwd("/media/echo/7A35-E5E6/")

fun <- function(file, n) {
  name <- gsub("\\..*$", "", get_filename(file))
  data <- openxlsx::read.xlsx(file, sheet = n)
  colnames(data) <- paste0(name, "_", colnames(data))
  tibble::as_tibble(data)
}

data1 <- fun("./database.xlsx", 2)
data2 <- fun("./test.xlsx", 1)

data <- tol_merge(data1, data2, "database_m/z", "test_M/Z", tol = .01)
data <- tibble::as_tibble(data)

openxlsx::write.xlsx(data, "merge.xlsx")
