
# A function that does a statistical analysis of the prediction accuracy.

err <- prediction - record
normalized_err <- 100*(prediction - record)/record #Look at normalized error
abs_normalized_err <-abs(normalized.err)
confidence <- round(quantile(abs_normalized_err,0.95),2)
bias <- round(sum(normalized.err)/length(normalized.err),2)
rms_err <- round(sqrt(sum(normalized_err^2)/length(normalized.err)),2)
histogram <- hist(normalized.error, breaks = -75:375, xlim = c(-100,375), main = "Percent Error",
     sub = paste("BIAS:", bias, " RMS:", rms_err, " 95% Conf:", confidence),
     xlab = "Percent Error", plot = FALSE)