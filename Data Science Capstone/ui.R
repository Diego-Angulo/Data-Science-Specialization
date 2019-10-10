### Data Science Capstone : Course Project
### ui.R file for the Shiny app
### Github repo : https://github.com/justusfrantz/capstone

suppressWarnings(library(shiny))
suppressWarnings(library(shinythemes))
suppressWarnings(library(markdown))

shinyUI(fluidPage(
    theme=shinytheme("darkly"),
    
                            # Application title
                            titlePanel("Predicting words from text inputs"),
                            h4("By Diego Angulo Quintana"),
    
                            # Sidebar
                              sidebarLayout(
                              sidebarPanel(
                                h2("Word inputs:"),  
                                textInput("inputString", "Your word/sentence here:",value = ""),
                                br()
                                ),
                              mainPanel(
                                  h3("Word Prediction"),
                                  textOutput("prediction")
                              )
                              )
                             
                  )
)