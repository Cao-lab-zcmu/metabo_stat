## ---------------------------------------------------------------------- 
## for tracing compounds
## set df to mark efs25 nodes
mark_df <- data.table::data.table(.id = in.re_efs25.id, mark = paste0(in.re_efs25.id))
## set mark_palette
pal <- pal_rickandmorty()(12)
mark_palette <- c(colorRampPalette(pal)(length(in.re_efs25.id)), "#709AE1FF")
names(mark_palette) <- c(paste0(in.re_efs25.id), "Others")
## visualize_child_nebulae
visualize_child_nebulae(output = getwd(), nodes_mark = mark_df, palette = mark_palette,
                        remove_legend_lab = T,
                        legend_fill = T,
                        legend_position = "bottom",
                        width = 15, height = 20)
## ---------------------------------------------------------------------- 
## for nebula legend
in.df <- dplyr::filter(sirius_efs25, .id %in% names(mark_palette)) %>% 
  dplyr::select(.id, origin_id) %>% 
  by_group_as_list(col = ".id") %>% 
  ## merge origin_id
  lapply(function(df){paste(df$origin_id, collapse = " & ")}) %>% 
  unlist() %>% 
  ## sort for mark_palette
  .[order(factor(names(.), levels = names(mark_palette)))] %>% 
  data.table::data.table(.id = names(.), origin_id = unname(.)) %>% 
  dplyr::mutate(anno = paste0(.id, " (origin: ", origin_id, ")"))
## ---------------------------------------------------------------------- 
## draw palette as annotation
re_mark_palette <- mark_palette
names(re_mark_palette) <- c(in.df$anno, "Others")
show_palette(re_mark_palette, font_size = 15, width = 3)
## -------------------------------------
## merge main network with legend of palette
main <- read_svg("child_nebulae.svg")
legend <- read_svg("tmp.svg")
grid_draw_svg.legend(main, legend, savename = "legend_child_nebulae.svg",
                     legend_size = 0.6)

