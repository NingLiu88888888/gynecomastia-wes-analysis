#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(maftools)
  library(data.table)
})

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 2) {
  stop("Usage: Rscript 02_maftools_summary.R input.maf output_prefix")
}

maf_file <- args[1]
prefix <- args[2]

m <- read.maf(maf_file, vc_nonSyn = NULL)

pdf(paste0(prefix, "_oncoplot_top30.pdf"), width=12, height=10)
oncoplot(
  m,
  top=30,
  drawRowBar=TRUE,
  drawColBar=TRUE,
  showTumorSampleBarcodes=TRUE,
  showPct=TRUE,
  titleText="Somatic mutation landscape of gynecomastia"
)
dev.off()

pdf(paste0(prefix, "_summary.pdf"), width=12, height=10)
plotmafSummary(
  maf=m,
  rmOutlier=FALSE,
  addStat="median",
  dashboard=TRUE,
  titvRaw=FALSE
)
dev.off()

# Figure 6F: top 10 mutated genes
pdf(paste0(prefix, "_oncoplot_top10.pdf"), width=10, height=8)
oncoplot(
  m,
  top=10,
  drawRowBar=TRUE,
  drawColBar=TRUE,
  showTumorSampleBarcodes=TRUE,
  showPct=TRUE,
  titleText="Top 10 recurrently mutated genes"
)
dev.off()

# Export gene-level recurrence counts for audit.
gene_counts <- getGeneSummary(m)
fwrite(gene_counts, paste0(prefix, "_gene_summary.tsv"), sep="\t")
