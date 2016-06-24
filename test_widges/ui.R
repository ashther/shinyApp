
library(plotly)
library(ggplot2)
shinyUI(fluidPage(
    numericInput('n', 'input', 10, min = 1, max = 100), 
    plotlyOutput('p')
))