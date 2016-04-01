
shinyServer(function(input, output) {
    
    select_reactive <- reactive({
        list(select = input$select)
    })
    
    slider_reactive <- reactive({
        list(min_slider = min(input$slider), 
             max_slider = max(input$slider))
    })
    
    output$text_1 <- renderText({
        sprintf('%s: You have selected %s', 
                as.character(Sys.time()), 
                select_reactive()$select)
    })
    
    output$text_2 <- renderText({
        sprintf('%s: You have chosen a range that goes from %s to %s', 
                as.character(Sys.time()), 
                slider_reactive()$min_slider, 
                slider_reactive()$max_slider)
    })
})