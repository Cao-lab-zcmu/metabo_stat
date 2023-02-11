
setwd("/media/echo/back/lu/")

formulae <- data.table::fread("formula_identifications.tsv")
formulae <- dplyr::mutate(
  formulae, .features_id = stringr::str_extract(id, "[0-9]{1,}$")
)
ids <- formulae$.features_id
sum <- nrow(formulae)

origin <- data.table::fread("features.pos.csv")
quant <- dplyr::select(
  origin, .features_id = 1, dplyr::contains("Peak area")
)
quant <- dplyr::filter(quant, .features_id %in% !!ids)
colnames(quant) <- gsub("\\.mzML Peak area", "", colnames(quant))
colnames(quant) <- gsub(" ", "_", colnames(quant))

cuts <- 10000 * 1:10

lst <- lapply(cuts,
  function(cut){
    dplyr::summarise_at(quant, -1, function(x) x >= cut)
  })

lst.summary <- lapply(lst,
  function(df) {
    df <- data.frame(summary(df))
    df <- dplyr::select(df, sample = Var2, freq = Freq)
    df <- dplyr::mutate(
      df, type = stringr::str_extract(freq, "^[a-zA-Z]*"),
      number = as.integer(stringr::str_extract(freq, "[0-9]{1,}"))
    )
    df <- dplyr::filter(df, type %in% c("TRUE", "FALSE"))
  })

names(lst.summary) <- paste0("cutoff_", cuts)
data <- data.table::rbindlist(lst.summary, idcol = T)
data <- dplyr::rename(data, cutoff = .id)
data <- dplyr::mutate(data, ratio = (number / !!sum) * 100)
data <- dplyr::mutate(
  data, order = apply(data, 1,
    function(vec) {
      if (vec[[ "type" ]] == "TRUE") as.double(vec[[ "ratio" ]])
      else 100 - as.double(vec[[ "ratio" ]])
    })
)

library(ggplot2)

p <- ggplot(data) +
  geom_col(aes(x = reorder(sample, order), y = ratio, fill = type)) +
  coord_flip() +
  facet_wrap(~ factor(cutoff, levels = paste0("cutoff_", cuts))) +
  labs(x = "Sample", y = "Ratio", fill = "Type") +
  scale_fill_manual(values = ggsci::pal_npg()(2)) +
  theme(text = element_text(family = "Times"))

ggsave(p, file = "formula_identified_ratio.pdf", width = 12, height = 7)
