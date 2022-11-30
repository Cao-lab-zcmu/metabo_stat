# ==========================================================================
# sub.frame
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
load(paste0(.expath, "/toBinary5.rdata"))
weight.mcn <- weight(mcn_dataset(toBinary5), slotNames(mcn_dataset(toBinary5)))
weight.mcn <- 
  sapply(c("dataset", "reference", "backtrack"), simplify = F,
         function(x) weight.mcn[[x]])

grobs.mcn <- lst_grecti(names(weight.mcn), pal, "sub.slot")

# ==========================================================================
# content
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
## dataset
## features
mshn <- 5
mshvp <- viewport(, , .7, .7)
fea <- circleGrob(gp = gpar(fill = "grey85"))
fea <- ggather(fea, vp = mshvp)
grob_feas <- frame_col(fill_list(n(fea, mshn), 1), fill_list(n(fea, mshn), list(fea)))
## function to draw
mglayer <- function(from = 1:5, n = 5, seed = 100) {
  set.seed(seed)
  ns <- sample(from, n, T)
  grobs <- lapply(ns, function(n) {
                    ggather(glayer(n), vp = mshvp)
         })
  sig <- paste0(paste0("glayer", seed), 1:5)
  names(grobs) <- sig
  frame_col(fill_list(sig, 1), grobs)
}
## set
grob_fset <- mglayer(, , 100)
grob_sset <- mglayer(2:7, , 110)
grob_cset <- mglayer(5:10, , 120)
## titles
tit_fea <- gltext("features")
tit_cand <- gltext("candidates", flip = T)
tit_formu <- gtext("molecular formula", gpar(fontface = "plain"))
tit_struc <- gtext("chemical structure", gpar(fontface = "plain"))
tit_class <- gtext("chemical classes", gpar(fontface = "plain"))
## combine
names <- c("grob_feas", "tit_formu", "grob_fset",
           "tit_struc", "grob_sset", "tit_class", "grob_cset")
env <- environment()
mdataset <- frame_row(fill_list(names, 1), sapply(names, get, envir = env))
mdataset <- frame_col(list(tit_cand = .1, mdataset = 1),
                      list(tit_cand = tit_cand, mdataset = mdataset))
mdataset <- frame_row(list(tit_fea = .1, mdataset = 1),
                      list(tit_fea = tit_fea, mdataset = mdataset))
.grob.dataset <- ggather(mdataset, vp = viewport(, , .9, .9))
## into
grobs.mcn$dataset %<>% into(.grob.dataset)

## reference
ref <- names(reference(mcn_dataset(toBinary5)))
## spe.table
df <- data.frame(.fea_id = n(id., 3), .cand_id = n(cand., 3))
grob_table <- gridExtra::tableGrob(df, theme = gridExtra::ttheme_default(8))
grobs_ref <- sapply(ref, simplify = F,
                    function(name) {
                      if (name == "nebula_index")
                        res <- into(gshiny(xn = 6), gtext(name))
                      else if (name == "specific_candidate") {
                        res <- frame_row(list(tit = .2, df = 1),
                                         list(tit = gtext(name, y = .2), df = grob_table))
                        res <- into(grectn("transparent"), res)
                      } else
                        res <- into(grectn("transparent"), gtext(name))
                      ggather(res, vp = viewport(, , .9))
                    })
weight.ref <- vapply(ref, FUN.VALUE = numeric(1),
                     function(name) {
                       if (name == "nebula_index") .5
                       else if (name == "specific_candidate") 1.3
                       else .5
                     })
grobs_ref <- frame_row(weight.ref, grobs_ref)
grobs.ref <- ggather(grobs_ref, vp = viewport(, , .9, .9))
## into
grobs.mcn$reference %<>% into(grobs.ref)

## backtrack
grob.trash <- ex_grob("trash")
grob_trash <- ggather(grob.trash, vp = viewport(, , .8, .8))
grobs.mcn$backtrack %<>% into(grob_trash)

# ==========================================================================
# gather
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.size_subslot <- u(1, npc) - u(.5, line)
frame.mcn <- frame_row(weight.mcn, grobs.mcn)
frame.mcn <- ggather(frame.mcn, vp = viewport(, , .size_subslot, .size_subslot))
.mcn <- grecti(form("mcn_dataset"), tfill = pal[[ "slot" ]])
.mcn <- into(.mcn, frame.mcn)
.mcn <- ggather(.mcn, vp = .gene.vp)

## show
x11(, 7, 11)
draw(.mcn)

pdf(tmp_pdf(), 6, 11)
frame_col(list(x = .5, y = .5), list(x = .project, n = nullGrob(), y = .mcn)) %>% 
  draw()
dev.off()

op(tmp_pdf())

# ==========================================================================
# line and arrow
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
