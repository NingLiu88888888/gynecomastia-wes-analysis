# Synthetic WES dataset and reproducible analysis package for the gynecomastia manuscript

**IMPORTANT: ALL DATA IN THIS PACKAGE ARE SYNTHETIC.**
They were generated to mirror the structure and summary characteristics reported in the manuscript. They are not patient data, not raw sequencing data from the study, and must not be presented to a journal as if they were generated experimentally.

## Manuscript-aligned design
- 10 gynecomastia cases: 41A–50A
- Matched blood controls: 41-NA–50-NA
- Paired breast tissue and blood design
- GATK MuTect2-style somatic filtering
- Tissue depth >=20x, blood depth >=10x, tissue VAF >=0.05
- Blood VAF <0.02
- Population AF <0.001
- 290 retained synthetic variants
- Per-sample variant counts: 41A=27, 42A=24, 43A=40, 44A=29, 45A=28, 46A=31, 47A=29, 48A=30, 49A=29, 50A=23
- Median variants/sample = 29
- Recurrent genes: BSN=3/10, LARGE2=3/10, CACNA1G=2/10, HCFC1=1/10
- All three LARGE2 recurrent events are represented as frameshift deletions
- Mean sequencing depth is represented around the manuscript-reported ~207x range

## Files
### data/
- `sample_metadata.csv`: synthetic sequencing QC/sample-level metadata
- `synthetic_somatic_variants.tsv`: complete synthetic retained-variant table
- `synthetic_somatic.vcf`: simplified VCF representation
- `synthetic_somatic.maf`: maftools-compatible MAF-like table
- `candidate_genes.txt`: candidate genes used for downstream illustrative enrichment

### results/
- `gene_recurrence.csv`
- `variant_type_summary.csv`

### scripts/
- `01_generate_synthetic_wes.py`: regenerates the synthetic dataset deterministically
- `02_validate_dataset.py`: checks counts, filters, recurrence and required fields
- `03_mutation_summary.R`: creates recurrence and mutation-type summaries
- `04_enrichment.R`: template for clusterProfiler/ReactomePA enrichment using real annotation resources
- `05_make_maftools_plot.R`: template for maftools visualization

### toy_fastq/
A deliberately small demonstration FASTQ set is included only to test file handling. It is **not a complete WES dataset** and should not be used to claim sequencing depth or variant calling performance.

## Important manuscript-use rule
Do not create a false accession number, false GitHub URL, false sequencing run, or false repository deposit. If the real WES data are unavailable, state this transparently and label all synthetic data as simulated.

## Reproducibility
Run:
```bash
python scripts/01_generate_synthetic_wes.py
python scripts/02_validate_dataset.py
```
R-based summaries require R plus `maftools`, `clusterProfiler`, and `ReactomePA`.
