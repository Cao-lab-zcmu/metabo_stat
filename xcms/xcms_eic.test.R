## extract EIC
## test file in:
mzml.path <- "/media/echo/back/xcms_test"
## ------------------------------------- 
metadata <- format_quant_table(
  "earlist.neg.csv", get_metadata = T,
  meta.group = c(blank = "BLANK", raw = "^S", pro = "^J")
) %>% 
  dplyr::slice(-1) %>% 
  dplyr::mutate(file = paste0(sample, ".mzML")) %>% 
  dplyr::arrange(sample) %>% 
  dplyr::mutate(fileIdx = 1:nrow(.))
## ------------------------------------- 
feature <- data.table::fread("earlist.neg.csv") %>% 
  dplyr::select(1, 2, 3, contains("Peak RT")) %>% 
  dplyr::select(-contains("BLANK")) %>% 
  dplyr::rename(.id = 1, mz = 2, rt = 3) %>% 
  dplyr::mutate(.id = as.character(.id))
## ---------------------------------------------------------------------- 
bioc.par <- function(){
  gc()
  BiocParallel::register(
    BiocParallel::bpstart(
      BiocParallel::MulticoreParam(4)
    )
  )
}
## ---------------------------------------------------------------------- 
data <- MSnbase::readMSData(metadata$file,
                            pdata = new("NAnnotatedDataFrame", metadata),
                            mode = "onDisk")
## ---------------------------------------------------------------------- 
set.seed(100)
feature.rt.during <- feature %>% 
  dplyr::slice(sample(1:nrow(.), 8)) %>% 
  ## as long data.frame
  reshape2::melt(id.vars = c(".id", "mz", "rt"),
                 variable.name = "type", value.name = "time") %>% 
  dplyr::mutate(time = ifelse(time == 0, NA, time),
                ## RT start or RT end
                sub.type = stringr::str_extract(type, "(?<=RT ).*?$"),
                sample = gsub("\\.mz.{-}ML Peak RT.*$", "", type)) 
## ---------------------------------------------------------------------- 
target.feature <- feature.rt.during %>% 
  data.table::data.table() %>% 
  ## aggregate according to sub.type
  .[, list(sub.type.min = min(time, na.rm = T),
           sub.type.max = max(time, na.rm = T)),
                       by = list(.id, mz, rt, sub.type)] %>% 
  ## specify time
  dplyr::mutate(time = ifelse(sub.type == "start", sub.type.min, sub.type.max)) %>% 
  ## remove useless
  dplyr::select(-contains("sub.type.")) %>% 
  ## as wide data.frame
  data.table::dcast(.id + mz + rt ~ sub.type, value.var = "time") 
## ---------------------------------------------------------------------- 
bioc.par()
## ---------------------------------------------------------------------- 
mz.tol <- 0.01
rt.tol <- 0.1
rt.tol.sec <- rt.tol * 60
eic.list <- 
  pbapply::pbapply(target.feature, 1,
                   function(vec){
                     ## mz range for EIC
                     mz <- as.numeric(vec[["mz"]])
                     mz.range <- c(mz - mz.tol, mz + mz.tol)
                     ## rt range for EIC
                     rt.range <- c(vec[["start"]], vec[["end"]])
                     rt.range <- as.numeric(rt.range) * 60
                     rt.range <- c(rt.range[1] - rt.tol.sec, rt.range[2] + rt.tol.sec)
                     ## extract EIC
                     df <- MSnbase::chromatogram(data, msLevel = 1L, mz = mz.range,
                                                 rt = rt.range, aggregationFun = "max")
                     ## extract rtime and intensity
                     data.list <- lapply(unlist(df),
                                         function(chr){
                                           int <- MSnbase::intensity(chr)
                                           rt <- MSnbase::rtime(chr)
                                           data.table(real.time = rt, int = int)
                                         })
                     names(data.list) <- metadata$sample
                     ## format
                     df <- data.table::rbindlist(data.list, idcol = T)
                     df <- dplyr::rename(df, sample = .id)
                     df <- dplyr::mutate(df, .id = vec[[".id"]])
                     return(df)
                   })
## ---------------------------------------------------------------------- 
eic.df <- data.table::rbindlist(eic.list) %>% 
  merge(feature.rt.during, by = c(".id", "sample"), allow.cartesian = T) %>% 
  dplyr::select(-type) %>% 
  tidyr::spread(key = sub.type, value = time) %>% 
  merge(metadata, by = "sample", all.x = T) %>% 
  dplyr::mutate(real.time.min = real.time / 60,
                feature = ifelse(real.time.min >= start & real.time.min <= end,
                               sample, "Non feature"),
                fill = ifelse(feature == "Non feature", feature, group),
                mz = round(mz, 4),
                anno.mz = paste("Precursor m/z:", mz - mz.tol, "~", mz + mz.tol),
                anno.rt = paste("RT (min):", round(rt, 1)),
                anno = paste0(anno.mz, "\n", anno.rt)
  )
## ---------------------------------------------------------------------- 
anno <- dplyr::select(eic.df, .id, int, real.time.min, contains("anno")) %>% 
  .[, list(anno.x = min(real.time.min, na.rm = T),
           anno.y = max(int, na.rm = T) * 3 / 4,
           anno = unique(anno)),
                               by = list(.id)]
## ---------------------------------------------------------------------- 
## ========== Run block ==========
## ggplot2 plot segment ad MSdata
p <- ggplot(eic.df) +
  geom_line(
            aes(x = real.time.min,
                y = int,
                group = sample,
                color = fill),
            lineend = "round") +
  labs(color = "Peak attribution", x = "RT (min)", y = "Intensity") +
  geom_text(data = anno,
            aes(x = anno.x, y = anno.y, label = anno),
            hjust = 0, fontface = "bold", family = "Times") +
  scale_y_continuous(labels = scales::scientific) +
  facet_wrap( ~ paste("ID:", .id), scales="free") +
  theme_minimal() +
  scale_color_manual(values = palette) +
  theme(text = element_text(family = "Times"),
        plot.background = element_rect(fill = "white", size = 0),
        strip.text = element_text(
          size = 12
        )
  )
ggsave(p, filename = "test.svg", width = 11, height = 10)
## ---------------------------------------------------------------------- 
stack_ms1(target.feature$.id,
          metadata = metadata,
          quant.path = "earlist.neg.csv",
          mzml.path = "."
)

