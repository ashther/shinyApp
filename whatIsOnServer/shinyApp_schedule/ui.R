
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
      menuItem('软课表', 
           tabName = 'schedule', 
           icon = icon('university'))
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
        tabName = 'schedule',
        
        fluidRow(
          tags$div(title = '由系统创建的课程不纳入统计范围', 
               valueBoxOutput('schedule_course', width = 3)),
          tags$div(title = '包括了各类视频课程文件', 
               valueBoxOutput('schedule_courseware', width = 3)),
          tags$div(title = '包括了个人用户上传的作业文件', 
               valueBoxOutput('schedule_homework', width = 3)),
          tags$div(title = '创建者导入的花名册中没有思扣账号的不纳入统计范围', 
               valueBoxOutput('avg_course_user', width = 3))
        ), 
        
        fluidRow(
          
          column(
            width = 8, 
            dygraphOutput('schedule_plot')
          ), 
          
          # 第二行第二列，绘图选项
          column(
            width = 4, 
            
            # 小时/日/周/月选项
            uiOutput('schedule_date_format_ui'), 
            
            # 数据类型选项
            uiOutput('schedule_data_type_ui'), 
            
            # 时间范围选项
            uiOutput('schedule_date_range_ui'),
            
            uiOutput('help_text_ui_1')
          )
        )
      )
    )
  )
))