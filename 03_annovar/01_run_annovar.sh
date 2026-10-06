#!/usr/bin/env bash
set -euo pipefail
source ../config/config.sh

mkdir -p "${ANNOVAR_DIR_OUT}"

# The manuscript specifies ANNOVAR and SIFT/PolyPhen-2/CADD, but does not
# specify exact ANNOVAR database release names. Set these variables to the
# actual downloaded database versions before running.
PROTOCOL="refGene,dbnsfp"
OPERATION="g,f"

for VCF in "${VCF_DIR}"/*.filtered.vcf.gz; do
    PID=$(basename "${VCF}" .filtered.vcf.gz)

    perl "${ANNOVAR_DIR}/table_annovar.pl"       "${VCF}"       "${ANNOVAR_DB}"       -buildver hg19       -out "${ANNOVAR_DIR_OUT}/${PID}"       -remove       -protocol "${PROTOCOL}"       -operation "${OPERATION}"       -nastring .       -vcfinput       -polish

done

# IMPORTANT: Do not claim the exact historical ANNOVAR database versions
# until they have been confirmed from the original analysis environment.
