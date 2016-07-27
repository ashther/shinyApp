
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
      
      menuItem('勤务表', 
           tabName = 'calendar', 
           icon = icon('calendar'))
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
        tabName = 'calendar',
        
        fluidRow(
          tags$div(title = '已结束的活动不纳入统计范围', 
               valueBoxOutput('calendar_activity', width = 3)), 
          tags$div(title = '已结束的活动不纳入统计范围', 
               valueBoxOutput('avg_activity_user', width = 3)) 
        ), 
        
        fluidRow(
          
          column(
            width = 8, 
            dygraphOutput('calendar_plot')
          ), 
          
          # 第二行第二列，绘图选项
          column(
            width = 4, 
            
            # 小时/日/周/月选项
            uiOutput('calendar_date_format_ui'), 
            
            # 数据类型选项
            uiOutput('calendar_data_type_ui'), 
            
            # 时间范围选项
            uiOutput('calendar_date_range_ui'),
            
            uiOutput('help_text_ui')
          )
        )
      )
    )
  )
))