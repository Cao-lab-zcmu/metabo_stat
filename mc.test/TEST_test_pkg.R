
setwd("~/MCnebula2")
devtools::check()
devtools::install()
devtools::test()
usethis::use_package("methods")
usethis::use_test("baseWorkflow.R")

