
shinyUI(fluidPage(
    
    titlePanel('US census'), 
    
    sidebarLayout(
        sidebarPanel(
            # selectInput('name', 'choose a name', 
            #             list(counties$name), selected = counties$name[1])
            textInput('name', 'input a name', value = 'alabama')
        ), 
        
        mainPanel(
            tableOutput('counties')
        )
    )
))