## 
file <- "/media/wizard/ZWY/1.xlsx"
## read xlsx
df <- readxl::read_xlsx(file)
## ------------------------------------- 
## calculate
comp.wei <- formula_adduct_mass(df$`Molecular formula`, get_formula_weight = T)
## ------------------------------------- 
deri.adduct <- "[M+C6N3H5O]+"
## reshape formula
deri.formula <- lapply(df$`Molecular formula`, formula_reshape_with_adduct,
                       adduct = deri.adduct, order = T) %>% 
  unlist(use.names = F)
## ------------------------------------- 
## deri.formula Weight
deri.comp.wei <- formula_adduct_mass(df$`D_Molecular formula`, get_formula_weight = T)
## ------------------------------------- 
df <- dplyr::mutate(df, `Molecular Weight` = comp.wei,
                    `D_Molecular formula` = deri.formula,
                    `D_Molecular Weight` = deri.comp.wei)

