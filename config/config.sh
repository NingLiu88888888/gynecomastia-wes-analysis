#!/usr/bin/env bash
set -euo pipefail

# =========================
# Gynecomastia WES settings
# =========================

# Reference/build documented in manuscript
REF_BUILD="hg19"
REF_FA="/PATH/TO/hg19.fa"

# Tools: versions should be filled with the versions actually used.
GATK="gatk"
BWA="bwa"
TRIMMOMATIC="trimmomatic"
SAMTOOLS="samtools"
BCFTOOLS="bcftools"
ANNOVAR_DIR="/PATH/TO/annovar"
ANNOVAR_DB="/PATH/TO/annovar/humandb"

# Capture target BED (Agilent SureSelect Human All Exon V7)
TARGET_BED="/PATH/TO/SureSelect_Human_All_Exon_V7_targets.bed"

# FASTQ/BAM locations
RAW_FASTQ_DIR="/PATH/TO/raw_fastq"
BAM_DIR="/PATH/TO/bam"
VCF_DIR="/PATH/TO/vcf"
ANNOVAR_DIR_OUT="/PATH/TO/annovar_output"
MAF_DIR="/PATH/TO/maf"
RESULT_DIR="/PATH/TO/results"

# Adapter file for Trimmomatic. The manuscript states that Trimmomatic was used,
# but does not report the exact adapter file or trimming parameters.
ADAPTER_FASTA="/PATH/TO/TruSeq3-PE.fa"

# Documented somatic filtering thresholds
MIN_TISSUE_DP=20
MIN_BLOOD_DP=10
MIN_TISSUE_ALT_READS=3
MIN_TISSUE_VAF=0.05
MAX_BLOOD_VAF=0.02
MAX_COMMON_GERMLINE_MAF=0.001

# Enrichment
FDR_CUTOFF=0.05
TOP_N_TERMS=30

# Do not commit this file with private paths if the repository is public.
