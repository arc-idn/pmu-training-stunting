# PMU training: district stunting estimates (small-area estimation)

Training repository for the BKPK Policy Modelling Unit (PMU). It teaches how to estimate stunting prevalence for
districts where the survey sample is too small for a reliable direct estimate, using the Fay-Herriot small-area model,
written out step by step in base R. **The data here is DUMMY data, invented for practice.** No real SSGI or SKI data is
included.

## The policy question

How can we give each district a stunting estimate precise enough to guide programmes, when some districts have only a
few dozen children in the survey? This follows PMU research plan study B (provincial and district stunting estimates).

## The method in five steps

1. **Direct estimates.** The weighted share of stunted children in each district, with a sampling variance based on the
   effective sample size (the national rate is used in the variance so that a district with 0% does not get zero
   variance).
2. **Model.** Explain district prevalence with district covariates (here poverty and sanitation): the Fay-Herriot model.
3. **Between-district variance.** Estimate how much districts differ beyond the covariates (Prasad-Rao estimator).
4. **Shrinkage.** Each district's estimate combines its direct estimate and the model prediction. Districts with small
   samples lean more on the model; large samples keep their direct estimate.
5. **Precision and provinces.** Compare the coefficient of variation (CV) of direct and model estimates, and aggregate
   districts to provinces weighted by children under five.

Because the dummy data is invented, its true prevalence is known (`data/dummy/stunting_dummy_TRUTH_for_teaching.csv`).
The run prints the mean absolute error of the direct and model estimates against that truth: with the dummy data the
model roughly halves the error. Real data has no such file.

## How to run

In RStudio, open this folder as a project and run `source("run_all.R")`, or in a terminal `Rscript run_all.R`.
Only base R is used.

| File | What it does |
|---|---|
| `R/00_make_dummy_data.R` | Writes dummy children, district covariates and the teaching truth to `data/dummy/` |
| `R/01_clean.R` | Direct weighted estimates and their variance, by district |
| `R/02_analysis.R` | The Fay-Herriot model: variance, coefficients, shrinkage, MSE, province totals |
| `R/03_outputs.R` | `outputs/district_estimates.csv`, `outputs/province_estimates.csv`, `outputs/direct_vs_model.png` |

## Using real data

Set `DATA_DIR` to the folder with your files, for example `Sys.setenv(DATA_DIR = "D:/pmu/data")`. The child file needs
`district, stunted (0/1), weight`; the district file needs `district, province` plus the covariates and
`children_u5`. Never commit real data, and never publish estimates for districts with very small samples without their
CV.

## Exercises

1. Add one more covariate. Does the between-district variance fall? What happens to the shrinkage?
2. Which districts change most between direct and model estimates? Why those?
3. The MSE here keeps only its first term. Look up the full Prasad-Rao MSE and add the second term.
4. Compare the province estimates from districts with a direct province estimate. Should they agree?

ARC Institute for the BKPK Policy Modelling Unit. Dummy data only.
