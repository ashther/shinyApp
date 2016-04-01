
library(dplyr)
library(maps)
library(mapproj)
source('test_US_census/helpers.R')
counties <- readRDS('e:/Git/shinyApp/test_US_census/data/counties.rds')

shinyServer(function(input, output) {
    
    selected <- reactive({
        counties[grepl(input$name, counties$name, fixed = TRUE), ] %>% 
            head()
    })
    
    output$counties <- renderTable({
        selected()
    })
})