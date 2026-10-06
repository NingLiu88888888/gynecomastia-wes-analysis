#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(data.table))

args <- commandArgs(trailingOnly=TRUE)
if (length(args) != 3) {
  stop("Usage: Rscript overlap_genes.R candidate_genes.txt database_gene_table.tsv output.tsv")
}

candidate <- unique(trimws(readLines(args[1])))
db <- fread(args[2], data.table=FALSE)

if (!"Gene" %in% names(db)) stop("Database table must contain a 'Gene' column.")

db$Gene <- toupper(trimws(db$Gene))
candidate <- toupper(candidate)

db$Overlap <- db$Gene %in% candidate
fwrite(db[db$Overlap, ], args[3], sep="\t")
