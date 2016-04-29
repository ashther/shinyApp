
shinyServer(function(input, output) {
    output$img_choose <- renderImage({
        infile <- input$img
        
        if (is.null(infile)) {
            return(NULL)
        }
        
        
    })
})