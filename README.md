# Gynecomastia WES analysis

Reconstructed analysis workflow for the manuscript combining paired whole-exome sequencing (WES) of gynecomastia breast tissue and matched peripheral blood with mutation profiling and pathway enrichment.

## Scope

This repository is a **reconstructed, reproducible implementation based on the submitted manuscript, Supplementary Table S1, and the documented final results**. It is not claimed to be the original historical scripts used by the sequencing provider unless those scripts are supplied separately.

The manuscript documents the following core parameters:

- 10 gynecomastia patients; paired breast tissue and matched peripheral blood.
- Agilent SureSelect Human All Exon V7 capture; Illumina NovaSeq 6000.
- Adapter trimming with Trimmomatic.
- Alignment to hg19 with BWA.
- GATK preprocessing including duplicate removal and base-quality score recalibration.
- Somatic calling with GATK MuTect2 in paired tumor-normal mode.
- GATK FilterMutectCalls.
- Tissue depth >=20x.
- Matched-blood depth >=10x.
- At least 3 alternate-supporting reads in tissue.
- Tissue VAF >=0.05.
- Matched-blood VAF >=0.02 -> excluded.
- Common germline variants with MAF >=0.001 in 1000 Genomes, ExAC, or gnomAD -> excluded.
- Retained functional classes: nonsynonymous/missense, stop-gain, stop-loss, frameshift, non-frameshift indels, and splice-site variants.
- Excluded synonymous, intronic, intergenic, and low-confidence variants.
- ANNOVAR annotation included gene-region, amino-acid, conservation and pathogenicity information including SIFT, PolyPhen-2 and CADD.
- maftools used for mutation summaries and oncoplots.
- GO/KEGG/Reactome enrichment used BH-FDR correction; q<0.05 considered significant; top 30 terms/pathways visualized.
- The ten recurrent genes explicitly documented for the later Enrichr analysis are: LARGE2, BSN, LRRC32, INPP5J, HCFC1, FLG, CSPG4, CACNA1G, ANKHD1 and AKAP1.

## Important unresolved items

The manuscript does **not** document enough information to claim exact historical reproduction of every command. Before public release, replace the marked placeholders with the actual values if available:

1. Exact GATK version.
2. Exact BWA and Trimmomatic versions and trimming parameters.
3. Exact hg19 reference build/file checksum.
4. Exact GATK germline-resource/PoN settings, if any were used. The manuscript does not report them, so the reconstructed Mutect2 command does not silently add them.
5. Exact ANNOVAR database releases and DBNSFP version.
6. Exact GO/KEGG/Reactome software/database release used for Figures 7–8.
7. Exact gene list used for the original GO/KEGG/Reactome analysis. The manuscript calls it “candidate pathogenic genes” but does not define the list. The later Enrichr analysis explicitly uses the ten recurrent genes; this repository therefore uses that list as a **provisional reconstruction** and labels it accordingly.
8. The manuscript and Supplementary Table S1 currently use different sample identifiers (e.g. 41A/41-NA in sequencing QC tables versus P01/P02... in S1). This must be reconciled before claiming full reproducibility.

## Directory structure

- `config/` — paths and documented thresholds.
- `metadata/` — sample sheet and gene lists.
- `01_qc_alignment/` — trimming, BWA alignment, duplicate marking and BQSR.
- `02_mutect2/` — paired somatic calling and FilterMutectCalls.
- `03_annovar/` — ANNOVAR annotation.
- `04_filtering/` — documented depth/VAF/alt-read/germline-frequency filtering.
- `05_maftools/` — MAF conversion and mutation plots.
- `06_enrichment/` — GO, KEGG and Reactome enrichment.
- `07_public_resources/` — gene-level overlap framework for GWAS Catalog/CTD/Open Targets/DisGeNET.
- `08_expression/` — placeholder for GTEx/HPA analyses added during reviewer revision.
- `09_figures/` — figure assembly scripts.
- `results/` — generated outputs; raw human genomic data must NOT be committed here.

## Human genomic data warning

Do not place FASTQ, BAM/CRAM, individual-level VCF, or other identifiable/individual-level genomic data in a public GitHub repository. Those data should be deposited through an appropriate controlled-access human genomic database. Only de-identified summary data, code, configuration templates and non-sensitive example inputs should be public.

## Reproduction order

1. Complete `metadata/sample_sheet.tsv`.
2. Complete `config/config.sh`.
3. Run QC/alignment.
4. Run paired Mutect2 and FilterMutectCalls.
5. Run ANNOVAR.
6. Run the documented post-calling filter.
7. Convert the final annotated variants to MAF.
8. Run maftools plots.
9. Run GO/KEGG/Reactome enrichment.
10. Run public-resource and expression analyses if the exact input tables/API exports used in the manuscript are available.

## Scientific interpretation

Mutation frequencies are descriptive only. The study has n=10 and no normal male breast-tissue controls or background mutation-rate model. Recurrent mutations should not be interpreted as proof of positive selection or gynecomastia-specific recurrence.
