
library(shiny)
library(shinydashboard)
library(ggplot2)

# source('dataSource.R')
source('dataGet.R')

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
              valueBoxOutput('total_user', width = 3), 
              valueBoxOutput('new_user_today', width = 3), 
              valueBoxOutput('active_user_today', width = 3), 
              valueBoxOutput('login_times_today', width = 3)
          ), 
          
          # 第二行，历史用户数据
          fluidRow(
              
              # 第二行第一列，历史数据图
              column(
                  width = 8, 
                  box(plotOutput('plot_login'), 
                      width = NULL, 
                      solidHeader = TRUE)
              ), 
              
              # 第二行第二列，绘图选项
              column(
                  width = 4, 
                  
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
                                     max = max(daily_login$date_time), 
                                     start = Sys.Date() - 1, 
                                     language = 'zh-CN'), 
                      width = NULL, 
                      solidHeader = TRUE)
              )
          ), 
          
          #第三行，日登陆频次统计
          fluidRow(
              
              # 第三行第一列，日登陆频次图
              column(
                  width = 8, 
                  box(plotOutput('plot_daily_freq'), 
                      width = NULL, 
                      solidHeader = TRUE)
              ), 
              
              # 第三行第二列，日登陆频次绘图选项
              column(
                  width = 4, 
                  
                  # 数据类型（暂时仅为日登陆频次）
                  box(selectInput('freq_data_type', 
                                  label = 'select data type', 
                                  choices = list('frequency' = 'freq'), 
                                  selected = 'freq'), 
                      width = NULL,
                      solidHeader = TRUE), 
                  
                  # 时间范围选项
                  box(dateRangeInput('freq_date_range', 
                                     label = 'select date range', 
                                     min = min(daily_login$date_time), 
                                     max = max(daily_login$date_time), 
                                     start = min(daily_login$date_time), 
                                     language = 'zh-CN'), 
                      width = NULL, 
                      solidHeader = TRUE), 
                  
                  # 绘图多选选项
                  box(checkboxGroupInput('freq_type', 
                                  label = 'select frequency type', 
                                  choices = list('50+' = 6, 
                                                 '>=20 & <50' = 7, 
                                                 '>=10 & <20' = 8,
                                                 '>=6 & <10' = 9,
                                                 '>=3 & <6' = 10,
                                                 '>=1 & <3' = 11), 
                                  selected = 11), 
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
    
    host <- '10.21.3.101'
    port <- 3306
    username <- 'r'
    password <- '123456'
    dbname <- 'daily'
    
    con <- dbConnect(MySQL(), host = host, port = port, 
                     username = username, password = password, 
                     dbname = dbname)
    dbSendQuery(con, 'set names gbk')
    
    # 刷新point_data
    point_data <- pointRefresh(Sys.time(), point_data, con)
    # 刷新hourly_login
    hourly_login <- hourlyRefresh(Sys.time(), hourly_login, con)
    
    dbDisconnect(con)
    
    # 登录数据筛选
    data_login_range <- reactive({
        switch(input$date_format, 
               'hourly' = subset(hourly_login, 
                                 as.Date(date_time) >= input$date_range[1] & 
                                     as.Date(date_time) <= input$date_range[2]), 
               
               'daily' = subset(daily_login, 
                                as.Date(date_time) >= input$date_range[1] & 
                                    as.Date(date_time) <= input$date_range[2]), 
               
               'weekly' = subset(weekly_login, 
                                 paste(format(date_time, '%Y'), 
                                       '-', 
                                       format(date_time, '%V')) >= 
                                     paste(format(input$date_range[1], '%Y'), 
                                           '-', 
                                           format(input$date_range[1], '%V')) & 
                                     paste(format(date_time, '%Y'), 
                                           '-', 
                                           format(date_time, '%V')) <= 
                                     paste(format(input$date_range[2], '%Y'), 
                                           '-', 
                                           format(input$date_range[2], '%V'))), 
               
               'monthly' = subset(monthly_login, 
                                  paste(format(date_time, '%Y'), 
                                        '-', 
                                        format(date_time, '%m')) >= 
                                      paste(format(input$date_range[1], '%Y'), 
                                            '-', 
                                            format(input$date_range[1], '%m')) & 
                                      paste(format(date_time, '%Y'), 
                                            '-', 
                                            format(date_time, '%m')) <= 
                                      paste(format(input$date_range[2], '%Y'), 
                                            '-', 
                                            format(input$date_range[2], '%m'))))
    })
    
    # 日登陆频次数据筛选
    data_freq_range <- reactive({
        switch(input$freq_data_type, 
               'freq' = subset(daily_login, 
                               as.Date(date_time) >= input$freq_date_range[1] & 
                                   as.Date(date_time) <= input$freq_date_range[2]) %>% 
                   select(c(1, as.integer(input$freq_type))) %>% 
                   gather(key = freq, value = user, -date_time))
    })
    
    # 累计用户数
    output$total_user <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'total_user'], 'total user')
    })
    # 当日新增用户数
    output$new_user_today <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'new_user'], 'new user')
    })
    # 当日活跃用户数
    output$active_user_today <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'active_user'], 'active user')
    })
    # 当日登陆次数
    output$login_times_today <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'login_times'], 'login')
    })
    
    # 登录数据绘图渲染
    output$plot_login <- renderPlot({
        ggplot(data_login_range(), 
               aes(date_time, 
                   get(input$data_type))) + 
            geom_bar(stat = 'identity')
    })
    
    # 日登陆频次数据绘图渲染
    output$plot_daily_freq <- renderPlot({
        ggplot(data_freq_range(), 
               aes(date_time, 
                   user, 
                   colour = freq, 
                   group = freq)) + 
            geom_line(size = 1.5) + 
            geom_point(size = 3, 
                       fill = 'white')
    })
}

shinyApp(ui, server)














