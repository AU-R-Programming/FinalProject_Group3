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
