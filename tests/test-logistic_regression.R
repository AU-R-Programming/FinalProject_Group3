
library(testthat)
library(binaryClassifier)  # Load your package

# Test logistic regression
test_that("logistic_regression returns valid coefficients", {
  # Example data
  X <- matrix(rnorm(100), ncol = 5)
  y <- sample(0:1, 20, replace = TRUE)
  
  # Run logistic regression
  logistic_result <- logistic_regression(X, y)
  
  # Test if the result contains coefficients
  expect_true(!any(is.na(logistic_result$coefficients)))
  expect_true(length(logistic_result$coefficients) > 0)
})

# Test metrics calculation
test_that("compute_metrics computes correct metrics", {
  X <- matrix(rnorm(100), ncol = 5)
  y <- sample(0:1, 20, replace = TRUE)
  
  logistic_result <- logistic_regression(X, y)
  y_pred <- 1 / (1 + exp(-cbind(1, X) %*% logistic_result$coefficients))
  
  metrics_result <- compute_metrics(y, y_pred)
  
  # Check confusion matrix
  expect_equal(nrow(metrics_result$confusion_matrix), 2)
  expect_equal(ncol(metrics_result$confusion_matrix), 2)
  
  # Test if accuracy is a valid number between 0 and 1
  expect_true(metrics_result$accuracy >= 0 && metrics_result$accuracy <= 1)
})

devtools::load_all()  # Load the package
testthat::test_dir("tests")  # Run all tests in the tests folder

