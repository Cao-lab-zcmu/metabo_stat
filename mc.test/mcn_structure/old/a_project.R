# ==========================================================================
# external grob
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
## external element
grob.path <- ex_grob("path")
grob.dir <- ex_grob("dir")
grob.api <- ex_grob("api")
grob.files <- ex_grob("files")
# draw(grob.table)

# ==========================================================================
# sub.frame
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
## melody: palette
type <- c("class", "slot", "sub.slot", "function", "custom")
pal <- MCnebula2:::.as_dic(palette_set(mcn_5features)[-3], type, na.rm = T)
pal[[ "report" ]] <- "black"

## weight
name.slots <- slotNames(mcn_5features)
name.project <- name.slots[grepl("^project", name.slots)]
weight.project <- weight(mcn_5features, name.project)
weight.project$project_metadata <- 3
names(weight.project) %<>% gsub("^project_", "", .)
weight.project <-
  sapply(c("dataset", "api", "metadata", "conformation", "version", "path"),
         simplify = F,
         function(x) weight.project[[ x ]])

grobs.project <- lst_grecti(names(weight.project), pal, , grecti2)

# ==========================================================================
# content
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
## project_path
grobs.project$path <- into(grobs.project$path, grob.path)

## project_metadata
grectn <- grectn(, list(width = .9, height = .9),
                 gpar(lty = "solid"), b = match.fun(roundrectGrob))
grob.menu <- frame_row(fill_list(n(f, 3), 1), fill_list(n(f, 3), list(grectn@grob)))
grob.menu <- frame_col(fill_list(n(fc, 3), 1), fill_list(n(fc, 3), list(grob.menu)))
grob.menu <- gTree(children = gList(grob.menu), vp = viewport(, , .8, .8))
grob_files <- frame_row(c(labels = .1, files = 1),
                        list(labels = gtext("\n......\n", gpar(cex = 1.2), x = .5, y = .4),
                             files = grob.menu))
.grob.meta <- frame_row(fill_list(n(x, 3), 1), fill_list(n(x, 3), list(grob.dir)))
.grob.meta <- frame_col(c(dirs = 1, table = 2), list(dirs = .grob.meta, table = grob_files))
## arrow 1
a1 <- setnullvp("x2", list(x = .8, y = .8), x = .grob.meta)
a1. <- setnullvp("files", list(x = 0, y = 1), x = .grob.meta)
a1 <- garrow(a1, a1., list(curvature = 0, gp = .gpar_dashed_line), fun_arrow = NULL)
## arrow 2
a2 <- setnullvp("x2", list(x = .8, y = .2), .grob.meta)
a2. <- setnullvp("files", list(x = 0, y = 0), .grob.meta)
a2 <- garrow(a2, a2., list(curvature = 0, gp = .gpar_dashed_line), fun_arrow = NULL)
.grob.meta <- gTree(children = gList(.grob.meta, a1, a2))
## into
grobs.project$metadata %<>% into(.grob.meta)

## project_dataset
load(paste0(.expath, "/toAnno5.rdata"))
anno <- features_annotation(toAnno5)
## formula
fml <- anno$mol.formula[5]
fml <- gtext(paste0("Molecular Formula\n", fml), gpar(fontface = "plain"))
grob.formu <- into(glayer(), fml)
# draw(grob.formu)
## structure
## get grob structure
smi <- anno$smiles[5]
grob.struc <- sym_chem(smi)
grob.struc <- ggather(into(glayer(6), grob.struc), vp = viewport(, , .7))
## classes
gp.cir <- gpar(lwd = u(3, line), lty = "dotted")
grob.gla <- gTree(children = gList(gtext("?", list(cex = 1.5, col = "red"), x = .7, y = .3),
                                   circleGrob(, , .4, gp = gp.cir)))
## Benzene
smi <- "C1=CC=CC=C1"
grob.ben <- sym_chem(smi)
## group
grob.ben_gla <- gTree(children = gList(grob.ben, grob.gla))
class.n <- 5
grob.classes <- into(glayer(class.n), grob.ben_gla)
## omit
grob.omit <- circleGrob(seq(.2, .8, , 3), .5, .07, gp = gpar(fill = "grey20"))
grob.omit <- into(glayer(class.n), grob.omit)
## groups
grob.groups <- frame_col(list(gomit = 1, gclasses = 1, gomit = 1),
                         list(gomit = grob.omit, gclasses = grob.classes))
## gather
more <- ggather(gltext("More data"), vp = viewport(, , .7))
.grob.dataset <- frame_row(list(formu = 1, null = .2, struc = 1, null = .2, class = 1,
                                null = .2, more = .3),
                          list(formu = grob.formu, struc = grob.struc, class = grob.groups,
                               null = nullGrob(), more = more))
.grob.dataset <- gTree(children = gList(.grob.dataset), vp = viewport(, , .8, .8))
## into
grobs.project$dataset %<>% into(.grob.dataset)

## project_conformation
text <- c(.id = "regex", .f2_formula = "*.tsv", .f3_fingerid = "*.tsv", 
          .f3_canopus = "*.fpt", ... = "...")
text.title <- c(.id = "id", .f2_formula = "form.", .f3_fingerid = "struc.",
                .f3_canopus = "class", ... = "...")
nodes.text <- sapply(names(text), simplify = F,
                     function(name) {
                       grectN(text.title[[ name ]], text[[ name ]], bfill = "lightblue")
                     })
## nodes
nodes.1 <- frame_col(list(Nnull = 1.5, id = 1, Nnull = 1.5),
                     list(Nnull = nullGrob(), id = nodes.text[[ ".id" ]]))
nodes.2 <- frame_col(list(formu = 1, Nnull = .5, fing = 1, Nnull = .5, cano = 1),
                     list(Nnull = nullGrob(), formu = nodes.text[[ ".f2_formula" ]],
                          fing = nodes.text[[ ".f3_fingerid" ]],
                          cano = nodes.text[[ ".f3_canopus" ]]))
nodes <- frame_row(list(nodes.1 = 1, Nnull = .7, nodes.2 = 1),
                   list(nodes.1 = nodes.1, nodes.2 = nodes.2, Nnull = nullGrob()))
## add arrow
a1 <- setnullvp("id", list(x = .4, y = 0), nodes)
a1. <- setnullvp("formu", list(x = .6, y = 1), nodes)
a1 <- garrow(a1, a1., list(inflect = T, curvature = -.1))
a2 <- setnullvp("id", list(x = .5, y = 0), nodes)
a2. <- setnullvp("fing", list(x = .5, y = 1), nodes)
a2 <- garrow(a2, a2., list(inflect = T, curvature = .1, gp = .gpar_dotted_line))
a3 <- setnullvp("id", list(x = .6, y = 0), nodes)
a3. <- setnullvp("cano", list(x = .4, y = 1), nodes)
a3 <- garrow(a3, a3., list(inflect = T, curvature = .1, gp = .gpar_dotted_line))
.grob.confo <- gTree(children = gList(nodes, a1, a2, a3), vp = viewport(, , .8, .8))
## into
grobs.project$conformation %<>% into(.grob.confo)

## project_api
df <- data.frame(ID = n(ID., 3), Form. = n(C.H.O., 3), Struc. = n("CO=CC.", 3))
grob_table <- gridExtra::tableGrob(df, theme = gridExtra::ttheme_default(8))
grob_api <- frame_row(list(pfiles = 1, plug = 1),
                      list(pfiles = grob.files, plug = grob.api))
.grob.api <- frame_col(list(extract = .2, gtable = 1),
                       list(extract = grob_api, gtable = grob_table))
a1 <- setnullvp("pfiles", list(x = .5, y = .2), .grob.api)
a1. <- setnullvp("plug", list(x = .5, y = .8), .grob.api)
a1 <- garrow(a1, a1.)
a2 <- setnullvp("plug", list(x = .9), .grob.api)
a2. <- setnullvp("gtable", list(x = .1), .grob.api)
a2 <- garrow(a2, a2., list(inflect = T))
.grob.api <- gTree(children = gList(.grob.api, a1, a2))
## into
grobs.project$api %<>% into(.grob.api) 

## project_version
.grob.version <- gtext("sirius.v4\n...", list(cex = 1.5))
## into
grobs.project$version %<>% into(.grob.version)

# ==========================================================================
# gather
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if.ex <- grepl("version|path", names(weight.project))
frame.project <- frame_row(weight.project, grobs.project, if.ex)
.gene.vp <- viewport(, , width = unit(8 * 1.5, "line"),
                     height = unit(35 * 1.5, "line"), clip = "off")
.project <- gTree(children = gList(frame.project), vp = .gene.vp)

# ==========================================================================
# line and arrow
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
pal.collate <- colorRampPalette(c("white", "lightblue"))(6)[c(-1, -2)]
a_gpar <- 
  lapply(pal.collate,
         function(col) {
           gpar(fill = col, col = col, lwd = u(2, line))
         })

a.set <- c("path", "conformation", "metadata", "api", "dataset")
baf <- function(x, y, width = u(1, line), height = u(3, line)) {
  rect <- grectn(bgp_args = gpar(lty = "solid"))@grob
  clip <- clipGrob(, , .7)
  ggather(clip, rect, vp = viewport(x, y, width, height))
}
for (i in 2:length(a.set)) {
  a1 <- setnullvp(a.set[i - 1], list(x = 1), .project)
  a1. <- setnullvp(a.set[i], list(x = 1), .project)
  assign(paste0("arr", i - 1),
         garrow(a1, a1., list(gp = a_gpar[[ i - 1 ]]), city = list(shift = u(1, line))))
  assign(paste0("baf", i - 1), baf(grobX(a1, 0), grobY(a1, 0)))
}
baf. <- baf(grobX(a1., 0), grobY(a1., 0))

## gather
.project <- ggather(.project,
                    baf1, baf2, baf3, baf4, baf.,
                    arr1, arr2, arr3, arr4)
