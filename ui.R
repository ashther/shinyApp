
library(shinydashboard)
library(dygraphs)
library(xts)
library(leaflet)
library(ggplot2)
library(plotly)

source('dataSource.R')

shinyUI(dashboardPage(
    skin = 'black', 
    
    dashboardHeader(title = '数据分析'), 
    
    dashboardSidebar(
        
        sidebarMenu(
            menuItem('用户规模及质量', 
                     tabName = 'login', 
                     icon = icon('dashboard')),
            menuItem('快信', 
                     tabName = 'quick_chat', 
                     icon = icon('weixin')), 
            menuItem('勤务表', 
                     tabName = 'calendar', 
                     icon = icon('calendar')), 
            menuItem('找合作', 
                     tabName = 'cooperation', 
                     icon = icon('github')), 
            menuItem('找工作', 
                     tabName = 'hr', 
                     icon = icon('linkedin')), 
            menuItem('软课表', 
                     tabName = 'schedule', 
                     icon = icon('university')), 
            menuItem('自贸区', 
                     tabName = 'trade', 
                     icon = icon('rmb')), 
            menuItem('找培训', 
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
                                        label = '选择统计周期', 
                                        choices = list('小时' = 'hourly', 
                                                       '日' = 'daily', 
                                                       '周' = 'weekly', 
                                                       '月' = 'monthly'), 
                                        selected = 'hourly'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 数据类型选项
                        box(selectInput('login_data_type', 
                                        label = '选择指标', 
                                        choices = list('新增用户数' = 'new',
                                                       '活跃用户数' = 'active', 
                                                       '登陆次数' = 'log_in', 
                                                       '留存率' = 'retention'), 
                                        selected = 'active'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 时间范围选项
                        box(dateRangeInput('login_date_range', 
                                           label = '选择统计区间', 
                                           min = min(daily_login$date_time), 
                                           max = max(daily_login$date_time), 
                                           start = Sys.Date() - 1, 
                                           language = 'zh-CN'), 
                            width = NULL, 
                            solidHeader = TRUE),
                        
                        p(helpText(paste0('注意：当统计周期为周/月时， ', 
                                        '图的横坐标开始于所选周/月的第一天，表示当周/月，', 
                                        '如统计周期为周时，2016-04-11表示4月11日-18日这一周， ', 
                                        '而统计周期为月时，2016-04-01表示4月' )), 
                          style = 'font-size:85%')
                    )
                ), 
                
                br(),
                br(),
                
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
                                        label = '选择指标', 
                                        choices = list('日登陆频次' = 'daily_freq'), 
                                        selected = 'daily_freq'), 
                            width = NULL,
                            solidHeader = TRUE), 
                        
                        # 时间范围选项
                        box(dateRangeInput('login_date_range_freq', 
                                           label = '选择统计区间', 
                                           min = min(daily_login$date_time), 
                                           max = max(daily_login$date_time), 
                                           start = min(daily_login$date_time), 
                                           language = 'zh-CN'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 绘图多选选项
                        box(checkboxGroupInput('login_freq_type', 
                                               label = '选择频次区间', 
                                               choices = list('大于等于50次' = '50', 
                                                              '20-49次' = '20', 
                                                              '10-19次' = '10',
                                                              '6-9次' = '6',
                                                              '3-5次' = '3',
                                                              '1-2次' = '1'), 
                                               selected = '1'), 
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
                
                br(), 
                br(),
                
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
                                        label = '选择统计周期', 
                                        choices = list('小时' = 'hourly', 
                                                       '日' = 'daily', 
                                                       '周' = 'weekly', 
                                                       '月' = 'monthly'), 
                                        selected = 'hourly'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 数据类型选项
                        box(selectInput('quick_chat_data_type', 
                                        label = '选择指标', 
                                        choices = list('活跃圈子数' = 'active_circle', 
                                                       '消息数' = 'message', 
                                                       '活跃用户数' = 'active_user'), 
                                        selected = 'message'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 时间范围选项
                        box(dateRangeInput('quick_chat_date_range', 
                                           label = '选择统计区间', 
                                           min = min(daily_login$date_time), 
                                           max = max(daily_login$date_time), 
                                           start = min(daily_login$date_time), 
                                           language = 'zh-CN'), 
                            width = NULL, 
                            solidHeader = TRUE),
                        
                        p(helpText(paste0('注意：当统计周期为周/月时， ', 
                                          '图的横坐标开始于所选周/月的第一天，表示当周/月，', 
                                          '如统计周期为周时，2016-04-11表示4月11日-18日这一周， ', 
                                          '而统计周期为月时，2016-04-01表示4月' )), 
                          style = 'font-size:85%')
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
                                        label = '选择统计周期', 
                                        choices = list('小时' = 'hourly', 
                                                       '日' = 'daily', 
                                                       '周' = 'weekly', 
                                                       '月' = 'monthly'), 
                                        selected = 'daily'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 数据类型选项
                        box(selectInput('calendar_data_type', 
                                        label = '选择指标', 
                                        choices = list('新增活动数' = 'new_activity', 
                                                       '新增用户数' = 'new_user'), 
                                        selected = 'new_user'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 时间范围选项
                        box(dateRangeInput('calendar_date_range', 
                                           label = '选择统计区间', 
                                           min = min(daily_login$date_time), 
                                           max = max(daily_login$date_time), 
                                           start = min(daily_login$date_time), 
                                           language = 'zh-CN'), 
                            width = NULL, 
                            solidHeader = TRUE),
                        
                        p(helpText(paste0('注意：当统计周期为周/月时， ', 
                                          '图的横坐标开始于所选周/月的第一天，表示当周/月，', 
                                          '如统计周期为周时，2016-04-11表示4月11日-18日这一周， ', 
                                          '而统计周期为月时，2016-04-01表示4月' )), 
                          style = 'font-size:85%')
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
                                        label = '寻找统计周期', 
                                        choices = list('小时' = 'hourly', 
                                                       '日' = 'daily', 
                                                       '周' = 'weekly', 
                                                       '月' = 'monthly'), 
                                        selected = 'daily'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 数据类型选项
                        box(selectInput('cooperation_data_type', 
                                        label = '选择指标', 
                                        choices = list('活跃企业数' = 'new_company',
                                                       '新增项目数' = 'new_project', 
                                                       '活跃用户数' = 'active_user', 
                                                       '浏览数' = 'new_view', 
                                                       '收藏数' = 'new_collect', 
                                                       '申请数' = 'new_apply'), 
                                        selected = 'active_user'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 时间范围选项
                        box(dateRangeInput('calendar_date_range', 
                                           label = '选择统计区间', 
                                           min = min(daily_login$date_time), 
                                           max = max(daily_login$date_time), 
                                           start = min(daily_login$date_time), 
                                           language = 'zh-CN'), 
                            width = NULL, 
                            solidHeader = TRUE),
                        
                        p(helpText(paste0('注意：当统计周期为周/月时， ', 
                                          '图的横坐标开始于所选周/月的第一天，表示当周/月，', 
                                          '如统计周期为周时，2016-04-11表示4月11日-18日这一周， ', 
                                          '而统计周期为月时，2016-04-01表示4月' )), 
                          style = 'font-size:85%')
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
                                        label = '选择统计周期', 
                                        choices = list('小时' = 'hourly', 
                                                       '日' = 'daily', 
                                                       '周' = 'weekly', 
                                                       '月' = 'monthly'), 
                                        selected = 'daily'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 数据类型选项
                        box(selectInput('hr_data_type', 
                                        label = '选择指标', 
                                        choices = list('新增个人用户' = 'new_user', 
                                                       '新增企业数' = 'new_company', 
                                                       '新增招聘信息数' = 'new_recruitment', 
                                                       '刷新招聘信息数' = 'update_recruitment', 
                                                       '个人用户操作数' = 'jobseekers_operation', 
                                                       '企业用户操作数' = 'hr_operation'), 
                                        selected = 'new_user'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 时间范围选项
                        box(dateRangeInput('hr_date_range', 
                                           label = '选择统计区间', 
                                           min = min(daily_login$date_time), 
                                           max = max(daily_login$date_time), 
                                           start = min(daily_login$date_time), 
                                           language = 'zh-CN'), 
                            width = NULL, 
                            solidHeader = TRUE),
                        
                        p(helpText(paste0('注意：当统计周期为周/月时， ', 
                                          '图的横坐标开始于所选周/月的第一天，表示当周/月，', 
                                          '如统计周期为周时，2016-04-11表示4月11日-18日这一周， ', 
                                          '而统计周期为月时，2016-04-01表示4月' )), 
                          style = 'font-size:85%')
                    )
                )
            ), 
            
            tabItem(
                tabName = 'schedule',
                
                fluidRow(
                    valueBoxOutput('schedule_course', width = 3), 
                    valueBoxOutput('schedule_courseware', width = 3),
                    valueBoxOutput('schedule_homework', width = 3), 
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
                                        label = '选择统计周期', 
                                        choices = list('小时' = 'hourly', 
                                                       '日' = 'daily', 
                                                       '周' = 'weekly', 
                                                       '月' = 'monthly'), 
                                        selected = 'daily'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 数据类型选项
                        box(selectInput('schedule_data_type', 
                                        label = '选择指标', 
                                        choices = list('新增课程数' = 'new_course',
                                                       '新增用户数' = 'new_user', 
                                                       '活跃用户数' = 'active_user', 
                                                       '新增课程文件数' = 'new_file', 
                                                       '操作数' = 'operation'), 
                                        selected = 'new_user'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 时间范围选项
                        box(dateRangeInput('schedule_date_range', 
                                           label = '选择统计区间', 
                                           min = min(daily_login$date_time), 
                                           max = max(daily_login$date_time), 
                                           start = min(daily_login$date_time), 
                                           language = 'zh-CN'), 
                            width = NULL, 
                            solidHeader = TRUE),
                        
                        p(helpText(paste0('注意：当统计周期为周/月时， ', 
                                          '图的横坐标开始于所选周/月的第一天，表示当周/月，', 
                                          '如统计周期为周时，2016-04-11表示4月11日-18日这一周， ', 
                                          '而统计周期为月时，2016-04-01表示4月' )), 
                          style = 'font-size:85%')
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
                    valueBoxOutput('sell_median', width = 3), 
                    valueBoxOutput('sell_mean', width = 3), 
                    valueBoxOutput('buy_median', width = 3), 
                    valueBoxOutput('buy_mean', width = 3)
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
                                        label = '选择统计周期', 
                                        choices = list('小时' = 'hourly', 
                                                       '日' = 'daily', 
                                                       '周' = 'weekly', 
                                                       '月' = 'monthly'), 
                                        selected = 'daily'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 数据类型选项
                        box(selectInput('trade_data_type', 
                                        label = '选择指标', 
                                        choices = list('新增出售商品数' = 'new_sell_info',
                                                       '新增求购信息数' = 'new_buy_info', 
                                                       '活跃卖家数' = 'active_seller', 
                                                       '活跃买家数' = 'active_buyer', 
                                                       '活跃用户数' = 'active_trader'), 
                                        selected = 'active_trader'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 时间范围选项
                        box(dateRangeInput('trade_date_range', 
                                           label = '选择统计区间', 
                                           min = min(daily_login$date_time), 
                                           max = max(daily_login$date_time), 
                                           start = min(daily_login$date_time), 
                                           language = 'zh-CN'), 
                            width = NULL, 
                            solidHeader = TRUE),
                        
                        p(helpText(paste0('注意：当统计周期为周/月时， ', 
                                          '图的横坐标开始于所选周/月的第一天，表示当周/月，', 
                                          '如统计周期为周时，2016-04-11表示4月11日-18日这一周， ', 
                                          '而统计周期为月时，2016-04-01表示4月' )), 
                          style = 'font-size:85%')
                    )
                ), 
                
                br(), 
                br(), 
                
                fluidRow(
                    
                    column(
                        width = 8, 
                        box(plotOutput('trade_price'), 
                            width = NULL,
                            solidHeader = TRUE)
                    ), 
                    
                    column(
                        width = 4, 
                        
                        box(selectInput('price_type', 
                                        '选择价格类别', 
                                        choices = list('出售价格' = 'sell_price', 
                                                       '求购价格' = 'buy_price'), 
                                        selected = 'sell_price'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        box(checkboxGroupInput('price_category', 
                                               '选择商品类别', 
                                               choices = list('图书/音像' = '图书/音像', 
                                                              '文体户外' = '文体户外', 
                                                              '生活用品' = '生活用品', 
                                                              '小家电' = '小家电', 
                                                              '电脑/配件' = '电脑/配件', 
                                                              '数码产品' = '数码产品', 
                                                              '手机' = '手机', 
                                                              '其它' = '其它'), 
                                               selected = '图书/音像'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        box(sliderInput('price_binwidth', 
                                        '选择价格组距', 
                                        min = 1, 
                                        max = 50, 
                                        value = 5), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        box(checkboxInput('price_outlier', 
                                          '是否去除异常价格', 
                                          value = FALSE), 
                            width = NULL, 
                            solidHeader = TRUE)
                    )
                ), 
                
                br(), 
                br(),
                
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
                                        '选择省级地区', 
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
                                        '选择市级地区', 
                                        choices = list('西安市' = '西安市'), 
                                        selected = '西安市'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 日期选项
                        box(dateRangeInput('map_date_range', 
                                           label = '选择统计区间', 
                                           min = min(user_location$create_time), 
                                           max = max(user_location$create_time), 
                                           start = min(user_location$create_time), 
                                           language = 'zh-CN'), 
                            width = NULL, 
                            solidHeader = TRUE)
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
                                        label = '选择统计周期', 
                                        choices = list('小时' = 'hourly', 
                                                       '日' = 'daily', 
                                                       '周' = 'weekly', 
                                                       '月' = 'monthly'), 
                                        selected = 'daily'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 数据类型选项
                        box(selectInput('train_data_type', 
                                        label = '选择指标', 
                                        choices = list('活跃企业数' = 'new_company', 
                                                       '新增培训课程数' = 'new_course', 
                                                       '活跃用户数' = 'active_user', 
                                                       '浏览数' = 'new_view', 
                                                       '收藏数' = 'new_collect', 
                                                       '申请数' = 'new_apply', 
                                                       '联系数' = 'new_contact'), 
                                        selected = 'active_user'), 
                            width = NULL, 
                            solidHeader = TRUE), 
                        
                        # 时间范围选项
                        box(dateRangeInput('train_date_range', 
                                           label = '选择统计区间', 
                                           min = min(daily_login$date_time), 
                                           max = max(daily_login$date_time), 
                                           start = min(daily_login$date_time), 
                                           language = 'zh-CN'), 
                            width = NULL, 
                            solidHeader = TRUE),
                        
                        p(helpText(paste0('注意：当统计周期为周/月时， ', 
                                          '图的横坐标开始于所选周/月的第一天，表示当周/月，', 
                                          '如统计周期为周时，2016-04-11表示4月11日-18日这一周， ', 
                                          '而统计周期为月时，2016-04-01表示4月' )), 
                          style = 'font-size:85%')
                    )
                )
            )
        )
    )
))