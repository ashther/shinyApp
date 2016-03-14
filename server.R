
# This is the server logic for a Shiny web application.

library(datasets)

mpgData <- mtcars
mpgData$am <- factor(mpgData$am, labels = c('Automatic', 'Manual'))

shinyServer(function(input, output) {
    
    # 反应表达式
    testText <- reactive(
        paste('mpg ~ ', input$variable)
    )
    
    # 反应表达式
    testSlier <- reactive(
        data.frame(item = c('min', 'max', 'avg', 'median'), 
                   value = c(min(input$test_slider_input), 
                             max(input$test_slider_input), 
                             mean(input$test_slider_input), 
                             median(input$test_slider_input)), 
                   stringsAsFactors = FALSE)
    )
    
    output$caption <- renderText({
        testText()
    })
    
    output$mpgPlot <- renderPlot({
        boxplot(as.formula(testText()), 
                data = mpgData, 
                outline = input$outliers)
    })
    
    output$test_slider_output <- renderTable({
        testSlier()
    })
})