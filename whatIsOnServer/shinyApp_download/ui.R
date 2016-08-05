
library(ggplot2)
library(RMySQL)
library(dplyr)
shinyUI(bootstrapPage(
    
    tags$link(rel = 'stylesheet', type = 'text/css', href = 'style.css'), 
    tags$style(type = 'text/css', '#helptext_ui {color: rgba(0, 0, 0, 0.3);}'), 
    
    div(class = "login",
        uiOutput("uiLogin"),
        textOutput("pass")
    ),
    
    fluidRow(
        column(width = 1), 
        column(width = 3, 
               # uiOutput('field_ui'), 
               uiOutput('company_university_ui'), 
               uiOutput('regist_time_ui'), 
               uiOutput('phone_field_ui'), 
               uiOutput('channel_ui'), 
               uiOutput('date_ui'), 
               uiOutput('button_ui'),
               htmlOutput('helptext_ui')
               ), 
        column(width = 8,
               dataTableOutput('user_regist_table'), 
               uiOutput('download_ui'))
    )
    
))
