
library(shinydashboard)
library(dygraphs)
library(xts)
library(ggplot2)
library(plotly)

source('dataSource.R')

shinyUI(dashboardPage(
  skin = 'black', 
  
  dashboardHeader(title = '数据分析'), 
  
  dashboardSidebar(
    
    sidebarMenu(
      
      menuItem('快信', 
           tabName = 'quick_chat', 
           icon = icon('weixin'))
    )
  ),
  
  dashboardBody(
    
    fluidRow(
      column(width = 3), 
      column(width = 4, 
           div(class = "login",
             uiOutput("uiLogin"),
             textOutput("pass")
           ))
    ),
    
    tabItems(
      
      tabItem(
        tabName = 'quick_chat',
        
        fluidRow(
          tags$div(title = '包括了主动圈与课程圈等所有类型的圈子', 
               valueBoxOutput('quick_chat_circle', width = 3)), 
          tags$div(title = '各圈子的平均成员数量', 
               valueBoxOutput('avg_circle_user', width = 3))
        ), 
        
        br(), 
        br(),
        
        fluidRow(
          
          column(
            width = 8, 
            dygraphOutput('quick_chat_plot')
          ), 
          
          # 第二行第二列，绘图选项
          column(
            width = 4, 
            
            # 小时/日/周/月选项
            uiOutput('quick_chat_date_format_ui'), 
            
            # 数据类型选项
            uiOutput('quick_chat_data_type_ui'), 
            
            # 时间范围选项
            uiOutput('quick_chat_date_range_ui'),
            
            uiOutput('help_text_ui_1')
          )
        ), 
        
        br(), 
        
        fluidRow(
          uiOutput('help_text_ui_2')
        )
      )
    )
  )
))