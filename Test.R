

devtools::load_all()

data <- read.csv("~/Documents/Fallclasses2024/STAT6210/FinalProject_Group3/expenses.csv")
head(data)
str(data)

# Create binary outcome variable: 1 if charges are above the median, 0 otherwise
median_charges <- median(data$charges)
data$high_charges <- ifelse(data$charges > median_charges, 1, 0)

# Convert categorical variables to numeric (factor -> numeric)
data$sex <- as.factor(data$sex)
data$smoker <- as.factor(data$smoker)
data$region <- as.factor(data$region)

# Convert the factors to numeric values for logistic regression
X <- data.frame(
  age = data$age,
  bmi = data$bmi,
  children = data$children,
  sex = as.numeric(data$sex),
  smoker = as.numeric(data$smoker),
  region = as.numeric(data$region)
)

# Outcome variable
y <- data$high_charges

# Convert X to matrix for logistic regression
X_matrix <- as.matrix(X)
dim(X_matrix)  # Should show 1338 rows and 6 columns
length(y)      # Should be 1338
logistic_result <- logistic_regression(X_matrix, y)

# Print the logistic regression result
print(logistic_result)

# Ensure that the logistic regression coefficients are in the correct format
logistic_result <- logistic_regression(X_matrix, y)

# Add the intercept column (constant 1) to the predictors matrix (X)
X_with_intercept <- cbind(1, X_matrix)

# Now calculate the predicted probabilities correctly
y_pred <- 1 / (1 + exp(-X_with_intercept %*% logistic_result$coefficients))

# Print the predicted probabilities
print(head(y_pred))  # Print first few predicted values to check

# Continue with the metrics and bootstrap calculations
metrics_result <- compute_metrics(y, y_pred)
print(metrics_result)

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

