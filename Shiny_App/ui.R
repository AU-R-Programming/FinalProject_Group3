library(shiny)

ui <- fluidPage(
  titlePanel("Generalized Binary Classifier"),
  sidebarLayout(
    sidebarPanel(
      fileInput("datafile", "Upload Data (CSV)", accept = ".csv"),
      uiOutput("columnSelectors"), # Dynamically generated selectors
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