#' Perform Logistic Regression
#'
#' Estimates coefficients for logistic regression using numerical optimization 
#' to maximize the log-likelihood function.
#'
#' @param X A numeric matrix of predictors, including an optional intercept column.
#' @param y A binary numeric vector (0/1) of responses corresponding to rows in \code{X}.
#' @return A list with estimated coefficients, predicted probabilities, and log-likelihood.
#' @importFrom stats optim
#' @export
logistic_regression <- function(X, y) {
  X <- cbind(1, X)  # Add intercept column
  n <- nrow(X)
  p <- ncol(X)
  
  XtX <- t(X) %*% X
  XtY <- t(X) %*% y
  
  beta_init <- solve(XtX, XtY)
  
  log_likelihood <- function(beta) {
    linear_pred <- X %*% beta
    p <- 1 / (1 + exp(-linear_pred))
    -sum(y * log(p) + (1 - y) * log(1 - p))
  }
  
  opt <- optim(par = beta_init, fn = log_likelihood, method = "BFGS")
  beta <- opt$par
  
  list(coefficients = beta)
}