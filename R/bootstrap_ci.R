#' Bootstrap Confidence Intervals for Logistic Regression
#'
#' Computes confidence intervals for logistic regression coefficients using 
#' bootstrap resampling.
#'
#' @param X A numeric matrix of predictors, including an optional intercept column.
#' @param y A binary numeric vector (0/1) of responses corresponding to rows in \code{X}.
#' @param n_boot Integer specifying the number of bootstrap iterations (default: 20).
#' @param alpha Numeric value for the significance level (default: 0.05).
#' @return A data frame with coefficients and their confidence intervals (lower and upper bounds).
#' @importFrom stats quantile
#' @export
bootstrap_ci <- function(X, y, n_boot = 20, alpha = 0.05) {
  beta_estimates <- replicate(n_boot, {
    idx <- sample(1:nrow(X), replace = TRUE)
    logistic_regression(X[idx, ], y[idx])$coefficients
  })
  
  ci <- apply(beta_estimates, 1, quantile, probs = c(alpha / 2, 1 - alpha / 2))
  
  confidence_intervals <- data.frame(
    Coefficient = rownames(ci),
    Lower = ci[1, ],
    Upper = ci[2, ]
  )
  
  return(confidence_intervals)
}
