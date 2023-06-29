
devtools::load_all("~/utils.tool")
library(MCnebula2)

setwd("/media/echo/WXD-LAY1007/")

data <- openxlsx::read.xlsx(file <- list.files(".", "es.*.xlsx"))
data <- tibble::as_tibble(data)
data <- dplyr::mutate(
  data, group = stringr::str_extract(sample, "^[A-Z]"),
  group = vapply(group, switch, character(1), K = "Control", M = "Model", P = "PGG")
)
data <- tidyr::gather(data, , , -sample, -group)
data <- split(data, ~ key)

# pal <- initialize_mcnebula(MCnebula2:::.melody())@palette_set
# scales::show_col(pal)
dir.create("violin")

lst <- lapply(data,
  function(data){
    name <- unique(data$key)
    p <- ggplot(data, aes(x = group, y = value, fill = group)) +
      geom_violin(trim = F, color = "transparent", width = .5) +
      geom_boxplot(width = 0.2, position = position_dodge(0.9)) +
      labs(x = "Group", y = "Value") +
      guides(fill = "none") +
      scale_fill_manual(values = ggsci::pal_npg()(9)) +
      theme(text = element_text(family = "Times", size = 20), 
        axis.title = element_text(face = "bold")) +
      geom_blank()
    ggsave(paste0("violin/", name, ".pdf"), p, height = 4)
  })


