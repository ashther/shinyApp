
library(dplyr)

shinyUI(fluidPage(
    titlePanel('wow, this is for you'), 
    
    sidebarLayout(
        sidebarPanel(
            fileInput('img', 'choose a picture')
        ), 
        
        mainPanel(
            imageOutput('img_choose'), 
            tableOutput('emotion_detect'), 
            tableOutput('face_detect')
        )
    )
))