#' Perform Logistic Regression
#'
#' Estimates coefficients for logistic regression using numerical optimization 
#' to maximize the log-likelihood function.
#'
#' @param X A numeric matrix of predictors, including an optional intercept column.
#' @param y A binary numeric vector (0/1) of responses corresponding to rows in \code{X}.
#' @param lambda A small constant for ridge regularization to stabilize matrix inversion 
#' (default is \code{1e-5}).
#' @return A numeric vector of estimated coefficients.
#' @importFrom stats optim
#' @export

logistic_regression <- function(X, y, lambda = 1e-5) {
  # Regularized initial values for stability
  beta_init <- solve(t(X) %*% X + diag(lambda, ncol(X))) %*% t(X) %*% y
  
  # Log-likelihood function
  log_likelihood <- function(beta) {
    # Compute predicted probabilities
    linear_predictor <- X %*% beta
    p <- 1 / (1 + exp(-linear_predictor))
    
    # Prevent log(0) with a small constant
    epsilon <- 1e-8
    p <- pmax(pmin(p, 1 - epsilon), epsilon)
    
    # Negative log-likelihood with L2 regularization
    -sum(y * log(p) + (1 - y) * log(1 - p)) + lambda * sum(beta^2)
  }
  
  # Perform optimization
  opt <- optim(
    par = beta_init,               # Initial parameter estimates
    fn = log_likelihood,           # Function to minimize
    method = "L-BFGS-B",           # Optimization method
    control = list(maxit = 1000)   # Maximum iterations
  )
  
  # Return optimized parameters
  return(opt$par)
}
  

