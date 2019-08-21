library(shiny)
shinyUI(fluidPage(
    titlePanel("Linear Regression App"),
    sidebarLayout(
        sidebarPanel(
            h2("Regressors:"),
            sliderInput("sliderWeight", "1.- Car Weight (1000 lbs)", 1.5, 5.5, 1.5),
            sliderInput("sliderTime", "2.- 1/4 mile time (secs)", 14.00, 23.00, 14.00),
            radioButtons("radioAm","3.- Transmission:", choices = list("Automatic" =  "0", "Manual" = "1"))
        ),
        mainPanel(
            h2("Miles Per Gallon Prediction"),
            h3("Formula"),
            code("mpg ~ 9.6178 -3.91*wt + 1.22*qsec + 2.93*am"),
            
            p("This regression model explains the variability in the Miles Per Gallon outcome of a car (mpg), with the independent variables weight (wt), 1/4 mile time (qsec), and transmission (am)."),
            
            h3("Interpretation of the Coefficients in the Formula"),
            p("Holding 1/4 mile time and Transmission constant, as the weight of the car increases by 1 unit (1000 lbs), the miles per gallon, on an average, decreases by -3.9165 miles per gallon."),
            
            p("Holding Weight and Transmission constant, as the 1/4 mile time increases by 1 unit (1 second), the miles per gallon, on an average, increases by 1.2259 miles per gallon."),
            
            p("Holding Weight and 1/4 mile time constant, the manual transmission has on average 2.93 more miles per gallon compared to automatic transmission."),
            h3("Prediction"),
            textOutput("Prediction")
        )
    )
))
