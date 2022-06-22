## R
# source("~/operation/superstat.R")
## "~/operation/shen/"
tif_set <- list.files(pattern = ".tif$", recursive = T) %>% 
  .[-(1:15)]
## ------------------------------------- 
depth <- stringr::str_extract_all(tif_set, "/") %>% 
  lengths() %>% 
  max() %>% 
  + 1
## ------------------------------------- 
df <- data.table::data.table(file = tif_set) %>% 
  tidyr::separate(col = file, sep = "/", into = paste0("dir", 1:depth), remove = F) %>% 
  dplyr::mutate(key = eval(parse(text = paste0("dir", depth -1))),
                group1 = eval(parse(text = paste0("dir", depth -2))),
                group2 = eval(parse(text = paste0("dir", depth -3))),
                key = gsub(".tif", "", key),
                key = paste0(group2, "\n", group1, "\n", key),
                target = eval(parse(text = paste0("dir", depth))),
                col = ifelse(is.na(target), 3,
                             ifelse(grepl("T00001C01Z001", target), 1, 2)))
## ------------------------------------- 
g.n <- 5
group.df <- df$key %>% 
  unique() %>% 
  MCnebula::grouping_vec2list(g.n, T)
## ---------------------------------------------------------------------- 
gp <- grid::gpar(fontfamily = "Times", fontsize = 10, col = "black")
## grid draw
test <- pbapply::pblapply(group.df[length(group.df)],
                          function(vec){
                            df <- dplyr::filter(df, key %in% vec)
                            ## define row
                            ## ------------------------------------- 
                            row.meta <- lapply(1:length(vec), c) 
                            names(row.meta) <- vec
                            df <- dplyr::mutate(df,
                                                row = sapply(key,
                                                             function(vec){
                                                               do.call(switch, args = c(vec, row.meta))
                                                             }))
                            ## ------------------------------------- 
                            file <- attr(vec, "name")
                            ## print into pdf
                            pdf(paste0(file, ".pdf"),
                                width = 512 / 497 * 4,
                                height = 1 * length(vec))
                            grid::grid.newpage()
                            ## grid layout
                            grid::pushViewport(viewport(layout = grid.layout(length(vec), 4)))
                            ## ------------------------------------- 
                            ## annotation
                            anno <- dplyr::distinct(df, key, row) %>% 
                              dplyr::mutate(col = 1)
                            apply(anno, 1,
                                  function(info){
                                    vp <- grid::viewport(layout.pos.row = as.numeric(info[["row"]]),
                                                         layout.pos.col = as.numeric(info[["col"]]))
                                    text <- grid::textGrob(info[["key"]],
                                                           gp = gp,
                                                           vp = vp)
                                    grid::grid.draw(text)
                                  })
                            ## ------------------------------------- 
                            ## image
                            apply(df, 1,
                                   function(info){
                                     tif <- readbitmap::read.bitmap(info[["file"]])
                                     vp <- grid::viewport(layout.pos.row = as.numeric(info[["row"]]),
                                                          layout.pos.col = as.numeric(info[["col"]]) + 1)
                                     ## raster
                                     grid::grid.raster(tif,
                                                       vp = vp,
                                                       width = unit(0.98, "npc"),
                                                       height = unit(0.98, "npc"))
                                   })
                            ## ------------------------------------- 
                            dev.off()
                          })
## ---------------------------------------------------------------------- 
pdf.set <- paste0("G", 1:length(group.df), ".pdf")
## merge
qpdf::pdf_combine(pdf.set, "overview.pdf")

