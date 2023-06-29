
library(MCnebula2)
devtools::load_all("~/utils.tool")

files <- list.files("~/MCnebula2/R", full.names = T)
files <- files[!grepl("MSnbase|xcms|\\.rda$", files)]
codes <- unlist(lapply(files, readLines))

lines <- c(
  "---",
  "---", "",
  "# 前2500行代码：", "",
  '```{r eval = F, echo = T}', codes[1:2500],
  '```', "",
  "# 后2500行代码：", "",
  '```{r eval = F, echo = T}', tail(codes, n = 2500),
  '```'
)
report <- as_report.rough(lines)
write_thesisDocx(report, "partial_mcnebula2.Rmd", "R codes of MCnebula2")

rmarkdown::render("./partial_mcnebula2.Rmd")


