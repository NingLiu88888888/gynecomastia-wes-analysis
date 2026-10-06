#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(ggplot2)
  library(data.table)
})

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 2) stop("Usage: Rscript 02_plot_enrichment.R input.tsv output.pdf")

d <- fread(args[1], sep="\t", data.table=FALSE)
if (!all(c("Description","qvalue") %in% names(d))) {
  stop("Input must contain Description and qvalue columns.")
}

d <- d[is.finite(d$qvalue) & d$qvalue < 0.05, ]
d <- head(d[order(d$qvalue), ], 30)

if (nrow(d) == 0) {
  stop("No q<0.05 terms available.")
}

d$Description <- factor(d$Description, levels=rev(d$Description))
d$GeneRatioNum <- sapply(strsplit(as.character(d$GeneRatio), "/"),
                         function(z) as.numeric(z[1])/as.numeric(z[2]))

p <- ggplot(d, aes(x=GeneRatioNum, y=Description, size=Count)) +
  geom_point() +
  theme_bw() +
  labs(x="Gene ratio", y=NULL, size="Gene count")

ggsave(args[2], p, width=9, height=max(5, 0.22*nrow(d)+2))
