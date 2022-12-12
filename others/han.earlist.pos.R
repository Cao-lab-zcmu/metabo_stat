initialize_mcnebula(".")
collate_structure()
## ---------------------------------------------------------------------- 
formula.tax <- "C15H12O7"
formula.sar <- "C11H14O5"
id.tax <- dplyr::filter(.MCn.formula_set, molecularFormula == formula.tax)$.id
id.sar <- dplyr::filter(.MCn.formula_set, molecularFormula == formula.sar)$.id
nodes_mark <- data.frame(
  .id = c(id.tax, id.sar, "Others"),
  mark = c(rep(c("tax", "sar"), c(length(id.tax), length(id.sar))), "Others")
)
palette <- c(Others = "#D9D9D9", tax = "#DDFF77", sar = "#CCCCFF")
## ---------------------------------------------------------------------- 
palette_stat <- c(blank = "grey",
                  raw = "lightblue", pro = "pink")
## ---------------------------------------------------------------------- 
metadata <- format_quant_table("../jun24.pos.csv", get_metadata = T,
                               meta.group = c(blank = "BLANK", raw = "^S", pro = "^J")) %>% 
  dplyr::slice(-1)
## ---------------------------------------------------------------------- 
stack_ms1(idset = c(id.tax, id.sar),
          metadata = metadata,
          quant.path = "../jun24.pos.csv",
          mzml.path = "../Thermo_raw",
          palette = palette_stat
)
stack_ms2(c(id.tax, id.sar), merge_via_int = F)
## ---------------------------------------------------------------------- 
