# ==========================================================================
# convert ...
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pdb <- readLines('~/pinyinDB/misc/pinyin_huge.txt')
pdb <- tibble::tibble(V1 = stringr::str_extract(pdb, "^[a-z]*"),
  V2 = gsub('^[a-z ]*', '', pdb)
)

data <- lapply(list.files('~/Downloads/dictionary/', '*.txt$', full.names = T),
  function(file) {
    data.table::fread(file, header = F)
  })
data <- c(data, list(pdb))
data <- data.table::rbindlist(data)

data <- dplyr::mutate(data, V1 = gsub('\'', '', V1))
data <- split(data, data$V1)
len2 <- which(vapply(data, nrow, double(1)) > 1)

data[len2] <- lapply(data[len2],
  function(data) {
    name <- data[1, 1]
    data.frame(V1 = name, V2 = paste(data$V2, collapse = " "))
  })

data <- data.table::rbindlist(data)
data <- dplyr::arrange(data, V1)

data.table::fwrite(data, "pinyin_huge.txt", col.names = F, sep = " ", quote = F)


