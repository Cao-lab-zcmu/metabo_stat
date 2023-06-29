# ==========================================================================
# draw flow chart
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

library(ggraph)
library(ggplot2)

lst <- list(
  "筛选基因" = c("分析GEO数据库", "基因数据库", "NLP处理文献"),
  "分析GEO数据库" = c("RNA-seq", "Microarray"),
  "RNA-seq" = "差异表达基因",
  "Microarray" = "差异表达基因",
  "差异表达基因" = "潜在标志基因",
  "基因数据库" = "潜在标志基因",
  "潜在标志基因" = "泛组织Signature",
  "NLP处理文献" = "泛组织Signature"
)
data <- as_df.lst(lst, "from", "to")

graph <- fast_layout(data, "sugiyama")
p <- ggraph(graph) +
  geom_edge_fan(aes(x = x, y = y),
    start_cap = circle(7, 'mm'),
    end_cap = circle(7, 'mm'),
    arrow = arrow(length = unit(2, 'mm')),
    color = 'lightblue', width = 1) +
  # geom_node_tile(aes.85width = .85, height = .6)) +
  geom_node_label(aes(label = paste0(.ggraph.index, ". ", name)),
    size = 4, label.padding = u(.5, lines)) +
  scale_x_continuous(limits = MCnebula2:::zoRange(graph$x, 1.2)) +
  scale_y_continuous(limits = MCnebula2:::zoRange(graph$y, 1.15)) +
  theme_void()
ggsave("analysis_case.png", p, width = 7, height = 5)

# ==========================================================================
# case 2
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

lst <- list(
  "下载MASSIVE数据" = "LC-MS/MS预处理",
  "LC-MS/MS预处理" = "鉴定和预测化合物",
  "鉴定和预测化合物" = "注释数据预处理",
  "注释数据预处理" = c("获取分子式和结构式", "基于丰度筛选化学类", "统计分析"),
  "统计分析" = c("对照组 vs 疾病组", "存活组 vs 致死组"),
  "存活组 vs 致死组" = "Tops 化合物",
  "基于丰度筛选化学类" = "多网络可视化",
  "Tops 化合物" = "多网络可视化",
  "多网络可视化" = c("追踪Tops的可视化", "基于含量的可视化"),
  "基于含量的可视化" = "筛选化学类",
  "追踪Tops的可视化" = "筛选化学类",
  "筛选化学类" = c("热图聚类分析", "通路富集分析", "化学信息查询"),
  "化学信息查询" = c("立体异构的InChIKey", "规范的分析鉴定表"),
  "立体异构的InChIKey" = "同义名和ID",
  "同义名和ID" = "KEGG ID",
  "KEGG ID" = "通路富集分析",
  "热图聚类分析" = c("判断疾病关联的化学类和化合物"),
  "通路富集分析" = c("判断疾病关联的化学类和化合物")
)
data <- as_df.lst(lst)
graph <- fast_layout(data, "sugiyama")
# graph$x <- ifelse(graph$.ggraph.index == 17, graph$x - .2, graph$x)

p <- ggraph(graph) +
  geom_edge_fan(aes(x = x, y = y),
    start_cap = circle(3, 'mm'),
    end_cap = circle(6, 'mm'),
    arrow = arrow(length = unit(2, 'mm')),
    color = 'lightblue', width = 1) +
  geom_node_label(aes(label = paste0(.ggraph.index, ". ", name)),
    size = 3, label.padding = u(.5, lines), alpha = .5) +
  scale_x_continuous(limits = MCnebula2:::zoRange(graph$x, 1.2)) +
  scale_y_continuous(limits = MCnebula2:::zoRange(graph$y, 1)) +
  theme_void()
ggsave("analysis_case2.png", p, width = 7, height = 9)

# ==========================================================================
# GEO flow chart
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

lst <- list(
  "检索GEO数据库" = "确认数据背景",
  "确认数据背景" = c("相关研究", "信息完整性", "获取数据集"),
  "获取数据集" = "读取和整备数据集",
  "读取和整备数据集" = "基因信息注释",
  "基因信息注释" = "数据归一化",
  "数据归一化" = "差异性分析矩阵设计",
  "差异性分析矩阵设计" = c("设计矩阵", "对比矩阵", "统计检验"),
  "统计检验" = c("统计数据可视化", "通路富集分析"),
  "统计数据可视化" = c("表格", "图片"),
  "通路富集分析" = "通路可视化",
  "通路可视化" = "分析数据汇总",
  "统计数据可视化" = "分析数据汇总",
  "分析数据汇总" = "得出结论",
  "得出结论" = "输出报告"
)
data <- as_df.lst(lst)
graph <- fast_layout(data, "sugiyama")

p <- ggraph(graph) +
  geom_edge_fan(aes(x = x, y = y),
    start_cap = circle(3, 'mm'),
    end_cap = circle(6, 'mm'),
    arrow = arrow(length = unit(2, 'mm')),
    color = 'lightblue', width = 1) +
  geom_node_label(aes(label = paste0(sortSugi(y), ". ", name)),
    size = 3, label.padding = u(.5, lines), alpha = .5) +
  scale_x_continuous(limits = MCnebula2:::zoRange(graph$x, 1.2)) +
  scale_y_continuous(limits = MCnebula2:::zoRange(graph$y, 1)) +
  theme_void()
ggsave("GEO_case.png", p, width = 7, height = 9)


