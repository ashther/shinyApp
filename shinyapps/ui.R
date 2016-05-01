
shinyUI(fluidPage(
    titlePanel('诶 这不是小主么'), 
    
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