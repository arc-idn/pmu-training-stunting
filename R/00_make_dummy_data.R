# Generate DUMMY data (invented values, for training only). Real analyses use SSGI/SKI child records and district covariates.
set.seed(2026)
prov <- rep(paste0("P", 1:6), each = 10); m <- length(prov)
dist <- data.frame(district = sprintf("D%02d", 1:m), province = prov,
                   poverty_pct = round(runif(m, 5, 30), 1), sanitation_pct = round(runif(m, 50, 95), 1),
                   children_u5 = round(runif(m, 20000, 150000)))
# True district prevalence (known only because the data is invented): depends on poverty and sanitation
eta <- -1.6 + 0.04 * (dist$poverty_pct - 15) - 0.02 * (dist$sanitation_pct - 75) + rnorm(m, 0, 0.25)
dist$true_prev <- plogis(eta)
# Survey: very different sample sizes by district, unequal weights
n_d <- round(exp(runif(m, log(20), log(350))))
kids <- do.call(rbind, lapply(seq_len(m), function(i) data.frame(district = dist$district[i],
          stunted = rbinom(n_d[i], 1, dist$true_prev[i]), weight = round(runif(n_d[i], 0.5, 2), 3))))
write.csv(kids, "data/dummy/stunting_dummy_children.csv", row.names = FALSE)
write.csv(dist[, c("district", "province", "poverty_pct", "sanitation_pct", "children_u5")], "data/dummy/stunting_dummy_districts.csv", row.names = FALSE)
write.csv(dist[, c("district", "true_prev")], "data/dummy/stunting_dummy_TRUTH_for_teaching.csv", row.names = FALSE)
cat("Dummy data written to data/dummy/ (", nrow(kids), "children,", m, "districts )\n")
