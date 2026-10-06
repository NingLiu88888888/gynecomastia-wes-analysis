#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(clusterProfiler)
  library(org.Hs.eg.db)
  library(ReactomePA)
  library(ggplot2)
  library(data.table)
})

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 2) {
  stop("Usage: Rscript 01_go_kegg_reactome.R candidate_genes.txt output_dir")
}

gene_file <- args[1]
outdir <- args[2]
dir.create(outdir, recursive=TRUE, showWarnings=FALSE)

genes <- unique(trimws(readLines(gene_file)))
genes <- genes[genes != ""]

message("Input genes: ", paste(genes, collapse=", "))

mapped <- bitr(
  genes,
  fromType="SYMBOL",
  toType="ENTREZID",
  OrgDb=org.Hs.eg.db
)

write.table(mapped, file.path(outdir, "gene_symbol_to_entrez.tsv"),
            sep="\t", quote=FALSE, row.names=FALSE)

entrez <- unique(mapped$ENTREZID)

# GO: BP, CC, MF. BH-adjusted q-values <0.05 are significant.
for (ont in c("BP","CC","MF")) {
  ego <- enrichGO(
    gene=entrez,
    OrgDb=org.Hs.eg.db,
    keyType="ENTREZID",
    ont=ont,
    pAdjustMethod="BH",
    qvalueCutoff=0.05,
    readable=TRUE
  )
  df <- as.data.frame(ego)
  write.table(df, file.path(outdir, paste0("GO_", ont, ".tsv")),
              sep="\t", quote=FALSE, row.names=FALSE)

  if (nrow(df) > 0) {
    top <- head(df[order(df$qvalue, df$p.adjust), ], 30)
    write.table(top, file.path(outdir, paste0("GO_", ont, "_top30.tsv")),
                sep="\t", quote=FALSE, row.names=FALSE)
  }
}

# KEGG. clusterProfiler queries the KEGG resource available at execution time.
ekegg <- enrichKEGG(
  gene=entrez,
  organism="hsa",
  pAdjustMethod="BH",
  qvalueCutoff=0.05
)
kegg_df <- as.data.frame(ekegg)
write.table(kegg_df, file.path(outdir, "KEGG.tsv"),
            sep="\t", quote=FALSE, row.names=FALSE)
if (nrow(kegg_df) > 0) {
  write.table(head(kegg_df[order(kegg_df$qvalue, kegg_df$p.adjust), ], 30),
              file.path(outdir, "KEGG_top30.tsv"),
              sep="\t", quote=FALSE, row.names=FALSE)
}

# Reactome
er <- enrichPathway(
  gene=entrez,
  organism="human",
  pAdjustMethod="BH",
  qvalueCutoff=0.05,
  readable=TRUE
)
reactome_df <- as.data.frame(er)
write.table(reactome_df, file.path(outdir, "Reactome.tsv"),
            sep="\t", quote=FALSE, row.names=FALSE)
if (nrow(reactome_df) > 0) {
  write.table(head(reactome_df[order(reactome_df$qvalue, reactome_df$p.adjust), ], 30),
              file.path(outdir, "Reactome_top30.tsv"),
              sep="\t", quote=FALSE, row.names=FALSE)
}
