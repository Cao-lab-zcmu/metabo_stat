
df <- data.table::fread("./canopus_compound_summary.tsv")
t <- tolower(gsub("#| ", "_", colnames(df)))

lapply(1:length(t),
  function(n) {
    x <- paste0(t[n], " = \"", colnames(df)[n], "\",")
    writeLines(x)
  })

utils::unzip("./1_instance5_gnps1234/test.zip", list = T)
t <- list.files("./1_instance5_gnps1234/ff/")[c(2, 4)]
tt <- paste0("./1_instance5_gnps1234/fingerid", "/", t)

mcn <- initialize_mcnebula(mcnebula(), "sirius.v5", ".")

mcn1 <- collate_used(mcn)
