
library(ggplot2)
library(RMySQL)
library(dplyr)
shinyUI(bootstrapPage(
    
    tags$link(rel = 'stylesheet', type = 'text/css', href = 'style.css'), 
    
    div(class = "login",
        uiOutput("uiLogin"),
        textOutput("pass")
    ),
    
    fluidRow(
        column(width = 1), 
        column(width = 3, 
               uiOutput('field_ui'), 
               uiOutput('date_ui'), 
               uiOutput('button_ui')
               ), 
        column(width = 8,
               uiOutput('head_n_ui'), 
               verbatimTextOutput('nrow'), 
               tableOutput('user_regist_table'), 
               uiOutput('download_ui'))
    )
    
))
