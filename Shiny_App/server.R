library(shiny)
library(binaryClassifier)

server <- function(input, output, session) {
  # Reactive to read uploaded data
  data <- reactive({
    req(input$datafile)
    read.csv(input$datafile$datapath)
  })
  
  # Generate UI for column selection
  output$columnSelectors <- renderUI({
    req(data())
    df <- data()
    colnames <- names(df)
    
    tagList(
      selectInput("responseCol", "Select Response Variable:", choices = colnames),
      selectizeInput("predictorCols", "Select Predictor Variables:", choices = colnames, multiple = TRUE)
    )
  })
  
  # Reactive for processed data
  processedData <- reactive({
    req(data(), input$responseCol, input$predictorCols)
    df <- data()
    
    # Extract selected predictors and response
    x <- as.matrix(df[, input$predictorCols, drop = FALSE])
    x <- cbind(1, x)  # Add intercept
    y <- df[[input$responseCol]]
    
    list(x = x, y = y)
  })
  
  # Reactive for logistic regression coefficients
  coefficients <- reactive({
    req(input$runBtn)
    isolate({
      dat <- processedData()
      logistic_regression(dat$x, dat$y, lambda = input$lambda)
    })
  })
  
  # Reactive for confidence intervals
  ci <- reactive({
    req(input$runBtn)
    isolate({
      dat <- processedData()
      bootstrap_ci(dat$x, dat$y, n_boot = input$n_boot)
    })
  })
  
  # Reactive for metrics
  metrics <- reactive({
    req(input$runBtn)
    isolate({
      dat <- processedData()
      log_reg <- coefficients()
      y_pred <- exp(dat$x %*% log_reg) / (1 + exp(dat$x %*% log_reg))
      compute_metrics(dat$y, y_pred, threshold = input$threshold)
    })
  })
  
  # Output rendering
  output$coefficients <- renderTable({
    req(coefficients())
    as.data.frame(coefficients())
  })
  
  output$ci <- renderTable({
    req(ci())
    as.data.frame(ci())
  })
  
  output$metrics <- renderPrint({
    req(metrics())
    metrics()
  })
}