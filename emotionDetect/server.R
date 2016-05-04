
source('Roxford.R')
if (!require(dplyr)) {
    install.packages('dplyr')
    require(dplyr)
}

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
        
        temp <- getEmotionResponse(infile$datapath, emotionKey) %>% 
            select('愤怒' = scores.anger, 
                   '轻蔑' = scores.contempt, 
                   '厌恶' = scores.disgust, 
                   '恐惧' = scores.fear, 
                   '喜悦' = scores.happiness, 
                   '无表情' = scores.neutral, 
                   '悲伤' = scores.sadness, 
                   '惊讶' = scores.surprise) %>% 
            t()
        
        temp <- data.frame(emotion = rownames(temp), percent = temp, row.names = NULL, stringsAsFactors = FALSE)
        
        return(iconv(cbind(表情 = temp[, 1], 百分比 = round(temp[, 2] / sum(temp[, 2]) * 100, 2)), from = 'utf-8'))
    })
    
    output$face_detect <- renderTable({
        infile <- input$img
        
        temp <- getFaceResponse(infile$datapath, faceKey) %>% 
            select('微笑特征' = faceAttributes.smile, 
                   '年龄' = faceAttributes.age) %>% 
            t()
    })
})