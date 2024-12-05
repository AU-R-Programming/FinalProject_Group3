library(shiny)
library(binaryClassifier)

# Define UI
ui <- fluidPage(
  titlePanel("Generalized Binary Classifier"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("datafile", "Upload Data (CSV)", accept = ".csv"),
      uiOutput("columnSelectors"), # Dynamically generated selectors for columns
      numericInput("lambda", "Lambda (regularization):", value = 1e-5, step = 1e-5),
      numericInput("n_boot", "Bootstrap Samples:", value = 20, min = 1),
      numericInput("threshold", "Classification Threshold:", value = 0.5, min = 0, max = 1, step = 0.01),
      actionButton("runBtn", "Run Analysis")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Logistic Regression Coefficients", tableOutput("coefficients")),
        tabPanel("Confidence Intervals", tableOutput("ci")),
        tabPanel("Metrics", verbatimTextOutput("metrics"))
      )
    )
  )
)

# Define server logic
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
  
  processedData <- reactive({
    req(data(), input$responseCol, input$predictorCols)
    df <- data()
    
    # Select predictors
    predictors <- df[, input$predictorCols, drop = FALSE]
    
    # Convert non-numeric predictors to dummy variables
    numeric_cols <- sapply(predictors, is.numeric)
    if (!all(numeric_cols)) {
      non_numeric_predictors <- predictors[, !numeric_cols, drop = FALSE]
      numeric_predictors <- predictors[, numeric_cols, drop = FALSE]
      
      dummy_vars <- model.matrix(~ . - 1, data = non_numeric_predictors)  # One-hot encode non-numeric
      predictors <- cbind(numeric_predictors, dummy_vars)  # Combine numeric and dummy predictors
    }
    
    # Add intercept term
    x <- cbind(1, as.matrix(predictors))
    
    # Ensure response variable is numeric
    y <- as.numeric(df[[input$responseCol]])
    
    # Check for NA values
    if (anyNA(x) || anyNA(y)) {
      stop("Predictors or response contain NA values. Please clean your data.")
    }
    
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

# Run the application
shinyApp(ui = ui, server = server)