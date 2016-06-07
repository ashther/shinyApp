
library(ggplot2)

shinyUI(bootstrapPage(
    
    tags$link(rel = 'stylesheet', type = 'text/css', href = 'style.css'), 
    
    div(class = "login",
        uiOutput("uiLogin"),
        textOutput("pass")
    ),
    
    fluidRow(
        column(3, uiOutput('field'), 
               uiOutput('date')), 
        column(9, tableOutput('user_regist_table'))
    )
    
))