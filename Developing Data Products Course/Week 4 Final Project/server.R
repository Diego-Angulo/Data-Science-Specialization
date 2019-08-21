#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
shinyServer(function(input, output) {
    
    model1 <- lm(formula = mpg ~ wt + qsec + am, data = mtcars)
    
    Model_Prediction <- reactive({
        WeightInput <- input$sliderWeight
        TimeInput <- input$sliderTime
        TransInput <- as.numeric(input$radioAm)
        
        predict(model1, newdata = data.frame(wt = WeightInput, qsec = TimeInput, am = TransInput))
    })
    
    output$Prediction <- renderText({
        Model_Prediction()
    })
})
