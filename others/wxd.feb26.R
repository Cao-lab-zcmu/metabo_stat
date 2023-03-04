
setwd("/media/echo/YZH/8/")
new_tiff <- "new_tiff"
new_jpg <- "new_jpg"

lapply(c(new_jpg, new_tiff), dir.create)

files <- list.files(".", recursive = T, full.names = T)
test <- pbapply::pblapply(files,
  function(file) {
    if (grepl(".jpg$", file)) {
      file.copy(file, new_jpg)
    }
    if (grepl(".tif$", file)) {
      file.copy(file, new_tiff)
    }
  })
