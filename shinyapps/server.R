
source('Roxford.R')
library(dplyr)

emotionKey <- 'c755a0154b0f48bdb3b390dc8c098363'
faceKey <- '3b891b40472240b89f1cf6202cf0cbbb'

shinyServer(function(input, output, session) {
    output$img_choose <- renderImage({
        
        # width <- session$clientData$output_myImage_width
        width <- '100'
        # height <- session$clientData$output_myImage_height
        height <- '133'
        
        infile <- input$img
        
        if (is.null(infile)) {
            return(NULL)
        }
        
        list(src = infile$datapath,
             width = width, 
             height = height, 
             alt = 'test title')
    }, deleteFile = FALSE)
    
    output$emotion_detect <- renderTable({
        infile <- input$img
        
        getEmotionResponse(infile$datapath, emotionKey)
    })
    
    output$face_detect <- renderTable({
        infile <- input$img
        
        getFaceResponse(infile$datapath, faceKey)
    })
})