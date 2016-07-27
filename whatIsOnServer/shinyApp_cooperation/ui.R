
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
      
      menuItem('找合作', 
           tabName = 'cooperation', 
           icon = icon('github'))
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
        tabName = 'cooperation',
        
        fluidRow(
          tags$div(title = '所发布项目已过期的企业不纳入统计范围', 
               valueBoxOutput('cooperation_company', width = 3)), 
          tags$div(title = '已过期项目不纳入统计范围', 
               valueBoxOutput('cooperation_project', width = 3)),
          tags$div(title = '所有浏览、收藏或申请项目的用户均计作有效用户', 
               valueBoxOutput('cooperation_user', width = 3))
        ), 
        
        fluidRow(
          
          column(
            width = 8, 
            dygraphOutput('cooperation_plot')
          ), 
          
          # 第二行第二列，绘图选项
          column(
            width = 4, 
            
            # 小时/日/周/月选项
            uiOutput('cooperation_date_format_ui'), 
            
            # 数据类型选项
            uiOutput('cooperation_data_type_ui'), 
            
            # 时间范围选项
            uiOutput('calendar_date_range_ui'),
            
            uiOutput('help_text_ui')
          )
        )
      )
    )
  )
))