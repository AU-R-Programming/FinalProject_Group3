#' Perform Logistic Regression
#'
#' Estimates coefficients for logistic regression using numerical optimization 
#' to maximize the log-likelihood function.
#'
#' @param X A numeric matrix of predictors, including an optional intercept column.
#' @param y A binary numeric vector (0/1) of responses corresponding to rows in \code{X}.
#' @return A list with estimated coefficients, predicted probabilities, and log-likelihood.
#' @export

logistic_regression <- function(X, y) {
  n <- nrow(X)
  p <- ncol(X)
  
  XtX <- matrix(0, p, p)
  for (i in 1:p) {
    for (j in 1:p) {
      XtX[i, j] <- sum(X[, i] * X[, j])
    }
  }
  
  XtY <- numeric(p)
  for (i in 1:p) {
    XtY[i] <- sum(X[, i] * y)
  }
  
  beta_init <- solve(XtX, XtY)
  
  log_likelihood <- function(beta) {
    linear_pred <- numeric(n)
    for (i in 1:n) {
      for (j in 1:p) {
        linear_pred[i] <- linear_pred[i] + X[i, j] * beta[j]
      }
    }
    p <- 1 / (1 + exp(-linear_pred))
    -sum(y * log(p) + (1 - y) * log(1 - p))
  }
  
  opt <- optim(par = beta_init, fn = log_likelihood, method = "BFGS")
  beta <- opt$par
  linear_pred <- numeric(n)
  for (i in 1:n) {
    for (j in 1:p) {
      linear_pred[i] <- linear_pred[i] + X[i, j] * beta[j]
    }
  }
  p <- 1 / (1 + exp(-linear_pred))
  
  list(coefficients = beta, probabilities = p, log_likelihood = -opt$value)
}


### Sources

<https://chatgpt.com/share/674ce00f-c60c-800c-bced-b59ec7e60786>
