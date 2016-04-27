
library(shinydashboard)
library(dygraphs)
library(xts)
library(leaflet)

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
                     icon = icon('weixin')), 
            menuItem('calendar', 
                     tabName = 'calendar', 
                     icon = icon('calendar')), 
            menuItem('cooperation', 
                     tabName = 'cooperation', 
                     icon = icon('github')), 
            menuItem('hr', 
                     tabName = 'hr', 
                     icon = icon('linkedin')), 
            menuItem('schedule', 
                     tabName = 'schedule', 
                     icon = icon('university')), 
            menuItem('trade', 
                     tabName = 'trade', 
                     icon = icon('rmb')), 
            menuItem('train', 
                     tabName = 'train', 
                     icon = icon('stack-overflow'))
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
                        box(dygraphOutput('login_plot_1'), 
                            width = NULL, 
                            solidHeader = TRUE)
                    ), 
                    
                    # 第二行第二列，绘图选项
                    column(
                        width = 4, 
                        
                        # 小时/日/周/月选项
                        box(selectInput('login_date_format', 
                                        label = 'select time format', 
                                        choices = list('hourly' = 'hourly', 
                                                       'daily' = 'daily', 
                                                       'weekly' = 'weekly', 
                                                       'monthly' = 'monthly'), 
                                        selected = 'hourly'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 数据类型选项
                        box(selectInput('login_data_type', 
                                        label = 'select data type', 
                                        choices = list('new' = 'new',
                                                       'active' = 'active', 
                                                       'login' = 'log_in', 
                                                       'retention' = 'retention'), 
                                        selected = 'active'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 时间范围选项
                        box(dateRangeInput('login_date_range', 
                                           label = 'select date range', 
                                           min = min(daily_login$date_time), 
                                           max = max(daily_login$date_time), 
                                           start = Sys.Date() - 1, 
                                           language = 'zh-CN'), 
                            width = NULL, 
                            solidHeader = TRUE),
                        
                        helpText(paste0('NOTE: when date format is weekly/monthly, ', 
                                        'the plot begins at the first weekday/monthday and ', 
                                        'ends at the last weekday/monthday of date range selected, ', 
                                        'and \'2016-04-11\' means the week between 2016.4.11 to 2016.4.18, ', 
                                        '\'2016-04-01\' means the month between 2016.4.1 to 2016.4.30.' ))
                    )
                ), 
                
                #第三行，日登陆频次统计
                fluidRow(
                    
                    # 第三行第一列，日登陆频次图
                    column(
                        width = 8, 
                        box(dygraphOutput('login_plot_2'), 
                            width = NULL, 
                            solidHeader = TRUE)
                    ), 
                    
                    # 第三行第二列，日登陆频次绘图选项
                    column(
                        width = 4, 
                        
                        # 数据类型（暂时仅为日登陆频次）
                        box(selectInput('login_data_type_freq', 
                                        label = 'select data type', 
                                        choices = list('frequency' = 'daily_freq'), 
                                        selected = 'daily_freq'), 
                            width = NULL,
                            solidHeader = TRUE), 
                        
                        # 时间范围选项
                        box(dateRangeInput('login_date_range_freq', 
                                           label = 'select date range', 
                                           min = min(daily_login$date_time), 
                                           max = max(daily_login$date_time), 
                                           start = min(daily_login$date_time), 
                                           language = 'zh-CN'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 绘图多选选项
                        box(checkboxGroupInput('login_freq_type', 
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
                ), 
                
                #第四行，地图
                fluidRow(
                    
                    # 第四行第一列，地图
                    column(
                        width = 8, 
                        box(leafletOutput('user_location'), 
                            width = NULL, 
                            solidHeader = TRUE)
                    ), 
                    
                    # 第四行第二列，地图选项
                    column(
                        width = 4, 
                        
                        # 省份选项
                        box(selectInput('province', 
                                        'select a province', 
                                        choices = province_with_quote %>% 
                                            paste0(., '=', .) %>% 
                                            paste(collapse = ',') %>% 
                                            sprintf('list(%s)', .) %>% 
                                            parse(text = .) %>% 
                                            eval(), 
                                        selected = '陕西省'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 城市选项
                        box(selectInput('city', 
                                        'select a city', 
                                        choices = list('西安市' = '西安市'), 
                                        selected = '西安市'), 
                            width = NULL, 
                            solidHeader = TRUE)
                    )
                )
            ),
            
            tabItem(
                tabName = 'quick_chat',
                
                # # test
                # fluidRow(column(
                #     width = 4,
                #     valueBox('red', 'red', color = 'red', width = NULL), 
                #     valueBox('yellow', 'yellow', color = 'yellow', width = NULL),
                #     valueBox('aqua', 'aqua', color = 'aqua', width = NULL), 
                #     valueBox('blue', 'blue', color = 'blue', width = NULL),
                #     valueBox('light-blue', 'light-blue', color = 'light-blue', width = NULL), 
                #     valueBox('green', 'green', color = 'green', width = NULL),
                #     valueBox('navy', 'navy', color = 'navy', width = NULL), 
                #     valueBox('teal', 'teal', color = 'teal', width = NULL),
                #     valueBox('olive', 'olive', color = 'olive', width = NULL), 
                #     valueBox('lime', 'lime', color = 'lime', width = NULL),
                #     valueBox('orange', 'orange', color = 'orange', width = NULL), 
                #     valueBox('fuchsia', 'fuchsia', color = 'fuchsia', width = NULL),
                #     valueBox('purple', 'purple', color = 'purple', width = NULL), 
                #     valueBox('maroon', 'maroon', color = 'maroon', width = NULL),
                #     valueBox('black', 'black', color = 'black', width = NULL)
                # )), 
                
                fluidRow(
                    valueBoxOutput('quick_chat_circle', width = 3), 
                    valueBoxOutput('avg_circle_user', width = 3)
                ), 
                
                fluidRow(
                    
                    column(
                        width = 8, 
                        box(dygraphOutput('quick_chat_plot'), 
                            width = NULL, 
                            solidHeader = TRUE)
                    ), 
                    
                    # 第二行第二列，绘图选项
                    column(
                        width = 4, 
                        
                        # 小时/日/周/月选项
                        box(selectInput('quick_chat_date_format', 
                                        label = 'select time format', 
                                        choices = list('hourly' = 'hourly', 
                                                       'daily' = 'daily', 
                                                       'weekly' = 'weekly', 
                                                       'monthly' = 'monthly'), 
                                        selected = 'hourly'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 数据类型选项
                        box(selectInput('quick_chat_data_type', 
                                        label = 'select data type', 
                                        choices = list('active cirle' = 'active_circle', 
                                                       'message' = 'message', 
                                                       'active user' = 'active_user'), 
                                        selected = 'message'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 时间范围选项
                        box(dateRangeInput('quick_chat_date_range', 
                                           label = 'select date range', 
                                           min = min(daily_login$date_time), 
                                           max = max(daily_login$date_time), 
                                           start = min(daily_login$date_time), 
                                           language = 'zh-CN'), 
                            width = NULL, 
                            solidHeader = TRUE),
                        
                        helpText(paste0('NOTE: when date format is weekly/monthly, ', 
                                        'the plot begins at the first weekday/monthday and ', 
                                        'ends at the last weekday/monthday of date range selected, ', 
                                        'and \'2016-04-11\' means the week between 2016.4.11 to 2016.4.18, ', 
                                        '\'2016-04-01\' means the month between 2016.4.1 to 2016.4.30.' ))
                    )
                )
            ), 
            
            tabItem(
                tabName = 'calendar',
                
                fluidRow(
                    valueBoxOutput('calendar_activity', width = 3), 
                    valueBoxOutput('avg_activity_user', width = 3)
                ), 
                
                fluidRow(
                    
                    column(
                        width = 8, 
                        box(dygraphOutput('calendar_plot'), 
                            width = NULL, 
                            solidHeader = TRUE)
                    ), 
                    
                    # 第二行第二列，绘图选项
                    column(
                        width = 4, 
                        
                        # 小时/日/周/月选项
                        box(selectInput('calendar_date_format', 
                                        label = 'select time format', 
                                        choices = list('hourly' = 'hourly', 
                                                       'daily' = 'daily', 
                                                       'weekly' = 'weekly', 
                                                       'monthly' = 'monthly'), 
                                        selected = 'daily'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 数据类型选项
                        box(selectInput('calendar_data_type', 
                                        label = 'select data type', 
                                        choices = list('new activity' = 'new_activity', 
                                                       'new user' = 'new_user'), 
                                        selected = 'new_user'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 时间范围选项
                        box(dateRangeInput('calendar_date_range', 
                                           label = 'select date range', 
                                           min = min(daily_login$date_time), 
                                           max = max(daily_login$date_time), 
                                           start = min(daily_login$date_time), 
                                           language = 'zh-CN'), 
                            width = NULL, 
                            solidHeader = TRUE),
                        
                        helpText(paste0('NOTE: when date format is weekly/monthly, ', 
                                        'the plot begins at the first weekday/monthday and ', 
                                        'ends at the last weekday/monthday of date range selected, ', 
                                        'and \'2016-04-11\' means the week between 2016.4.11 to 2016.4.18, ', 
                                        '\'2016-04-01\' means the month between 2016.4.1 to 2016.4.30.' ))
                    )
                )
            ), 
            
            tabItem(
                tabName = 'cooperation',
                
                fluidRow(
                    valueBoxOutput('cooperation_company', width = 3), 
                    valueBoxOutput('cooperation_project', width = 3), 
                    valueBoxOutput('cooperation_user', width = 3)
                ), 
                
                fluidRow(
                    
                    column(
                        width = 8, 
                        box(dygraphOutput('cooperation_plot'), 
                            width = NULL, 
                            solidHeader = TRUE)
                    ), 
                    
                    # 第二行第二列，绘图选项
                    column(
                        width = 4, 
                        
                        # 小时/日/周/月选项
                        box(selectInput('cooperation_date_format', 
                                        label = 'select time format', 
                                        choices = list('hourly' = 'hourly', 
                                                       'daily' = 'daily', 
                                                       'weekly' = 'weekly', 
                                                       'monthly' = 'monthly'), 
                                        selected = 'daily'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 数据类型选项
                        box(selectInput('cooperation_data_type', 
                                        label = 'select data type', 
                                        choices = list('new company' = 'new_company',
                                                       'new project' = 'new_project', 
                                                       'active user' = 'active_user', 
                                                       'new view' = 'new_view', 
                                                       'new collect' = 'new_collect', 
                                                       'new apply' = 'new_apply'), 
                                        selected = 'active_user'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 时间范围选项
                        box(dateRangeInput('calendar_date_range', 
                                           label = 'select date range', 
                                           min = min(daily_login$date_time), 
                                           max = max(daily_login$date_time), 
                                           start = min(daily_login$date_time), 
                                           language = 'zh-CN'), 
                            width = NULL, 
                            solidHeader = TRUE),
                        
                        helpText(paste0('NOTE: when date format is weekly/monthly, ', 
                                        'the plot begins at the first weekday/monthday and ', 
                                        'ends at the last weekday/monthday of date range selected, ', 
                                        'and \'2016-04-11\' means the week between 2016.4.11 to 2016.4.18, ', 
                                        '\'2016-04-01\' means the month between 2016.4.1 to 2016.4.30.' ))
                    )
                )
            ), 
            
            tabItem(
                tabName = 'hr',
                
                fluidRow(
                    valueBoxOutput('jobseeker', width = 3), 
                    valueBoxOutput('hr_company', width = 3), 
                    valueBoxOutput('recruitment', width = 3)
                ), 
                
                fluidRow(
                    
                    column(
                        width = 8, 
                        box(dygraphOutput('hr_plot'), 
                            width = NULL, 
                            solidHeader = TRUE)
                    ), 
                    
                    # 第二行第二列，绘图选项
                    column(
                        width = 4, 
                        
                        # 小时/日/周/月选项
                        box(selectInput('hr_date_format', 
                                        label = 'select time format', 
                                        choices = list('hourly' = 'hourly', 
                                                       'daily' = 'daily', 
                                                       'weekly' = 'weekly', 
                                                       'monthly' = 'monthly'), 
                                        selected = 'daily'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 数据类型选项
                        box(selectInput('hr_data_type', 
                                        label = 'select data type', 
                                        choices = list('new user' = 'new_user', 
                                                       'new company' = 'new_company', 
                                                       'new recruitment' = 'new_recruitment', 
                                                       'update recruitment' = 'update_recruitment', 
                                                       'jobseekers operation' = 'jobseekers_operation', 
                                                       'hr operation' = 'hr_operation'), 
                                        selected = 'new_user'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 时间范围选项
                        box(dateRangeInput('hr_date_range', 
                                           label = 'select date range', 
                                           min = min(daily_login$date_time), 
                                           max = max(daily_login$date_time), 
                                           start = min(daily_login$date_time), 
                                           language = 'zh-CN'), 
                            width = NULL, 
                            solidHeader = TRUE),
                        
                        helpText(paste0('NOTE: when date format is weekly/monthly, ', 
                                        'the plot begins at the first weekday/monthday and ', 
                                        'ends at the last weekday/monthday of date range selected, ', 
                                        'and \'2016-04-11\' means the week between 2016.4.11 to 2016.4.18, ', 
                                        '\'2016-04-01\' means the month between 2016.4.1 to 2016.4.30.' ))
                    )
                )
            ), 
            
            tabItem(
                tabName = 'schedule',
                
                fluidRow(
                    valueBoxOutput('schedule_course', width = 3), 
                    valueBoxOutput('upload_course_file', width = 3), 
                    valueBoxOutput('avg_course_user', width = 3)
                ), 
                
                fluidRow(
                    
                    column(
                        width = 8, 
                        box(dygraphOutput('schedule_plot'), 
                            width = NULL, 
                            solidHeader = TRUE)
                    ), 
                    
                    # 第二行第二列，绘图选项
                    column(
                        width = 4, 
                        
                        # 小时/日/周/月选项
                        box(selectInput('schedule_date_format', 
                                        label = 'select time format', 
                                        choices = list('hourly' = 'hourly', 
                                                       'daily' = 'daily', 
                                                       'weekly' = 'weekly', 
                                                       'monthly' = 'monthly'), 
                                        selected = 'daily'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 数据类型选项
                        box(selectInput('schedule_data_type', 
                                        label = 'select data type', 
                                        choices = list('new course' = 'new_course',
                                                       'new user' = 'new_user', 
                                                       'active user' = 'active_user', 
                                                       'new file' = 'new_file', 
                                                       'operation' = 'operation'), 
                                        selected = 'new_user'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 时间范围选项
                        box(dateRangeInput('schedule_date_range', 
                                           label = 'select date range', 
                                           min = min(daily_login$date_time), 
                                           max = max(daily_login$date_time), 
                                           start = min(daily_login$date_time), 
                                           language = 'zh-CN'), 
                            width = NULL, 
                            solidHeader = TRUE),
                        
                        helpText(paste0('NOTE: when date format is weekly/monthly, ', 
                                        'the plot begins at the first weekday/monthday and ', 
                                        'ends at the last weekday/monthday of date range selected, ', 
                                        'and \'2016-04-11\' means the week between 2016.4.11 to 2016.4.18, ', 
                                        '\'2016-04-01\' means the month between 2016.4.1 to 2016.4.30.' ))
                    )
                )
            ), 
            
            tabItem(
                tabName = 'trade',
                
                fluidRow(
                    valueBoxOutput('sell_info', width = 3), 
                    valueBoxOutput('seller', width = 3), 
                    valueBoxOutput('purchase_info', width = 3), 
                    valueBoxOutput('purchaser', width = 3)
                ), 
                
                fluidRow(
                    
                    column(
                        width = 8, 
                        box(dygraphOutput('trade_plot'), 
                            width = NULL, 
                            solidHeader = TRUE)
                    ), 
                    
                    # 第二行第二列，绘图选项
                    column(
                        width = 4, 
                        
                        # 小时/日/周/月选项
                        box(selectInput('trade_date_format', 
                                        label = 'select time format', 
                                        choices = list('hourly' = 'hourly', 
                                                       'daily' = 'daily', 
                                                       'weekly' = 'weekly', 
                                                       'monthly' = 'monthly'), 
                                        selected = 'daily'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 数据类型选项
                        box(selectInput('trade_data_type', 
                                        label = 'select data type', 
                                        choices = list('new sell information' = 'new_sell_info',
                                                       'new buy information' = 'new_buy_info', 
                                                       'active seller' = 'active_seller', 
                                                       'active buyer' = 'new_buyer', 
                                                       'active trader' = 'active_trader'), 
                                        selected = 'active_trader'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 时间范围选项
                        box(dateRangeInput('trade_date_range', 
                                           label = 'select date range', 
                                           min = min(daily_login$date_time), 
                                           max = max(daily_login$date_time), 
                                           start = min(daily_login$date_time), 
                                           language = 'zh-CN'), 
                            width = NULL, 
                            solidHeader = TRUE),
                        
                        helpText(paste0('NOTE: when date format is weekly/monthly, ', 
                                        'the plot begins at the first weekday/monthday and ', 
                                        'ends at the last weekday/monthday of date range selected, ', 
                                        'and \'2016-04-11\' means the week between 2016.4.11 to 2016.4.18, ', 
                                        '\'2016-04-01\' means the month between 2016.4.1 to 2016.4.30.' ))
                    )
                )
            ), 
            
            tabItem(
                tabName = 'train',
                
                fluidRow(
                    valueBoxOutput('train_company', width = 3), 
                    valueBoxOutput('train_course', width = 3), 
                    valueBoxOutput('train_user', width = 3)
                ), 
                
                fluidRow(
                    
                    column(
                        width = 8, 
                        box(dygraphOutput('train_plot'), 
                            width = NULL, 
                            solidHeader = TRUE)
                    ), 
                    
                    # 第二行第二列，绘图选项
                    column(
                        width = 4, 
                        
                        # 小时/日/周/月选项
                        box(selectInput('train_date_format', 
                                        label = 'select time format', 
                                        choices = list('hourly' = 'hourly', 
                                                       'daily' = 'daily', 
                                                       'weekly' = 'weekly', 
                                                       'monthly' = 'monthly'), 
                                        selected = 'daily'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 数据类型选项
                        box(selectInput('train_data_type', 
                                        label = 'select data type', 
                                        choices = list('new company' = 'new_company', 
                                                       'new course' = 'new_course', 
                                                       'active user' = 'active_user', 
                                                       'new view' = 'new_view', 
                                                       'new collect' = 'new_collect', 
                                                       'new apply' = 'new_apply', 
                                                       'new contact' = 'new_contact'), 
                                        selected = 'active_user'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 时间范围选项
                        box(dateRangeInput('train_date_range', 
                                           label = 'select date range', 
                                           min = min(daily_login$date_time), 
                                           max = max(daily_login$date_time), 
                                           start = min(daily_login$date_time), 
                                           language = 'zh-CN'), 
                            width = NULL, 
                            solidHeader = TRUE),
                        
                        helpText(paste0('NOTE: when date format is weekly/monthly, ', 
                                        'the plot begins at the first weekday/monthday and ', 
                                        'ends at the last weekday/monthday of date range selected, ', 
                                        'and \'2016-04-11\' means the week between 2016.4.11 to 2016.4.18, ', 
                                        '\'2016-04-01\' means the month between 2016.4.1 to 2016.4.30.' ))
                    )
                )
            )
        )
    )
))