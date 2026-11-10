# Run the whole chain from a clean clone: Rscript run_all.R
dir.create("outputs", showWarnings = FALSE)
if (!file.exists(file.path(Sys.getenv("DATA_DIR", "data/dummy"), "stunting_dummy_children.csv"))) source("R/00_make_dummy_data.R")
for (f in c("R/01_clean.R", "R/02_analysis.R", "R/03_outputs.R")) { cat("Running", f, "\n"); source(f) }
