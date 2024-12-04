#' Compute the Confusion Matrix and Classification Metrics
#'
#' @param y_true Actual binary values (0 or 1).
#' @param y_pred Predicted probabilities (output of logistic regression).
#' @param threshold Threshold to classify predicted probabilities (default is 0.5).
#' @return A list containing the confusion matrix and metrics.
#' @export

compute_metrics <- function(y_true, y_pred, threshold = 0.5) {
  # Convert predicted probabilities to binary classification using the threshold
  y_pred_class <- ifelse(y_pred > threshold, 1, 0)
  
  # Confusion matrix: rows = Actual, columns = Predicted
  confusion_matrix <- table(
    Predicted = factor(y_pred_class, levels = c(0, 1)),
    Actual = factor(y_true, levels = c(0, 1))
  )
  
  # Handle cases where classes may be missing
  tp <- confusion_matrix[2, 2] # True Positives
  tn <- confusion_matrix[1, 1] # True Negatives
  fp <- confusion_matrix[2, 1] # False Positives
  fn <- confusion_matrix[1, 2] # False Negatives
  
  # Safely calculate metrics to avoid division by zero
  accuracy <- sum(diag(confusion_matrix)) / sum(confusion_matrix)
  sensitivity <- ifelse(tp + fn > 0, tp / (tp + fn), NA)
  specificity <- ifelse(tn + fp > 0, tn / (tn + fp), NA)
  false_discovery_rate <- ifelse(tp + fp > 0, fp / (tp + fp), NA)
  diagnostic_odds_ratio <- ifelse(
    !is.na(sensitivity) && !is.na(specificity) && sensitivity > 0 && specificity > 0,
    (sensitivity * specificity) / ((1 - sensitivity) * (1 - specificity)),
    NA
  )
  
  # Calculate prevalence
  prevalence <- mean(y_true)
  
  # Return all metrics as a list
  list(
    confusion_matrix = confusion_matrix,
    accuracy = accuracy,
    sensitivity = sensitivity,
    specificity = specificity,
    false_discovery_rate = false_discovery_rate,
    diagnostic_odds_ratio = diagnostic_odds_ratio,
    prevalence = prevalence
  )
}

bootstrap_ci <- function(X, y, n_boot = 100, alpha = 0.05) {
  # Store bootstrap estimates for each coefficient
  beta_estimates <- matrix(NA, nrow = n_boot, ncol = ncol(X) + 1)  # +1 for the intercept
  
  # Perform bootstrap resampling
  for (i in 1:n_boot) {
    idx <- sample(1:nrow(X), replace = TRUE)
    # Fit logistic regression on resampled data
    model <- logistic_regression(X[idx, ], y[idx])
    beta_estimates[i, ] <- model$coefficients
  }
  
  # Calculate the lower and upper quantiles for the confidence intervals
  ci <- apply(beta_estimates, 2, function(x) quantile(x, probs = c(alpha / 2, 1 - alpha / 2)))
  
  # Assign column names to beta_estimates (coefficients including intercept)
  colnames(beta_estimates) <- c("(Intercept)", colnames(X))
  
  # Create a data frame with the confidence intervals
  confidence_intervals <- data.frame(
    Coefficient = colnames(beta_estimates),  # Column names represent coefficients
    Lower = ci[1, ],
    Upper = ci[2, ]
  )
  
  return(confidence_intervals)
}

# Compute bootstrap confidence intervals
bootstrap_result <- bootstrap_ci(X_matrix, y, n_boot = 100, alpha = 0.05)

# Print the results
print(bootstrap_result)

binaryClassifier::bootstrap_ci(X_matrix, y, n_boot = 100, alpha = 0.05)
