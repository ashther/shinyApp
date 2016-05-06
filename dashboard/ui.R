

library(shinydashboard)
library(dygraphs)
library(xts)
# library(leaflet)
# library(ggplot2)
# library(plotly)

source('dataSource.R')

shinyUI(dashboardPage(
    
    dashboardHeader(), 
    
    dashboardSidebar(
        
    ),
    
    dashboardBody(
        fluidRow(
            valueBoxOutput('total_user', width = 3), 
            valueBoxOutput('new_user_today', width = 3), 
            valueBoxOutput('active_user_today', width = 3), 
            valueBoxOutput('login_times_today', width = 3)
        ), 
        
        fluidRow(
            # column(width = 4, box(dygraphOutput('hourly_new'), width = NULL, solidHeader = TRUE)), 
            # column(width = 4, box(dygraphOutput('hourly_active'), width = NULL, solidHeader = TRUE)), 
            # column(width = 4, box(dygraphOutput('hourly_login'), width = NULL, solidHeader = TRUE))
            
            box(dygraphOutput('hourly_new'), width = NULL, solidHeader = TRUE), 
            box(dygraphOutput('hourly_active'), width = NULL, solidHeader = TRUE), 
            box(dygraphOutput('hourly_login'), width = NULL, solidHeader = TRUE)
        )
    )
))