## pagerank method
## FELLA plot
svg("pagerank.svg", height = 20, width = 20)
FELLA::plot(analysis.nafld,
            method = "pagerank",
            data = fella.data,
            # nlimit = 250,
            threshold = 1,
            plotLegend = T)
dev.off()
## ---------------------------------------------------------------------- 
## ggplot2 plot
## ---------------------------------------------------------------------- 
# page.pscore <- FELLA::getPscores(analysis.nafld, "pagerank")
graph <- FELLA::generateResultsGraph(object = analysis.nafld,
                                     method = "pagerank",
                                     threshold = 0.1,
                                     data = fella.data)
