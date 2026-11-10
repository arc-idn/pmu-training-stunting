# Direct survey estimates by district. DATA_DIR points to real data; by default the dummy data is used.
DATA_DIR <- Sys.getenv("DATA_DIR", "data/dummy")
kids <- read.csv(file.path(DATA_DIR, "stunting_dummy_children.csv"))
dist <- read.csv(file.path(DATA_DIR, "stunting_dummy_districts.csv"))
stopifnot(all(kids$stunted %in% 0:1), all(kids$district %in% dist$district))
direct <- do.call(rbind, lapply(split(kids, kids$district), function(k) data.frame(district = k$district[1], n = nrow(k),
           p_direct = sum(k$weight * k$stunted) / sum(k$weight), n_eff = sum(k$weight)^2 / sum(k$weight^2))))
# Sampling variance: use the national rate, not the district's own, so small samples with 0% do not get zero variance
p_nat <- weighted.mean(kids$stunted, kids$weight)
direct$var_direct <- p_nat * (1 - p_nat) / direct$n_eff
d <- merge(dist, direct, by = "district")
saveRDS(d, "outputs/clean.rds")
