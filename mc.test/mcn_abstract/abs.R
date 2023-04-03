# ==========================================================================
# draw the graphic abstract
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

library(ggplot2)

## msms
set.seed(50)
data <- data.frame(x = sample(1:50, 10), y = rnorm(10, mean = 40, 30))
p.msms <- ggplot(data) +
  geom_segment(aes(x = x, xend = x, y = 0, yend = abs(y)), size = .7) +
  theme(text = element_blank(), 
    axis.ticks = element_blank()) +
  geom_blank()
g.msms <- into(glayer(3, .1), as_grob(p.msms))
g.msms <- frame_row(
  c(title = 1, g.msms = 5),
  namel(title = gtext("MS/MS", list(cex = 1.5)), g.msms)
)

## ms1
set.seed(100)
data <- data.frame(x = -25:25, y = dnorm(-25:25, 0, sqrt(50)))
data <- dplyr::mutate(data, fill = ifelse(abs(x) < sqrt(50) * 3, 'peak', 'zero'))
p.ms1 <- ggplot(data) +
  geom_line(aes(x = x, y = y)) +
  geom_area(aes(x = x, y = y, fill = fill)) +
  scale_fill_manual(values = c(ggsci::pal_npg()(2)[2], 'grey90')) +
  theme(text = element_blank(),
    axis.ticks = element_blank(),
    legend.position = "none") + 
  geom_blank()
g.ms1 <- into(glayer(3, .1), as_grob(p.ms1))
g.ms1 <- frame_row(
  c(title = 1, g.ms1 = 5),
  namel(title = gtext("Features", list(cex = 1.5)), g.ms1)
)

## rank bar
set.seed(100)
data <- data.frame(x = 1:7, y = sort(abs(rnorm(7, 5, 5))))
p.rank <- ggplot(data) +
  geom_col(aes(x = x, y = y, fill = y)) +
  scale_fill_gradientn(colors = c('grey90', 'orange', 'red')) +
  coord_flip() +
  theme_void() +
  theme(axis.ticks = element_blank(),
    legend.position = 'none',
    text = element_blank()) +
  geom_blank()
g.rank <- as_grob(p.rank)
g.rank <- frame_row(
  c(title = 1, g.rank = 5),
  namel(title = gtext("Ranking", list(cex = 1.5)), g.rank)
)

## identify
MCnebula2:::.smiles_to_cairosvg(
  'C1=C(C=C(C(=C1I)OC2=CC(=C(C(=C2)I)O)I)I)CC(C(=O)O)N',
  'chemEg.svg')
struc <- .cairosvg_to_grob('chemEg.svg')
data <- data.frame(x = 1:20, y = rep(c(0, 1), 10))
p.step <- ggplot(dplyr::slice(data, 1:19)) +
  geom_step(aes(x = x, y = y)) +
  coord_polar() +
  ylim(c(-8, 1)) +
  theme_void() +
  theme(plot.margin = rep(u(-.1, npc), 4))
gear <- as_grob(p.step)
g.struc <- ggather(struc, gear)
g.struc <- frame_row(
  c(title = 1, g.struc = 5),
  namel(title = gtext("Prediction", list(cex = 1.5)), g.struc)
)

## network
p.nets <- lapply(list(1:12, 13:20, 20:30),
  function(ids) {
    set.seed(1501)
    data <- random_graph(ids, layout = 'kk')
    p <- ggraph(data) +
      geom_edge_fan(color = 'grey85') +
      geom_node_point(
        aes(x = x, y = y, size = size,
          fill = ifelse(name == '11', 'target', 'non-target')),
        shape = 21, color = 'transparent') +
      scale_fill_manual(values = c('grey85', 'red')) +
      ggtitle('Class ...') +
      theme_void() +
      theme(legend.position = 'none',
        text = element_text(family = "Times"),
        plot.title = MCnebula2:::.element_textbox(
          fill = MCnebula2:::.get_label_color()[sample(4:7, 1)])) +
      geom_blank()
    p <- ggather(as_grob(p), vp = viewport(, , .9, .9))
  })
names(p.nets) <- n(net, 3)
omits <- sapply(n(omit, 3), simplify = F,
  function(n) {
    omit <- ggplot() +
      ggtitle("...") +
      theme_void() +
      theme(legend.position = 'none',
        text = element_text(family = "Times"),
        plot.title = MCnebula2:::.element_textbox(
          fill = MCnebula2:::.get_label_color()[sample(2:6, 1)])) +
      geom_blank()
    ggather(as_grob(omit), vp = viewport(, , .9))
  })
g.nets <- frame_row(
  c(net1 = 1, null = .1, net2 = 1, null = .1,
    omit1 = .2, omit2 = .2, omit3 = .2),
  c(p.nets, omits, list(null = nullGrob()))
)
g.nets <- frame_row(
  c(title = 1, g.nets = 12),
  namel(title = gtext("Tracing", list(cex = 1.5)), g.nets)
)

# ==========================================================================
# gather
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

null <- nullGrob()
spArr <- polygonGrob(
  c(0, .6, 1, .6, 0), c(0, 0, .5, 1, 1),
  gp = gpar(lwd = u(2, line), col = "grey30")
)
spArr <- ggather(spArr, vp = viewport(, , .4, .5))
frameAr <- frame_row(c(spArr = 1, null = .1, spArr = 1),
  namel(null, spArr))
frame1 <- frame_row(c(g.msms = 1, null = .1, g.ms1 = 1),
  namel(g.msms, g.ms1, null))
frame2 <- frame_row(c(g.struc = 1, null = .1, g.rank = 1),
  namel(g.struc, g.rank, null))
parrow <- frame_row(
  c(null = 1, arrow = 2, null = 4),
  namel(arrow = parrow(col = 'black'), null))
frame1a2a3 <- frame_col(
  c(frame1 = .8, frameAr = .15,
    frame2 = .6, spArr = .15, g.nets = 1, parrow = .15),
  namel(frame1, frame2, g.nets, frameAr, spArr, parrow))

pdf('tocg.pdf', 10, 6)
draw(ggather(frame1a2a3, vp = viewport(, , .95, .95)))
dev.off()
# dev.new(height = 1, width = 2)
# draw(g.nets)


