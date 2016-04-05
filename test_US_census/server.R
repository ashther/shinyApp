
library(dplyr)
library(maps)
library(mapproj)
source('e:/Git/shinyApp/test_US_census/helpers.R')
counties <- readRDS('e:/Git/shinyApp/test_US_census/data/counties.rds')

shinyServer(function(input, output) {
    
    var_rea <- reactive({
        switch(input$var,
            'Percent White' = counties$white, 
            'Percent Black' = counties$black, 
            'Percent Hispanic' = counties$hispanic,
            'Percent Asian' = counties$asian
        )
    })
    
    color_rea <- reactive({
        switch(input$var,
               'Percent White' = 'darkgreen', 
               'Percent Black' = 'black', 
               'Percent Hispanic' = 'darkorange',
               'Percent Asian' = 'darkviolet'
        )
    })
    
    output$map <- renderPlot({
        percent_map(var_rea(), color_rea(), input$var, input$range[1], input$range[2])
    })
})