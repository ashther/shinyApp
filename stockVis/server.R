# server.R

library(quantmod)
source("helpers.R")

shinyServer(function(input, output) {
    
    data_rea <- reactive({
        getSymbols(input$symb, src = "yahoo",
                   from = input$dates[1],
                   to = input$dates[2],
                   auto.assign = FALSE)
        
        # if (input$adjust) {
        #     result <- adjust(result)
        # }
        # 
        # result
    })
    
    output$plot <- renderPlot({
        
        # data <- data_rea()
        # 
        # if (input$adjust) {
        #     data <- adjust(data)
        # }
        
    chartSeries(data_rea(), theme = chartTheme("white"), 
      type = "line", log.scale = input$log, TA = NULL)
  })
})
