
shinyUI(fluidPage(
    titlePanel('Wow! Face and emotion detectiong!'), 
    
    sidebarLayout(
        sidebarPanel(
            fileInput('img', 'choose a picture')
        ), 
        
        mainPanel(
            imageOutput('img_choose')
        )
    )
))