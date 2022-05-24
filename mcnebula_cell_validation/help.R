## ## download data from MASSIVE
# get_metadata
# mcnebula_run
# merge_origin_analysis
# stat_ratio
# find_biomarker
# find_ac_compounds
# re_identification
# bio_generate_child_nebula
# bio_visualize_child_nenula
# bio_annotate_nebula
# hits_class
# get_real_class
# export.step 0 - 2
# source("~/outline/mcnebula_cell_validation/export.step3_format.R")
# source("~/outline/mcnebula_cell_validation/export.extra1_adduct.confi.R")
# source("~/outline/mcnebula_cell_validation/export.extra2_origin.id.R")
# source("~/outline/mcnebula_cell_validation/export.step9_gt.R")
# export.extra3_biomarker
# export.extra4_gt
# export.extra5_syno
## ------------------------------------- 
## get CID
source("~/outline/mcnebula_cell_validation/submit_to_metabo.cid.R")
## extract multiple id from syno
source("~/outline/mcnebula_cell_validation/syno.extract_multi.id.R")
## use MetaboAnalystR convert cid to kegg id
source("~/outline/mcnebula_cell_validation/pathway.step1_cid2kegg.metabo.R")
source("~/outline/mcnebula_cell_validation/pathway.step1.5_syno2kegg.pathview.R")
# source("~/outline/mcnebula_cell_validation/pathway.step2_fella.build.graph.R")
source("~/outline/mcnebula_cell_validation/pathway.step3_fella.enrich.R")
source("~/outline/mcnebula_cell_validation/pathway.step3.5_compound.format.R")
# source("~/outline/mcnebula_cell_validation/pathway.step4_fella.diffusion.R")
source("~/outline/mcnebula_cell_validation/pathway.step5_fella.pagerank.R")
source("~/outline/mcnebula_cell_validation/pathway.draw1_tidygraph.R")
source("~/outline/mcnebula_cell_validation/pathway.draw2_ggraph.R")
## ------------------------------------- 
## wikipathway
# wikipathway.step0_get.all.meta.R
## ------------------------------------- 
## HMDB
## hmdb.step0_download_format.R

