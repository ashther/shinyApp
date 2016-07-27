
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
      menuItem('找培训', 
           tabName = 'train', 
           icon = icon('stack-overflow'))
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
        tabName = 'train',
        
        fluidRow(
          tags$div(title = '所发布的培训课程信息已过期的企业不纳入统计范围', 
               valueBoxOutput('train_company', width = 3)),
          tags$div(title = '已过期的培训课程信息不纳入统计范围', 
               valueBoxOutput('train_course', width = 3)),
          tags$div(title = '所有产生过浏览、收藏、申请等动作的用户', 
               valueBoxOutput('train_user', width = 3))
        ), 
        
        fluidRow(
          
          column(
            width = 8, 
            dygraphOutput('train_plot')
          ), 
          
          # 第二行第二列，绘图选项
          column(
            width = 4, 
            
            # 小时/日/周/月选项
            uiOutput('train_date_format_ui'), 
            
            # 数据类型选项
            uiOutput('train_data_type_ui'), 
            
            uiOutput('help_text_ui_1'), 
            
            # 时间范围选项
            uiOutput('train_date_range_ui'),
            
            uiOutput('help_text_ui_2')
          )
        )
      )
    )
  )
))