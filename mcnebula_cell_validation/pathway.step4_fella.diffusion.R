## diffusion method
## FELLA plot
svg("diffusion.svg", height = 20, width = 20)
FELLA::plot(analysis.nafld,
            method = "diffusion",
            data = fella.data,
            # nlimit = 250,
            threshold = 1,
            plotLegend = T)
dev.off()
## ------------------------------------- 
# diffu.pscore <- FELLA::getPscores(analysis.nafld, "diffusion")
## ggplot2 plot
graph <- FELLA::generateResultsGraph(object = analysis.nafld,
                                     method = "diffusion",
                                     threshold = 0.1,
                                     data = fella.data)

