# ==========================================================================
# draw the graphic abstract
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

library(ggplot2)

title_pals <- colorRampPalette(c('white', '#1B1919'))(10)[ 5:8 ]

# alignment
shift <- rnorm(3, 2, 1)
all_range <- list(1:30, 31:60, 61:100)
set.seed(1)
lst <- mapply(shift, 1:length(shift), SIMPLIFY = F, FUN = function(shift, id){
  peak <- mapply(all_range, SIMPLIFY = F,
    FUN = function(range){
      peak <- dnorm(range, median(range) + shift, rnorm(1, 5, 1.2)) *
        rnorm(1, 0.7, 0.15)
    })
  feature <- mapply(1:length(all_range), lengths(all_range),
    FUN = function(seq, rep){
      rep(paste0("peak", seq), rep)
    })
  tibble::tibble(x = unlist(all_range), y = unlist(peak),
    sample = paste0("sample", id),
    peak = unlist(feature)
  )
})
data <- data.table::rbindlist(lst)
data <- dplyr::mutate(data,
  is = ifelse(y >= 0.003, T, F),
  peak = ifelse(is, peak, "non-feature"))
palette <- c(ggsci::pal_npg()(length(all_range)), "transparent")
names(palette) <- c(paste0("peak", 1:length(all_range)), "non-feature")
# detection
all_time <- vapply(all_range, median, 1)
anpi <- 0.05
len <- 5
set.seed(1)
ms1_set <- lapply(all_time,
  function(n){
    ms1 <- c(rnorm(3, 3, 2), rnorm(3, 8, 3), rnorm(3, 3, 2))
    ms1 <- ms1[ ms1 > 0 ]
    ms1 <- data.frame(x = 1:length(ms1), xend = 1:length(ms1),
      y = 0, yend = ms1)
    ms1 <- dplyr::mutate(ms1,
      x = x * len, xend = xend * len,
      y = sinpi(anpi) * x + y, yend = sinpi(anpi) * xend + yend,
      x = cospi(anpi) * x + n, xend = x)
    ms1 <- dplyr::bind_rows(ms1,
      c(x = n, xend = max(ms1$xend),
        y = 0, yend = max(ms1$y)))
    dplyr::mutate(ms1, time = n)
  })
ms1_set <- data.table::rbindlist(ms1_set)
p <- ggplot(dplyr::filter(data, sample == "sample1"), aes(x = x, y = y * 50)) +
  geom_segment(data = ms1_set,
    aes(x = x, xend = xend, y = y, yend = yend),
    color = "grey30", size = 0.8) +
  geom_area(aes(fill = peak)) +
  geom_line() +
  labs(x = "retention time", y = "intensity") +
  scale_fill_manual(values = palette) +
  theme_void() +
  theme(text = element_text(family = "Times"),
    axis.text.y = element_blank(),
    legend.position = "none"
  )
grob.detect <- as_grob(p)
g.detect <- into(grectn(bgp_args = list(lty = "solid")), grob.detect)
## gear
data <- data.frame(x = 1:20, y = rep(c(0, 1), 10))
p.step <- ggplot(dplyr::slice(data, 1:19)) +
  geom_step(aes(x = x, y = y), size = .2) +
  coord_polar() +
  ylim(c(-8, 1)) +
  theme_void() +
  theme(plot.margin = rep(u(-.1, npc), 4))
gear <- as_grob(p.step)
g.gear <- ggather(gear,
  circleGrob(r = c(.2, .4)),
  circleGrob(r = .3, gp = gpar(lwd = 5, col = 'grey70')), 
  vp = viewport(gp = gpar(alpha = .2)))
MCnebula2:::.smiles_to_cairosvg(
  'C1=C(C=C(C(=C1I)OC2=CC(=C(C(=C2)I)O)I)I)CC(C(=O)O)N',
  'chemEg.svg')
struc <- .rm_background(.cairosvg_to_grob('chemEg.svg'))
struc <- ggather(struc, vp = viewport(, .5, 1.8, 1.8))
mglayer <- function(from = 1:5, n = 5, seed = 100) {
  set.seed(seed)
  ns <- sample(from, n, T)
  grobs <- lapply(ns,
    function(n) {
      ggather(glayer(n), vp = viewport(, , .7, .7))
    })
  sig <- paste0(paste0("glayer", seed), 1:n)
  names(grobs) <- sig
  frame_col(fill_list(sig, 1), grobs)
}
g.predict <- ggather(struc, g.gear)
g.predict <- frame_row(c(g.predict = 4, glayers = 1),
  namel(g.predict, glayers = mglayer(1:4, 4)))
g.before <- frame_row(c(g.detect = 1.5, g.predict = 1),
  namel(g.detect, g.predict))
g.step0 <- grecti2('Detection and prediction', tfill = title_pals[1])
g.step0 <- into(g.step0, ggather(g.before, vp = viewport(, , .95, .8)))

## step2
## rank bar
set.seed(100)
data <- data.frame(x = 1:(n <- 12), y = sort(abs(rnorm(n, 5, 5))))
p.rank <- ggplot(data) +
  geom_col(aes(x = x, y = y), fill = ifelse(data$y > 5, '#D5E4A2', '#FD7446')) +
  geom_hline(yintercept = 5, linetype = "dashed", color = "red") +
  coord_flip() +
  theme_void()
g.rank <- as_grob(p.rank)
## bar
p.bar <- ggplot(data.frame(x = 1, y = c(0.1, 0.9), group = c("false", "true"))) +
  geom_col(aes(x = x, y = y, fill = reorder(group, desc(y))), width = 0.5) +
  annotate("segment", x = 1.7, xend = 1.7, y = 0.12, yend = 0.98,
    arrow = arrow(angle = 10, type = "closed", length = unit(0.05, "npc"))) +
  annotate("segment", x = 1.6, xend = 1.8, y = 0.1, yend = 0.1) +
  scale_fill_manual(values = c('#91D1C2FF', '#DC0000FF')) +
  xlim(c(.5, 2)) +
  theme_void() +
  theme(legend.position = 'none')
p.bar <- as_grob(p.bar)
p.bar <- ggather(p.bar, vp = viewport(, , .95, .9))
## box
simu_score <- dplyr::mutate(
  data.frame(.features_id = 1:50, score = rnorm(50, 0.4, 0.15)),
  group = ifelse(score >= 0.3, "true", "false")
)
p.box <- ggplot(simu_score, aes(x = "", y = score)) +
  geom_boxplot() +
  geom_hline(yintercept = 0.3, linetype = "dashed", color = "red") +
  geom_jitter(width = 0.1, aes(color = group)) +
  theme_void() +
  theme(legend.position = "none")
p.box <- as_grob(p.box)
## upset
p.upbar <- ggplot(data.frame(x = 1, y = 5)) +
  geom_col(aes(x = x, y = y), width = .5) +
  ylim(0, 7) +
  scale_x_continuous(breaks = c(0, 1, 2), limits = c(.5, 1.5)) +
  theme(text = element_blank(),
    axis.ticks.y = element_blank()) +
  geom_blank()
p.upbar <- as_grob(p.upbar)
cirs <- circleGrob(y = (cirs.y <- seq(.1, .9, length.out = 5))[2:4], r = .08,
  gp = gpar(col = 'transparent', fill = 'grey90'))
cirs.sol <- circleGrob(y = cirs.y[c(1, 5)], r = .08,
  gp = gpar(col = 'transparent', fill = 'black'))
line <- linesGrob(x = c(.5, .5), y = c(.1, .9), gp = gpar(lwd = 3))
p.upcir <- ggather(cirs, line, cirs.sol)
g.upset <- frame_row(c(p.upbar = 2, p.upcir = 1),
  namel(p.upbar = ggather(p.upbar, vp = viewport(.48)), p.upcir))
g.upset <- ggather(g.upset, vp = viewport(, , .90, .90))
## gather
g.step1.1t3 <- mapply(list(p.bar, p.box, g.upset), n = 1:3, SIMPLIFY = F,
  FUN = function(g, n) {
    into(grecti2(n, tfill = '#CC0C00'), g)
  })
names(g.step1.1t3) <- n(g, 3)
g.step1.1t3 <- frame_col(c(g1 = 1, null = .1, g2 = 1, null = .1, g3 = 1),
  c(g.step1.1t3, list(null = nullGrob())))
g.step1.0t3 <- frame_col(c(g.rank = .5, null = .1, g.step1.1t3 = 3),
  namel(g.rank, g.step1.1t3, null = nullGrob()))
g.step1.0t3 <- into(
  grecti2('Select classes', tfill = title_pals[2]), 
  ggather(g.step1.0t3, vp = viewport(, , .95, .8))
)

## step2
# network
load(paste0(.expath, "/toActiv30.rdata"))
test1 <- toActiv30
set.seed(17)
reference(mcn_dataset(test1))$nebula_index %<>%
  dplyr::filter(class.name %in% sample(unique(class.name), 2))
test1 <- set_tracer(test1, c("2027", "2020"), colors = c("#C80813", "#FD7446"))
test1 <- create_child_nebulae(test1, 0.01, 5)
test1 <- create_child_layouts(test1)
test1 <- activate_nebulae(test1)
test1 <- set_nodes_color(test1, use_tracer = T)
chAsGrob <- function(ch, x) {
  ggset <- modify_default_child(ch)
  ggset@layers$ggtitle@command_args$label %<>%
    gsub("[a-zA-Z]", ".", .) %>% 
    gsub("^....", "Class", .) %>% 
    gsub("\\.\\.", ".", .)
  as_grob(call_command(ggset))
}
sets <- lapply(ggset(child_nebulae(test1)), chAsGrob, x = test1)
sets <- lapply(names(sets),
  function(name) {
    ggather(sets[[name]],
      vp = viewports(child_nebulae(test1))[[name]])
  })
sets_vp <- viewport(layout = grid_layout(child_nebulae(test1)))
sets <- do.call(ggather, c(sets, list(vp = sets_vp)))

set.seed(120)
data <- data.frame(x = 1:12, y = sort(abs(rnorm(12, 5, 5))))
p.fRank <- ggplot(data) +
  geom_col(aes(x = x, y = y, fill = y)) +
  scale_fill_gradientn(colors = c('grey90', 'grey90', 'red')) +
  coord_flip() +
  theme_void() +
  theme(axis.ticks = element_blank(),
    legend.position = 'none') +
  geom_blank()
g.fRank <- as_grob(p.fRank)

omit <- ggplot() +
  ggtitle("...") +
  theme_void() +
  theme(legend.position = 'none',
    plot.title = MCnebula2:::.element_textbox(
      fill = MCnebula2:::.get_label_color()[sample(2:6, 1)])) +
  geom_blank()
omit <- ggather(as_grob(omit), vp = viewport(, , .9))
g.sets <- frame_row(c(sets = 4, omit = .5, omit = .5), namel(sets, omit))
g.step2 <- frame_col(
  c(g.fRank = 1, g.sets = 5, null = .2),
  namel(g.fRank, g.sets, null = nullGrob())
)
g.step2 <- into(grecti2('Tracing top features', tfill = title_pals[3]),
  ggather(g.step2, vp = viewport(, , .95, .95)))

g.ab <- frame_col(c(g.step0 = 1, null = .02, g.step1.0t3 = 2, null = .02, g.step2 = 1),
  namel(g.step0, g.step1.0t3, g.step2, null = nullGrob()))

pdf('tocg.pdf', 9, 4)
draw(g.ab)
dev.off()
# dev.new(height = 4, width = 9)
