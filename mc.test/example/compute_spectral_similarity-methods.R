
## codes
test <- mcn_5features

## the previous steps
test1 <- filter_structure(test)
test1 <- create_reference(test1)
test1 <- filter_formula(test1, by_reference = T)
test1 <- create_stardust_classes(test1)
test1 <- create_features_annotation(test1)
test1 <- cross_filter_stardust(test1, 2, 1)
test1 <- create_nebula_index(test1)

test1 <- compute_spectral_similarity(test1)
## see results
spectral_similarity(test1)
## or
reference(test1)$spectral_similarity
## or
reference(mcn_dataset(test1))$spectral_similarity

## compare the two spectra individually
spectra <- latest(test1, "project_dataset", ".f3_spectra")
data1 <- dplyr::select(
  dplyr::filter(spectra, .features_id == "gnps1537"),
  mz, int.
)
data2 <- dplyr::select(
  dplyr::filter(spectra, .features_id == "gnps1539"),
  mz, int.
)
e1 <- compute_spectral_similarity(sp1 = data1, sp2 = data2)
e1
# [1] 0.7670297

## MSnbase
if (requireNamespace("MSnbase")) {
  MSnbase::compareSpectra
  spec1 <- new("Spectrum2", mz = data1$mz, intensity = data1$int.)
  spec2 <- new("Spectrum2", mz = data2$mz, intensity = data2$int.)
  e2 <- MSnbase::compareSpectra(spec1, spec2, fun = "dotproduct")
  identical(e1, e2)
}
