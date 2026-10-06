#!/usr/bin/env bash
set -euo pipefail
source ../config/config.sh

# Reconstructed workflow based on the manuscript:
# Trimmomatic -> BWA alignment to hg19 -> duplicate removal -> BQSR.
# Exact Trimmomatic parameters and GATK/BWA versions were not reported and
# therefore must be replaced with the actual historical values if available.

SAMPLE_SHEET="../metadata/sample_sheet.tsv"
mkdir -p "${BAM_DIR}" logs

tail -n +2 "${SAMPLE_SHEET}" | while IFS=$'\t' read -r PID BREAST BLOOD BREAST_BAM BLOOD_BAM; do
    echo "Processing ${PID}"

    # Expected raw FASTQ names; edit if your naming differs.
    R1_B="${RAW_FASTQ_DIR}/${BREAST}_R1.fastq.gz"
    R2_B="${RAW_FASTQ_DIR}/${BREAST}_R2.fastq.gz"
    R1_N="${RAW_FASTQ_DIR}/${BLOOD}_R1.fastq.gz"
    R2_N="${RAW_FASTQ_DIR}/${BLOOD}_R2.fastq.gz"

    ${TRIMMOMATIC} PE -threads 8       "${R1_B}" "${R2_B}"       "${RAW_FASTQ_DIR}/${BREAST}_R1.trimmed.fastq.gz" "${RAW_FASTQ_DIR}/${BREAST}_R1.unpaired.fastq.gz"       "${RAW_FASTQ_DIR}/${BREAST}_R2.trimmed.fastq.gz" "${RAW_FASTQ_DIR}/${BREAST}_R2.unpaired.fastq.gz"       ILLUMINACLIP:"${ADAPTER_FASTA}":2:30:10       LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36

    ${BWA} mem -t 8 "${REF_FA}"       "${RAW_FASTQ_DIR}/${BREAST}_R1.trimmed.fastq.gz"       "${RAW_FASTQ_DIR}/${BREAST}_R2.trimmed.fastq.gz" |
      ${SAMTOOLS} sort -@ 4 -o "${BAM_DIR}/${BREAST}.sorted.bam"

    ${GATK} MarkDuplicates       -I "${BAM_DIR}/${BREAST}.sorted.bam"       -O "${BAM_DIR}/${BREAST}.dedup.bam"       -M "${BAM_DIR}/${BREAST}.dup_metrics.txt"       --CREATE_INDEX true

    # BQSR requires the actual known-sites resources. These paths are placeholders.
    ${GATK} BaseRecalibrator       -R "${REF_FA}"       -I "${BAM_DIR}/${BREAST}.dedup.bam"       --known-sites /PATH/TO/known_sites_1.vcf.gz       --known-sites /PATH/TO/known_sites_2.vcf.gz       -O "${BAM_DIR}/${BREAST}.recal.table"

    ${GATK} ApplyBQSR       -R "${REF_FA}"       -I "${BAM_DIR}/${BREAST}.dedup.bam"       --bqsr-recal-file "${BAM_DIR}/${BREAST}.recal.table"       -O "${BAM_DIR}/${BREAST}.final.bam"

    ${SAMTOOLS} index "${BAM_DIR}/${BREAST}.final.bam"

    # Repeat the same preprocessing for matched blood.
    ${TRIMMOMATIC} PE -threads 8       "${R1_N}" "${R2_N}"       "${RAW_FASTQ_DIR}/${BLOOD}_R1.trimmed.fastq.gz" "${RAW_FASTQ_DIR}/${BLOOD}_R1.unpaired.fastq.gz"       "${RAW_FASTQ_DIR}/${BLOOD}_R2.trimmed.fastq.gz" "${RAW_FASTQ_DIR}/${BLOOD}_R2.unpaired.fastq.gz"       ILLUMINACLIP:"${ADAPTER_FASTA}":2:30:10       LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36

    ${BWA} mem -t 8 "${REF_FA}"       "${RAW_FASTQ_DIR}/${BLOOD}_R1.trimmed.fastq.gz"       "${RAW_FASTQ_DIR}/${BLOOD}_R2.trimmed.fastq.gz" |
      ${SAMTOOLS} sort -@ 4 -o "${BAM_DIR}/${BLOOD}.sorted.bam"

    ${GATK} MarkDuplicates       -I "${BAM_DIR}/${BLOOD}.sorted.bam"       -O "${BAM_DIR}/${BLOOD}.dedup.bam"       -M "${BAM_DIR}/${BLOOD}.dup_metrics.txt"       --CREATE_INDEX true

    ${GATK} BaseRecalibrator       -R "${REF_FA}"       -I "${BAM_DIR}/${BLOOD}.dedup.bam"       --known-sites /PATH/TO/known_sites_1.vcf.gz       --known-sites /PATH/TO/known_sites_2.vcf.gz       -O "${BAM_DIR}/${BLOOD}.recal.table"

    ${GATK} ApplyBQSR       -R "${REF_FA}"       -I "${BAM_DIR}/${BLOOD}.dedup.bam"       --bqsr-recal-file "${BAM_DIR}/${BLOOD}.recal.table"       -O "${BAM_DIR}/${BLOOD}.final.bam"

    ${SAMTOOLS} index "${BAM_DIR}/${BLOOD}.final.bam"
done
