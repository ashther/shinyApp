
library(shinydashboard)
# library(ggplot2)
library(dygraphs)
library(xts)

source('dataSource.R')

shinyUI(dashboardPage(
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
                        box(dygraphOutput('plot_login'), 
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
                                                       'login' = 'log_in', 
                                                       'retention' = 'retention'), 
                                        selected = 'active'), 
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
                        box(dygraphOutput('plot_daily_freq'), 
                            width = NULL, 
                            solidHeader = TRUE)
                    ), 
                    
                    # 第三行第二列，日登陆频次绘图选项
                    column(
                        width = 4, 
                        
                        # 数据类型（暂时仅为日登陆频次）
                        box(selectInput('freq_data_type', 
                                        label = 'select data type', 
                                        choices = list('frequency' = 'daily_freq'), 
                                        selected = 'daily_freq'), 
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
                                               choices = list('50+' = '50', 
                                                              '>=20 & <50' = '20', 
                                                              '>=10 & <20' = '10',
                                                              '>=6 & <10' = '6',
                                                              '>=3 & <6' = '3',
                                                              '>=1 & <3' = '1'), 
                                               selected = '1'), 
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
))