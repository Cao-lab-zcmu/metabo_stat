## R
idset <- list.files(path = ".", pattern = "_[0-9]{1,}") %>%
  stringr::str_extract("[0-9]{1,}$")
##
meta_dir <- stack_ms2(idset) %>%
  dplyr::mutate(ms.spec = gsub("spectra/[^/]{1,}$", "spectrum.ms", full.name))
## ----------------------------------------------------------------------
spec.list <- pbapply::pbapply(
  meta_dir, 1, function(vec) {
    ## read sig spectra
    sig.spec <- read_tsv(vec[["full.name"]])
    ## read raw spectra
    raw.spec <- readLines(vec[["ms.spec"]])
    ## mz
    line.mz <- grep("^>parentmass", raw.spec)
    mz <- stringr::str_extract(raw.spec[line.mz], "(?<=\\s)[0-9|\\.]{1,}[ ]{0,}$")
    mz <- round(as.numeric(mz), 4)
    ## rt
    line.rt <- grep("^>rt", raw.spec)
    rt <- stringr::str_extract(raw.spec[line.rt], "(?<=\\s)[0-9|\\.]{1,}(?=s)")
    rt <- round(as.numeric(rt) / 60, 1)
    ## ms2 db
    line.ms2 <- grep("^>ms2peaks", raw.spec)
    ms2 <- paste(raw.spec[(line.ms2 + 1):(length(raw.spec))], collapse = "\n")
    ms2 <- data.table::fread(ms2)
    ms2 <- dplyr::rename(ms2, mass = 1, int = 2)
    ms2 <- dplyr::mutate(ms2, rel.int = int / max(int) * 100)
    ## merge raw with assigned ms2
    ms2.merge <- numeric_round_merge(ms2, sig.spec, main_col = "mass", sub_col = "mz")
    ms2.merge <- dplyr::filter(ms2.merge, abs(rel.int - rel.intensity) < 1)
    ms2.merge <- dplyr::bind_rows(ms2.merge, ms2)
    ms2.merge <- dplyr::distinct(ms2.merge, mass, int, .keep_all = T)
    return(list(mz = mz, rt = rt, ms2 = ms2.merge))
  }
)
## ---------------------------------------------------------------------- 
ms2.set <- lapply(spec.list, `[[`, 3)
names(ms2.set) <- meta_dir$.id
ms2.set <- data.table::rbindlist(ms2.set, idcol = T) 
sig.ms2.set <- dplyr::filter(ms2.set, !is.na(mz))
## ------------------------------------- 
## ========== Run block ========== 
anno <- lapply(spec.list,
               function(lst){
                 data.table::data.table(precur.mz = lst[[1]], rt = lst[[2]])
               }) %>% 
  data.table::rbindlist() %>% 
  dplyr::mutate(.id = meta_dir$.id,
                anno.mz = paste("Precursor m/z:", precur.mz),
                anno.rt = paste("RT (min):", rt),
                anno = paste0(anno.mz, "\n", anno.rt),
                anno.x = 0, anno.y = 75)
anno <- merge(anno, .MCn.structure_set[, c(".id", "tanimotoSimilarity")],
              by = ".id", all.x = T) %>% 
  dplyr::mutate(ts = round(tanimotoSimilarity, 2),
                anno.ts = paste("TS:", ifelse(is.na(ts), "-", ts)),
                anno = paste0(anno, "\n", anno.ts))
## ---------------------------------------------------------------------- 
## ========== Run block ========== 
raw.color <- "black"
sig.color <- "#E6550DFF"
p <- ggplot() +
  ## raw mass2 peak
  geom_segment(data = ms2.set,
               aes(x = mass,
                   xend = mass,
                   y = 0,
                   yend = rel.int),
               color = raw.color,
               size = 0.8,
               alpha = 0.8) +
  ## sig mass2 peak
  geom_segment(data = sig.ms2.set,
               aes(x = mz,
                   xend = mz,
                   y = 0,
                   yend = -rel.intensity),
               color = sig.color,
               size = 0.8) +
  ## match in raw
  geom_point(data = sig.ms2.set,
             aes(x = mass,
                 y = rel.int),
             size = 0.8,
             color = raw.color,
             alpha = 0.8) +
  ## match in sig
  geom_point(data = sig.ms2.set,
             aes(x = mz,
                 y = -rel.intensity),
             size = 0.8,
             color = sig.color) +
  geom_text(data = anno,
            aes(x = anno.x,
                y = anno.y,
                label = anno),
            hjust = 0, fontface = "bold", family = "Times") +
  ## theme
  scale_y_continuous(limits = c(-100, 100)) +
  theme_minimal() +
  theme(text = element_text(family = "Times"),
        strip.text = element_text(size = 12),
        panel.grid = element_line(color = "grey85"),
        plot.background = element_rect(fill = "white", size = 0)
        ) +
  facet_wrap(~ paste("ID:", .id), scales = "free")
## ---------------------------------------------------------------------- 
struc.dir <- "mcnebula_results/tmp/structure"
if(!file.exists(struc.dir)){
  struc.vis <- T
}else{
  check <- sapply(paste0(struc.dir, "/", meta_dir$.id, ".svg"), file.exists)
  if(F %in% check){
    struc.vis <- T
  }else{
    struc.vis <- F
  }
}
struc.set <- dplyr::filter(.MCn.structure_set, .id %in% meta_dir$.id)
if(struc.vis){
  cat("## Draw structure via Molconvert and Openbabal\n")
  vis_via_molconvert(struc.set$smiles, struc.set$.id)
}
## ---------------------------------------------------------------------- 
## ========== Run block ========== 
filename = ifelse(file.exists("mcnebula_results"),
                  paste0("mcnebula_results", "/", "mirror.ms2.svg"), "mirror.ms2.svg")
width <- 13 * 1.5
height <- 10 * 1.5
struc.size.factor <- 0.5
struc.x <- 0.7
struc.y <- 0.3
svg(filename, width = width, height = height)
cat("[INFO] BEGIN: current.viewport:", paste0(current.viewport()), "\n")
## the main picture
print(p)
## structure mapping
df.vp <- get_facet.wrap.vp(meta_dir$.id)
apply(df.vp, 1, function(vec){
        struc.path <- paste0(struc.dir, "/", vec[["strip"]], ".svg")
        if(file.exists(struc.path)){
          ## read structure
          svg <- grImport2::readPicture(struc.path)
          ## estimate size of chem.
          lwd <- svg[[1]][[1]]@gp$lwd
          ## to according viewport
          downViewport(paste0(vec[["vp"]]))
          grImport2::grid.picture(svg, width = 0.5 / lwd * struc.size.factor,
                                  height = width, x = struc.x, y = struc.y)
          ## return to ROOT
          upViewport(2)
        }
                  })
cat("[INFO] END: current.viewport:", paste0(current.viewport()), "\n")
dev.off()
## ---------------------------------------------------------------------- 
# data <- data.table::data.table(
#   x = 1:21,
#   y = 1:21,
#   id = paste0("id", 1:21)
# )
# ps <- grImport2::readPicture("3177.mol.svg.cairo.svg")
# prefix <- c()
# ps <- grImport2::grobify(ps)
# ps <- gridExtra::arrangeGrob(ps)
# ## ---------------------------------------------------------------------- 
# ## test
# p <- ggplot(data) +
#   geom_point(aes(x = x, y = y)) +
#   geom_blank(aes(x = x, y = y, size = x)) +
#   geom_text(aes(label = id, x = 5, y = 5)) +
#   # ggimage::geom_subview(
#                         # x = 5, y = 5,
#                         # subview = ps,
#                         # width = 3, height = 3) +
#   facet_wrap(~id)
# ## ---------------------------------------------------------------------- 
# svg("test.svg")
# print(p)
# grid::grid.force()
# tt <- get_facet.wrap.vp(data$id)
# # mapply(grid.text, panel, vp = panel)
# dev.off()
# ## ------------------------------------- 
# # grid.ls(viewports = F, grobs = T, fullNames = T)

