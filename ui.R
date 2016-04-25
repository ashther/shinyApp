
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
                
                fluidRow(
                    column(
                        width = 8, 
                        box(leafletOutput('user_location'), 
                            width = NULL, 
                            solidHeader = TRUE)
                    ), 
                    
                    column(
                        width = 4, 
                        box(selectInput('province',
                                        'select a province',
                                        list('安徽省' = '安徽省',
                                             '北京市' = '北京市',
                                             '重庆市' = '重庆市',
                                             '福建省' = '福建省',
                                             '甘肃省' = '甘肃省',
                                             '广东省' = '广东省',
                                             '广西壮族自治区' = '广西壮族自治区',
                                             '贵州省' = '贵州省',
                                             '海南省' = '海南省',
                                             '河北省' = '河北省',
                                             '河南省' = '河南省',
                                             '黑龙江省' = '黑龙江省',
                                             '湖北省' = '湖北省',
                                             '湖南省' = '湖南省',
                                             '吉林省' = '吉林省',
                                             '江苏省' = '江苏省',
                                             '江西省' = '江西省',
                                             '辽宁省' = '辽宁省',
                                             '内蒙古自治区' = '内蒙古自治区',
                                             '宁夏回族自治区' = '宁夏回族自治区',
                                             '青海省' = '青海省',
                                             '山东省' = '山东省',
                                             '山西省' = '山西省',
                                             '陕西省' = '陕西省',
                                             '上海市' = '上海市',
                                             '四川省' = '四川省',
                                             '天津市' = '天津市',
                                             '西藏自治区' = '西藏自治区',
                                             '新疆维吾尔自治区' = '新疆维吾尔自治区',
                                             '云南省' = '云南省',
                                             '浙江省' = '浙江省'),
                                        selected = '陕西省'),
                            width = NULL,
                            solidHeader = TRUE),
                        
                        box(selectInput('city', 
                                        'select a city', 
                                        list('安康市' = '安康市', 
                                             '宝鸡市' = '宝鸡市', 
                                             '汉中市' = '汉中市', 
                                             '商洛市' = '商洛市', 
                                             '铜川市' = '铜川市', 
                                             '渭南市' = '渭南市', 
                                             '西安市' = '西安市',
                                             '咸阳市' = '咸阳市',
                                             '延安市' = '延安市',
                                             '榆林市' = '榆林市'), 
                                        selected = '西安市'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        box(sliderInput('user_location_lng', 
                                        'select longitude of map center: ', 
                                        min = city_location$lng[city_location$city == '西安市'] - 0.2, 
                                        max = city_location$lng[city_location$city == '西安市'] + 0.2, 
                                        value = city_location$lng[city_location$city == '西安市']), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        box(sliderInput('user_location_lat', 
                                        'select latitude of map center: ', 
                                        min = city_location$lat[city_location$city == '西安市'] - 0.2, 
                                        max = city_location$lat[city_location$city == '西安市'] + 0.2, 
                                        value = city_location$lat[city_location$city == '西安市']), 
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