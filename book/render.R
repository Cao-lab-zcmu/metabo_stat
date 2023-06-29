
write_articlePdf("./Rtips.Rmd", "Rtips2.Rmd", "R tips")
write_biocStyle("./Rtips.Rmd", "Rtips2.Rmd", "R tips")

file.copy("Rtips2.html", "~/MCnebula2/content/en/docs/help/", T)
