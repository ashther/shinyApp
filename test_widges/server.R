
shinyServer(function(input, output) {
    
    output$p <- renderPlotly({
        ggplotly(ggplot(mtcars, aes(mpg)) + 
                     geom_histogram() + 
                     xlab('测试'))
    })
})