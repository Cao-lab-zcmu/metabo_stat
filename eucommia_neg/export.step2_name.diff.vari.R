## add supplementation data
export.supp <- export.class.cano %>% 
  ## get name
  merge(iupac, by.x = "inchikey2D", by.y = "inchikey2d", all.x = T) %>% 
  ## get mass difference
  merge(.MCn.formula_set[, c(".id", "massErrorPrecursor(ppm)")], ) %>% 
  ## get content variation
  merge(log.fc_stat.ori[, c(".id", "log2fc")], by = ".id", all.x = T) %>% 
  dplyr::as_tibble() %>% 
  ## ------------------------------------- 
  ## format data
  dplyr::mutate(name = ifelse(name == "null",
                              ## get better name
                              ifelse(is.na(IUPACName), name, IUPACName),
                              ifelse(nchar(name) < nchar(IUPACName), name, IUPACName)),
                name = ifelse(grepl("^bmse|^ACMC", name), IUPACName, name),
                ## round rt min
                rt = round(rt, 1),
                ## variation
                log2fc = unlist(lapply(log2fc, function(num){
                                         if(abs(num) < 1)
                                           return("-")
                                         sig <- ifelse(num > 0, "↑", "↓")
                                         ch <- paste(rep(sig, floor(abs(num))), collapse = "")
                                         ## log2fc >= 5, omit as ...
                                         if(nchar(ch) >= 5)
                                           ch <- paste(c(rep(sig, 5), "..."), collapse = "")
                                         return(ch)
                                       })))
