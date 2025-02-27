# app.R

# Libraries ----
library(shiny)
library(randomForest)

# Load the trained model from the .rds file ----
best_rf_model <- readRDS("best_rf_model.rds")

# Define UI for the app ----
ui <- fluidPage(
  titlePanel("Water Potability Prediction"),
  
  sidebarLayout(
    sidebarPanel(
      # Input fields for original dataset features
      numericInput("ph", "pH Level", value = 7.0, min = 0, max = 14),
      numericInput("Hardness", "Hardness", value = 150, min = 0, max = 400),
      numericInput("Solids", "Solids", value = 20000, min = 0, max = 60000),
      numericInput("Chloramines", "Chloramines", value = 7, min = 0, max = 15),
      numericInput("Sulphate", "Sulphate", value = 300, min = 0, max = 500),
      numericInput("Conductivity", "Conductivity", value = 500, min = 0, max = 800),
      numericInput("Organic_carbon", "Organic Carbon", value = 15, min = 0, max = 30),
      numericInput("Trihalomethanes", "Trihalomethanes", value = 60, min = 0, max = 120),
      numericInput("Turbidity", "Turbidity", value = 4, min = 0, max = 7),
      
      actionButton("predict", "Predict Potability")
    ),
    
    mainPanel(
      h3("Prediction Result"),
      verbatimTextOutput("prediction")
    )
  )
)

# Define server logic for predictions ----
server <- function(input, output) {
  observeEvent(input$predict, {
    # Collect input data into a data frame in original format
    input_data <- data.frame(
      ph = ifelse(is.na(input$ph), 7.0, input$ph),
      Hardness = ifelse(is.na(input$Hardness), 150, input$Hardness),
      Solids = ifelse(is.na(input$Solids), 20000, input$Solids),
      Chloramines = ifelse(is.na(input$Chloramines), 7, input$Chloramines),
      Sulphate = ifelse(is.na(input$Sulphate), 300, input$Sulphate),
      Conductivity = ifelse(is.na(input$Conductivity), 500, input$Conductivity),
      Organic_carbon = ifelse(is.na(input$Organic_carbon), 15, input$Organic_carbon),
      Trihalomethanes = ifelse(is.na(input$Trihalomethanes), 60, input$Trihalomethanes),
      Turbidity = ifelse(is.na(input$Turbidity), 4, input$Turbidity)
    )
    
    # Make prediction
    prediction <- predict(best_rf_model, input_data)
    
    # Display prediction result
    output$prediction <- renderText({
      if (prediction == 1) {
        "The water is potable."
      } else {
        "The water is not potable."
      }
    })
  })
}

# Run the application ----
shinyApp(ui = ui, server = server)
