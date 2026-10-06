#!/usr/bin/env python3
"""Apply the documented post-Mutect2 filters.

Input: a tab-delimited variant table containing at least:
Sample, Gene, TissueDepth, TissueAltReads, TissueVAF, BloodDepth, BloodVAF,
PopulationMAF, VariantRegion, Consequence, Filter

The script intentionally uses the thresholds reported in the manuscript:
tissue DP >=20; blood DP >=10; tissue alt reads >=3; tissue VAF >=0.05;
blood VAF <0.02; population MAF <0.001; exonic/splicing; retained functional
classes.

It does not invent thresholds that are not documented.
"""

import argparse
import pandas as pd

KEEP_CONSEQUENCES = {
    "nonsynonymous",
    "missense",
    "stop-gain",
    "stop-loss",
    "frameshift",
    "frameshift_insertion",
    "frameshift_deletion",
    "non-frameshift",
    "non-frameshift_insertion",
    "non-frameshift_deletion",
    "splice-site",
}

KEEP_REGIONS = {"exonic", "splicing", "exonic;splicing"}

def norm(x):
    return str(x).strip().lower().replace(" ", "").replace("_", "-")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--input", required=True)
    ap.add_argument("--output", required=True)
    args = ap.parse_args()

    df = pd.read_csv(args.input, sep="\t")

    required = [
        "Sample","Gene","TissueDepth","TissueAltReads","TissueVAF",
        "BloodDepth","BloodVAF","PopulationMAF","VariantRegion",
        "Consequence","Filter"
    ]
    missing = [c for c in required if c not in df.columns]
    if missing:
        raise SystemExit("Missing columns: " + ", ".join(missing))

    d = df.copy()
    d["Filter"] = d["Filter"].astype(str).str.upper()
    d["Consequence_norm"] = d["Consequence"].map(norm)
    d["Region_norm"] = d["VariantRegion"].map(norm)

    keep = (
        (d["Filter"] == "PASS") &
        (pd.to_numeric(d["TissueDepth"], errors="coerce") >= 20) &
        (pd.to_numeric(d["BloodDepth"], errors="coerce") >= 10) &
        (pd.to_numeric(d["TissueAltReads"], errors="coerce") >= 3) &
        (pd.to_numeric(d["TissueVAF"], errors="coerce") >= 0.05) &
        (pd.to_numeric(d["BloodVAF"], errors="coerce") < 0.02) &
        (pd.to_numeric(d["PopulationMAF"], errors="coerce").fillna(0) < 0.001) &
        (d["Region_norm"].isin(KEEP_REGIONS)) &
        (d["Consequence_norm"].isin(KEEP_CONSEQUENCES))
    )

    out = d.loc[keep].drop(columns=["Consequence_norm","Region_norm"])
    out.to_csv(args.output, sep="\t", index=False)

    print(f"Input variants: {len(d)}")
    print(f"Retained variants: {len(out)}")

if __name__ == "__main__":
    main()
