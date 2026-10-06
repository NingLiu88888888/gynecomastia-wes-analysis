#!/usr/bin/env bash
set -euo pipefail
source ../config/config.sh

mkdir -p "${VCF_DIR}" logs

for VCF in "${VCF_DIR}"/*.unfiltered.vcf.gz; do
    PID=$(basename "${VCF}" .unfiltered.vcf.gz)

    ${GATK} FilterMutectCalls       -R "${REF_FA}"       -V "${VCF}"       -O "${VCF_DIR}/${PID}.filtered.vcf.gz"

    echo "${PID}" >> logs/filter_mutect_calls.completed.txt
done
