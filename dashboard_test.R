
library(shiny)
library(shinydashboard)
library(ggplot2)

# source('dataSource.R')

ui <- dashboardPage(
  skin = 'black', 
  
  dashboardHeader(title = 'data analysis'), 
  
  dashboardSidebar(

    sidebarMenu(
      menuItem('Login', 
               tabName = 'login', 
               icon = icon('dashboard')),
      menuItem('Quick_chat', 
               tabName = 'quick_chat', 
               icon = icon('th'))
    )
  ),
  
  dashboardBody(
      
    tabItems(

      tabItem(
          tabName = 'login',
          
          # 第一行，实时用户数据
          fluidRow(
              valueBoxOutput('total_user'), 
              valueBoxOutput('new_user_today'), 
              valueBoxOutput('active_user_today')
          ), 
          
          # 第二行，历史用户数据
          fluidRow(
              
              # 第二行第一列，历史数据图
              column(
                  width = 7, 
                  box(plotOutput('plot_login'), 
                      width = NULL, 
                      solidHeader = TRUE)
              ), 
              
              # 第二行第二列，绘图选项
              column(
                  width = 5, 
                  
                  # 小时/日/周/月选项
                  box(selectInput('date_format', 
                                  label = 'select time format', 
                                  choices = list('hourly' = 'hourly', 
                                                 'daily' = 'daily', 
                                                 'weekly' = 'weekly', 
                                                 'monthly' = 'monthly'), 
                                  selected = 'hourly'), 
                      width = NULL, 
                      solidHeader = TRUE), 
                  
                  # 数据类型选项
                  box(selectInput('data_type', 
                                  label = 'select data type', 
                                  choices = list('new' = 'new', 
                                                 'active' = 'active', 
                                                 'login' = 'login', 
                                                 'retention' = 'retention'), 
                                  selected = 'new'), 
                      width = NULL, 
                      solidHeader = TRUE), 
                  
                  # 时间范围选项
                  box(dateRangeInput('date_range', 
                                     label = 'select date range', 
                                     min = min(daily_login$date_time), 
                                     language = 'zh-CN'), 
                      width = NULL, 
                      solidHeader = TRUE)
              )
          )
      ),

      tabItem(
          tabName = 'quick_chat',
          h2('quick_chat')
      )
    )
  )
)

server <- function(input, output) {
    
    data_login <- reactive({
        get(paste0(input$date_format, '_login'))
    })
    
    data_login_range <- reactive({
        subset(data_login(), 
               as.Date(date_time) >= input$date_range[1] & 
                   as.Date(date_time) <= input$date_range[2])
    })
    
    output$total_user <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'total_user'], 'total user')
    })
    
    output$new_user_today <- renderValueBox({
        valueBox(daily_login$new[daily_login$date_time == (Sys.Date() - 1)], 'new user')
    })
    
    output$active_user_today <- renderValueBox({
        valueBox(daily_login$active[daily_login$date_time == (Sys.Date() - 1)], 'active user')
    })
    
    output$plot_login <- renderPlot({
        ggplot(data_login_range(), 
               aes(date_time, 
                   get(input$data_type))) + 
            geom_bar(stat = 'identity')
    })
}

shinyApp(ui, server)



















