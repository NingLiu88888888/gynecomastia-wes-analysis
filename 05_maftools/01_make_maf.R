#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(data.table)
})

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2) {
  stop("Usage: Rscript 01_make_maf.R filtered_annotated.tsv output.maf")
}

x <- fread(args[1], sep="\t", data.table=FALSE)

required <- c(
  "Gene","Chromosome","Start_Position","End_Position",
  "Reference_Allele","Tumor_Seq_Allele2","Variant_Classification",
  "Variant_Type","Sample"
)

missing <- setdiff(required, names(x))
if (length(missing)) {
  stop("Missing columns: ", paste(missing, collapse=", "))
}

maf <- data.frame(
  Hugo_Symbol = x$Gene,
  Chromosome = x$Chromosome,
  Start_Position = x$Start_Position,
  End_Position = x$End_Position,
  Reference_Allele = x$Reference_Allele,
  Tumor_Seq_Allele2 = x$Tumor_Seq_Allele2,
  Variant_Classification = x$Variant_Classification,
  Variant_Type = x$Variant_Type,
  Tumor_Sample_Barcode = x$Sample,
  stringsAsFactors = FALSE
)

write.table(maf, args[2], sep="\t", quote=FALSE, row.names=FALSE)
