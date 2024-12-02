########
#' Logistic Regression Estimator
#'
#' @param X A numeric matrix of predictor variables.
#' @param y A binary response variable.
#' @param alpha Significance level for confidence intervals.
#' @param n_bootstrap Number of bootstrap samples for confidence intervals.
#' @return A list containing estimated coefficients, confidence intervals, and bootstrap coefficients.
#' @export
logistic_regression <- function(X, y, alpha = 0.05, n_bootstrap = 20) {
  # Add intercept term (column of ones) to the predictor matrix
  X_with_intercept <- cbind(1, X)
  n <- nrow(X)  # Number of observations
  
  # Initial coefficients using least squares: (X'X)^-1 X'y
  initial_coef <- solve(t(X_with_intercept) %*% X_with_intercept) %*% t(X_with_intercept) %*% y
  
  # Log-likelihood function for logistic regression
  log_likelihood <- function(beta, X, y) {
    p <- 1 / (1 + exp(-X %*% beta))  # Logistic function to get predicted probabilities
    return(sum(y * log(p) + (1 - y) * log(1 - p)))  # Log-likelihood formula
  }
  
  # Use optimization to minimize the negative log-likelihood
  optim_result <- optim(initial_coef, function(beta) -log_likelihood(beta, X_with_intercept, y), method = "BFGS")
  coef_estimates <- optim_result$par  # Optimized coefficients
  
  # Bootstrap Confidence Intervals
  bootstrap_coefs <- matrix(0, nrow = n_bootstrap, ncol = length(coef_estimates))
  for (i in 1:n_bootstrap) {
    indices <- sample(1:n, n, replace = TRUE)  # Bootstrap resample indices
    X_boot <- X_with_intercept[indices, , drop = FALSE]  # Bootstrap X matrix
    y_boot <- y[indices]  # Bootstrap y vector
    
    # Get bootstrap coefficients using optimization
    boot_coef <- optim(initial_coef, function(beta) -log_likelihood(beta, X_boot, y_boot), method = "BFGS")$par
    bootstrap_coefs[i, ] <- boot_coef  # Store the bootstrap coefficients
  }
  
  # Confidence intervals for coefficients (using bootstrap results)
  lower <- apply(bootstrap_coefs, 2, function(x) quantile(x, alpha / 2))  # Lower CI
  upper <- apply(bootstrap_coefs, 2, function(x) quantile(x, 1 - alpha / 2))  # Upper CI
  
  # Return results as a list
  list(
    coefficients = coef_estimates,  # Estimated coefficients
    conf_intervals = data.frame(lower = lower, upper = upper),  # Bootstrap confidence intervals
    bootstrap_coefs = bootstrap_coefs  # Bootstrap coefficients
  )
}

