
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
      menuItem('找工作', 
           tabName = 'hr', 
           icon = icon('linkedin'))
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
        tabName = 'hr',
        
        fluidRow(
          tags$div(title = '求职用户：创建了求职意向的个人用户', 
               valueBoxOutput('jobseeker', width = 3)),
          tags$div(title = '招聘企业：通过了审核的企业用户', 
               valueBoxOutput('hr_company', width = 3)),
          tags$div(title = '招聘信息：未过期的招聘信息数', 
               valueBoxOutput('recruitment', width = 3))
        ), 
        
        fluidRow(
          
          column(
            width = 8, 
            dygraphOutput('hr_plot')
          ), 
          
          # 第二行第二列，绘图选项
          column(
            width = 4, 
            
            # 小时/日/周/月选项
            uiOutput('hr_date_format_ui'), 
            
            # 数据类型选项
            uiOutput('hr_data_type_ui'), 
            
            # 时间范围选项
            uiOutput('hr_date_range_ui'),
            
            uiOutput('help_text_ui')
          )
        )
      )
    )
  )
))