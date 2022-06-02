## batch draw
p.rect <- ggplot() +
  geom_label(aes(x = 1, y = 1,
                 label = paste0(rep(" ", 6), collapse = "")),
             fill = "#F5F5F5",
             size = 80,
             label.size = 0.3,
             label.r = unit(0.1, "npc"),
             label.padding = unit(0.1, "npc")) +
  theme_void()
## ------------------------------------- 
draw.p <- function(df, var = T){
  df <- dplyr::mutate(df, value = ifelse(rep(var, nrow(df)),
                                         round(as.numeric(value), 1), value))
  p <- ggplot(df) +
    geom_tile(aes(x = group, y = "value",
                  fill = value),
              color = "white", height = 1, width = 1, size = 1) +
    geom_text(aes(x = group, y = "value",
                  label = value),
              size = 20,
              family = "Times") +
    eval(parse(text = ifelse(var,
                             'scale_fill_gradient2(low = "#3182BDFF", high = "#A73030FF", limits = c(min(heat.norm.df.l$value), max(heat.norm.df.l$value)))',
                             'scale_fill_manual(values = rep("#C6DBEF", 4))'
                             ))) +
    theme_void() +
    theme(legend.position = "none")
  return(p)
}
## ------------------------------------- 
ba.stat.p <- ba.stat
dir.create("ba.element")
apply(ba.stat.p, 1,
      function(vec){
        file <- paste0("ba.element/", vec[["abb"]])
        svg(file, bg = "transparent")
        grid::grid.draw(p.rect)
        ps <- grid::textGrob(paste0(vec[["abb"]]),
                             y = 0.65,
                             gp = grid::gpar(fontfamily = "Times",
                                             fontface = "bold",
                                             fontsize = 100,
                                             col = "black"))
        grid::grid.draw(ps)
        ## ------------------------------------- 
        df <- dplyr::bind_rows(vec) %>% 
          dplyr::select(all_of(c("abb", "NN", "HN", "HS", "HM"))) %>% 
          reshape2::melt(id.vars = "abb", variable.name = "group", value.name = "value")
        p <- draw.p(df)
        vp <- fast.view(
                        ## x, y
                        0.5, 0.4,
                        ## width, height
                        0.9, 0.25, c("center", "center"))
        print(p, vp = vp)
        dev.off()
        rsvg::rsvg_png(file, paste0(file, ".png"), height = 2000)
      })
## ---------------------------------------------------------------------- 
## legend
svg(paste0("ba.element/", "legend.svg"), bg = "transparent")
vec <- c(abb = "Group",
         NN = "NN",
         HN = "HN",
         HS = "HS",
         HM = "HM")
grid::grid.draw(p.rect)
ps <- grid::textGrob(paste0(vec[["abb"]]),
                     y = 0.65,
                     gp = grid::gpar(fontfamily = "Times",
                                     fontface = "bold",
                                     fontsize = 100,
                                     col = "black"))
grid::grid.draw(ps)
## ------------------------------------- 
df <- dplyr::bind_rows(vec) %>% 
  dplyr::select(all_of(c("abb", "NN", "HN", "HS", "HM"))) %>% 
  reshape2::melt(id.vars = "abb", variable.name = "group", value.name = "value")
p <- draw.p(df, var = F)
vp <- fast.view(
                ## x, y
                0.5, 0.4,
                ## width, height
                0.9, 0.25, c("center", "center"))
print(p, vp = vp)
dev.off()

