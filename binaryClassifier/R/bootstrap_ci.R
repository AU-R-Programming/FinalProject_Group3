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
  # Initialize a matrix to store the bootstrap estimates
  beta_estimates <- matrix(0, nrow = ncol(X), ncol = n_boot)
  
  for (b in 1:n_boot) {
    # Bootstrap sample indices
    idx <- sample(seq_len(nrow(X)), replace = TRUE)
    
    # Get bootstrap samples
    X_boot <- X[idx, , drop = FALSE]
    y_boot <- y[idx]
    
    # Store the estimated coefficients
    beta_estimates[, b] <- logistic_regression(X_boot, y_boot)
  }
  
  # Calculate the confidence intervals
  lower <- numeric(ncol(X))
  upper <- numeric(ncol(X))
  
  for (j in 1:ncol(X)) {
    # Sort the bootstrap estimates for the jth coefficient
    sorted_estimates <- sort(beta_estimates[j, ])
    
    # Calculate the quantile indices
    lower_idx <- ceiling(alpha / 2 * n_boot)
    upper_idx <- floor((1 - alpha / 2) * n_boot)
    
    # Assign the quantiles to the confidence intervals
    lower[j] <- sorted_estimates[lower_idx]
    upper[j] <- sorted_estimates[upper_idx]
  }
  
  # Combine the lower and upper bounds into a matrix
  ci <- cbind(lower, upper)
  return(ci)
}

