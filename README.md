# PMU training: stunting

Hands-on training repository for the BKPK Policy Modelling Unit (PMU). Code and explanation only: **no data is included
or ever committed**. A synthetic-data generator lets you run the full chain without real data.

**Policy question.** How can stunting prevalence be estimated for provinces and districts where survey samples are small?

**Basis.** PMU research plan study B (provincial and district stunting estimates), small-area estimation.

## What this repository will contain

| Path | Purpose |
|---|---|
| `README.md` | This explanation: question, data needed and how to obtain it, method step by step, how to run, exercises |
| `R/00_setup.R` ... `R/03_outputs.R` | Numbered scripts, a comment on every block |
| `run_all.R` | Runs the whole chain from a clean clone |
| `data/README.md` | Each expected input file and its columns; the `data/` folder itself is never committed |
| `R/make_synthetic_data.R` | Writes invented example data so the chain runs end to end |

Status: in preparation. The scripts and the full explanation are being added.

ARC Institute for the BKPK Policy Modelling Unit.
