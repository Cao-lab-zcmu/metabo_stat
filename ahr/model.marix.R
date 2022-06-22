## group
group <- c("model", "control", "raw", "pro")
## design
design <- model.matrix(~ group)
## mutate
# design <- model.matrix(~ 0 + group)
contr <- limma::makeContrasts((grouppro + groupraw) / 2 - groupmodel, levels = design)
## ---------------------------------------------------------------------- 
## mutate
treat. <- paste0("trt", 1:3)
## another treat
parr. <- paste0("par", 1:3)
## design: Interactions using a two-factor model: all possibly constitute
mutate_design <- model.matrix(~ treat. * parr.)
## ------------------------------------- 
mutate_design2 <- model.matrix(~ treat. + parr.)
## ---------------------------------------------------------------------- 
## time series
## time is a numeric variable
time <- time(1:4)
## design
time_design <- model.matrix(~ time)
time_design.poly2 <- model.matrix(~ poly(time, degree = 2, raw = T))
## treatment and time
mutate_group. <- paste0(group, time)
## complex design
sample_time_design <- model.matrix(~ 0 + mutate_group. * time)
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## instance
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
in.group. <- c(rep("control", 3), rep("model", 3))
## model matrix
in.design <- model.matrix(~ 0 + in.group.)
## contrast matrix
in.contr <- limma::makeContrasts(in.group.model - in.group.control, levels = in.design)
## ---------------------------------------------------------------------- 
age <- 1:6
age.design <- model.matrix(~ age)
# age.contr <- limma::makeContrasts()
