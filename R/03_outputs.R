# Tables and one chart. With dummy data we also know the truth, so we can see how much the model helps.
r <- readRDS("outputs/fh.rds"); d <- r$d
write.csv(d[, c("district", "province", "n", "p_direct", "p_eblup", "gamma", "cv_direct", "cv_eblup")], "outputs/district_estimates.csv", row.names = FALSE)
write.csv(r$prov, "outputs/province_estimates.csv", row.names = FALSE)
tf <- file.path(Sys.getenv("DATA_DIR", "data/dummy"), "stunting_dummy_TRUTH_for_teaching.csv")
if (file.exists(tf)) { t <- merge(d, read.csv(tf), by = "district")
  cat("Mean absolute error vs truth (percentage points): direct", round(100 * mean(abs(t$p_direct - t$true_prev)), 2),
      " model", round(100 * mean(abs(t$p_eblup - t$true_prev)), 2), "\n") }
png("outputs/direct_vs_model.png", width = 1600, height = 900, res = 160)
par(mfrow = c(1, 2), mar = c(4.5, 5, 3, 1))
o <- order(d$n)
plot(d$n[o], 100 * d$p_direct[o], log = "x", pch = 1, col = "#6B7280", xlab = "Children sampled in district (log scale)",
     ylab = "Stunting prevalence (%)", main = "Direct vs model estimates (DUMMY)")
points(d$n[o], 100 * d$p_eblup[o], pch = 19, col = "#1E3A5F"); legend("topright", c("Direct", "Fay-Herriot"), pch = c(1, 19), col = c("#6B7280", "#1E3A5F"), bty = "n")
plot(d$cv_direct, d$cv_eblup, pch = 19, col = "#C8811A", xlab = "CV of direct estimate (%)", ylab = "CV of model estimate (%)", main = "Precision gain")
abline(0, 1, lty = 2); dev.off()
cat("sigma2_v =", signif(r$sigma2_v, 3), " beta =", round(r$beta, 4), "\n"); print(r$prov)
