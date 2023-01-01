# ==========================================================================
# MCnebula2 used
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setwd("~/MCnebula2/")

path <- "~/outline/mc.test/templates/"
names <- eval(.workflow_name)
objs <-
  sapply(names(names), simplify = F,
    function(name) {
      file <- paste0(path, name, ".R")
      if (file.exists(file))
        readLines(file)
    })
.workflow_templ <- objs[!vapply(objs, is.null, logical(1))]

usethis::use_data(.workflow_templ, internal = TRUE, overwrite = T)
