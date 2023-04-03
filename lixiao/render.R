
devtools::load_all("~/utils.tool")
library(MCnebula2)

report <- as_report.rough(readLines("./exam.Rmd"))
write_articlePdf(report, file <- "exam_pdf.Rmd", "生信考核答卷\nauthor: 黄礼闯")

rmarkdown::render(file)


