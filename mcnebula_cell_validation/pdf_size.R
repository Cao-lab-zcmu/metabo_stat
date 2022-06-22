## resize pdf
path <- "~/operation/desk/mc_data"
savedir <- "compress"
dir.create(paste0(path, savedir))
## ------------------------------------- 
file.set <- list.files(path, pattern = "^fig_.*.pdf", full.names = T) %>% 
  file.info() %>% 
  dplyr::mutate(name = rownames(.), size = size / 1024 / 1024) %>% 
  dplyr::relocate(name) %>% 
  dplyr::as_tibble()
## ------------------------------------- 
apply(file.set, 1,
      function(vec){
        if(vec[["size"]] >= 1){
          pdftools::pdf_convert(vec[["name"]], format = "png", dpi = 200)
        }else{
          # file <- get_filename(vec[["name"]])
          # tofile <- paste0(path, "/", savedir, "/", file)
          system(paste0("cp ", vec[["name"]], " -t ", path, "/", savedir))
        }
      })
system("mv ~/operation/desk/mc_data/*.png -t ~/operation/desk/mc_data/compress")
## ------------------------------------- 
png.set <- list.files(paste0(path, "/", savedir), pattern = ".png$", full.names = T)
png.set %>% 
  pbapply::pblapply(function(file){
                    system(paste0("convert -resize 3000x3000 ", file, " ", file))
      })
## ---------------------------------------------------------------------- 
png.set %>% 
  pbapply::pblapply(function(file){
                      image <- EBImage::readImage(file)
                      pdf(gsub(".png$", ".pdf", file))
                      grid.raster(image)
                      dev.off()
      })
system(paste0("rm ", path, "/", savedir, "/*.png"))
