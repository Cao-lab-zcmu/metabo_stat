## read pdf as string document
path <- "~/Documents/eucommia/"
lite.bib <- paste0(path, "eucommia.bib")
## ------------------------------------- 
## use package 'bib2df' to parse .bib file
lite.df <-  bib2df::bib2df(lite.bib)
## do filter
lite.df.file <- lite.df %>% 
  ## keep with file
  dplyr::filter(!is.na(FILE)) %>%
  ## absolute path
  dplyr::mutate(FILE = paste0(path, FILE)) %>%
  ## filter according to year
  dplyr::filter(YEAR >= 2000)
## ------------------------------------- 
## multi threashold read pdf
pdf_list <- pbapply::pblapply(lite.df.file$FILE,
                              function(pdf){
                                check <- try(text <- pdftools::pdf_ocr_text(pdf))
                                if(class(check)[1] == "try-error"){
                                  return("error")
                                }else{
                                  return(text)
                                }
                              })
## ------------------------------------- 

