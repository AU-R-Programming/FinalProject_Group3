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
  confusion_matrix <- table(Predicted = y_pred_class, Actual = y_true)
  
  # Calculate various metrics
  accuracy <- sum(diag(confusion_matrix)) / sum(confusion_matrix)
  sensitivity <- confusion_matrix[2, 2] / sum(confusion_matrix[2, ])
  specificity <- confusion_matrix[1, 1] / sum(confusion_matrix[1, ])
  false_discovery_rate <- confusion_matrix[2, 1] / sum(confusion_matrix[2, ])
  diagnostic_odds_ratio <- (sensitivity * specificity) / ((1 - sensitivity) * (1 - specificity))
  
  # Return all metrics as a list
  list(
    confusion_matrix = confusion_matrix,
    accuracy = accuracy,
    sensitivity = sensitivity,
    specificity = specificity,
    false_discovery_rate = false_discovery_rate,
    diagnostic_odds_ratio = diagnostic_odds_ratio
  )
}
