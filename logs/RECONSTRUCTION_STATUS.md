# Reconstruction status

## Supported directly by manuscript/SI

- Paired breast tissue and matched blood.
- 10 patients.
- hg19.
- Trimmomatic -> BWA -> GATK preprocessing.
- MuTect2 paired tumor-normal.
- FilterMutectCalls.
- Tissue DP >=20.
- Blood DP >=10.
- Tissue alt reads >=3.
- Tissue VAF >=0.05.
- Blood VAF >=0.02 excluded.
- Population MAF >=0.001 excluded.
- Functional classes retained.
- BH-FDR; q<0.05.
- Top 30 GO/pathway terms.
- maftools for mutation landscape.
- Ten recurrent genes used for the later Enrichr analysis.

## Not documented sufficiently for exact historical reconstruction

- software versions;
- trimming settings;
- BWA/GATK exact command-line options;
- known-sites and BQSR resources;
- germline resource/PoN settings for Mutect2;
- ANNOVAR database releases;
- exact original GO/KEGG/Reactome gene list;
- exact enrichment package/database releases;
- exact mapping between 41A–50A and P01–P10;
- complete final machine-readable mutation table.

These items must be resolved before the GitHub repository is presented as the exact historical analysis pipeline.
