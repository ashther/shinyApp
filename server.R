
library(RMySQL)
library(dplyr)
library(ggplot2)

source('dataSource.R')

shinyServer(function(input, output) {
    output$daily_new <- renderPlot({
        # qplot(daily$date_time[(nrow(daily) - input$days):nrow(daily)], 
        #       daily$new[(nrow(daily) - input$days):nrow(daily)], 
        #       geom = 'bar', stat = 'identity')
        ggplot(daily[(nrow(daily) - input$days):nrow(daily), ], 
               aes(date_time, new)) + geom_bar(stat = 'identity')
    })
})