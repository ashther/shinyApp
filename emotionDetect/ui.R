
library(dplyr)

shinyUI(fluidPage(
    titlePanel('wow, this is for you'), 
    
    sidebarLayout(
        sidebarPanel(
            fileInput('img', '选张照片吧')
        ), 
        
        mainPanel(
            imageOutput('img_choose'), 
            tableOutput('emotion_detect'), 
            tableOutput('face_detect')
        )
    )
))