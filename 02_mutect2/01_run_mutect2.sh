#!/usr/bin/env bash
set -euo pipefail
source ../config/config.sh

mkdir -p "${VCF_DIR}" logs

tail -n +2 ../metadata/sample_sheet.tsv | while IFS=$'\t' read -r PID BREAST BLOOD BREAST_BAM BLOOD_BAM; do
    OUT="${VCF_DIR}/${PID}.unfiltered.vcf.gz"

    ${GATK} Mutect2       -R "${REF_FA}"       -I "${BAM_DIR}/${BREAST}.final.bam"       -I "${BAM_DIR}/${BLOOD}.final.bam"       -tumor "${BREAST}"       -normal "${BLOOD}"       -O "${OUT}"

    echo "${PID}" >> logs/mutect2.completed.txt
done

# GATK's paired tumor-normal mode is designed to use the matched normal to
# distinguish somatic from germline evidence. FilterMutectCalls is run next.
