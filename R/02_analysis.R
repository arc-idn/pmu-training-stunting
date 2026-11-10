# Fay-Herriot area-level model, written out in base R so each step is visible.
#   direct_d = x_d' beta + v_d + e_d,  v_d ~ N(0, sigma2_v),  e_d ~ N(0, psi_d) with psi_d = var_direct (treated as known)
d <- readRDS("outputs/clean.rds")
X <- cbind(1, d$poverty_pct, d$sanitation_pct); y <- d$p_direct; psi <- d$var_direct; m <- nrow(X); k <- ncol(X)
# 1) sigma2_v by the Prasad-Rao moment estimator (from ordinary least squares residuals)
ols <- lm.fit(X, y); h <- diag(X %*% solve(crossprod(X)) %*% t(X))
sigma2_v <- max(0, (sum(ols$residuals^2) - sum(psi * (1 - h))) / (m - k))
# 2) beta by weighted least squares with weights 1 / (sigma2_v + psi)
w <- 1 / (sigma2_v + psi)
beta <- solve(crossprod(X, w * X), crossprod(X, w * y))
synthetic <- as.vector(X %*% beta)
# 3) shrinkage: districts with small samples (large psi) lean on the model
gamma <- sigma2_v / (sigma2_v + psi)
d$p_eblup <- gamma * y + (1 - gamma) * synthetic
d$gamma <- gamma
# 4) simple MSE (first term only; the full Prasad-Rao MSE adds two terms for estimating beta and sigma2_v)
d$mse_eblup <- gamma * psi
d$cv_direct <- 100 * sqrt(psi) / pmax(y, 0.01); d$cv_eblup <- 100 * sqrt(d$mse_eblup) / d$p_eblup
# 5) province estimates: districts weighted by number of children under five
prov <- do.call(rbind, lapply(split(d, d$province), function(z) data.frame(province = z$province[1],
          p_direct = weighted.mean(z$p_direct, z$children_u5), p_eblup = weighted.mean(z$p_eblup, z$children_u5))))
saveRDS(list(d = d, prov = prov, beta = beta, sigma2_v = sigma2_v), "outputs/fh.rds")
