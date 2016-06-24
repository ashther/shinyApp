
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
      menuItem('用户属性统计', 
           tabName = 'demographic', 
           icon = icon('bar-chart')),
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
        tabName = 'login',
        
        # 第一行，实时用户数据
        fluidRow(
          tags$div(title = '全体注册用户数之和（按账号统计）', 
               valueBoxOutput('total_user', width = 3)), 
          tags$div(title = '当日新注册用户数（按账号统计）', 
               valueBoxOutput('new_user_today', width = 3)), 
          tags$div(title = '当日活跃用户（至少登陆过一次的用户）数，
               括号内为存量（非今日新增）用户所占比例', 
               valueBoxOutput('active_user_today', width = 3)),
          tags$div(title = '当日所有用户登录应用的总次数', 
               valueBoxOutput('login_times_today', width = 3))
        ), 
        
        fluidRow(
          dygraphOutput('hourly_login_plot')
        ), 
        
        br(), 
        br(), 
        
        # 第二行，历史用户数据
        fluidRow(
          
          # 第二行第一列，历史数据图
          column(
            width = 8, 
            dygraphOutput('login_plot_1')
          ), 
          
          # 第二行第二列，绘图选项
          column(
            width = 4, 
            uiOutput('login_date_format_render'), 
            
            tags$div(title = paste0('新增用户数、活跃用户数、登陆次数', 
                        '均为所选统计周期内的时段数据', 
                        '当统计周期为日时，留存率为次日留存率；', 
                        '当统计周期为周时，留存率为7日内留存率，与第7日留存率并不相同；', 
                        '当统计周期为月时，留存率为30日内留存率，与第30日留存率并不相同'),
                 uiOutput('login_data_type_render')), 
            
            uiOutput('login_date_range_render'), 
            
            uiOutput('login_help_text')
          )
        ), 
        
        br(),
        br(),
        
        #第三行，日登陆频次统计
        fluidRow(
          
          # 第三行第一列，日登陆频次图
          column(
            width = 8, 
            dygraphOutput('login_plot_2')
          ), 
          
          # 第三行第二列，日登陆频次绘图选项
          column(
            width = 4, 
            
            # 数据类型（暂时仅为日登陆频次）
            uiOutput('login_data_type_freq_render'), 
            
            # 时间范围选项
            uiOutput('login_date_range_freq_render'), 
            
            # 绘图多选选项
            uiOutput('login_freq_type_render')
          )
        )
      ),
      
      tabItem(
        tabName = 'demographic', 
        
        fluidRow(
          column(width = 9, 
                 
                 textOutput('test'), # print_to_test
                 
               fluidRow(# 删除异常确定、年龄bar图
                 box(tags$div(title = paste0('一组数据的上下四分位数之间的距离为IQR， ', 
                               '通常将超过改组数据上下分位数1.5倍IQR的数据定为异常点'), 
                      checkboxInput('demographic_age_outlier', 
                              '去除异常年龄', 
                              value = TRUE)), 
                   width = NULL, 
                   solidHeader = TRUE), 
                 
                 box(plotlyOutput('demographic_age_plot'), 
                   width = NULL, 
                   solidHeader = TRUE)
               ), 
               fluidRow(
                 column(width = 6, 
                    box(checkboxInput('demographic_gender_null', 
                            '去除未填写', 
                            value = TRUE), 
                      width = NULL, 
                      solidHeader = TRUE), 
                    
                    box(plotlyOutput('demographic_gender_plot'), 
                      width = NULL, 
                      solidHeader = TRUE)), # 删除异常确定、性别pie图
                 column(width = 6, 
                    box(checkboxInput('demographic_degree_null', 
                            '去除未填写项', 
                            value = TRUE), 
                      width = NULL, 
                      solidHeader = TRUE), 
                    
                    box(plotlyOutput('demographic_degree_plot'), 
                      width = NULL, 
                      solidHeader = TRUE))# 删除异常确定、学历pie图
               )), 
          column(width = 3, 
               box(selectizeInput('demographic_university_select', 
                       '选择学校', 
                       c('不限', unique(demographic$university[demographic$status_category == 1]))), 
                 width = NULL, 
                 solidHeader = TRUE), # 学校选择
               box(dateRangeInput('demographic_dateRange_1', 
                        '选择用户注册时段', 
                        min = min(daily_login$date_time), 
                        max = max(daily_login$date_time), 
                        start = min(daily_login$date_time), 
                        end = max(daily_login$date_time), 
                        language = 'zh-CN'), 
                 width = NULL, 
                 solidHeader = TRUE), # 注册日期选择
               p(helpText('选项对图1、图2和图3有效'), 
                 style = 'font-size:85%'))
                
        ), 
        
        fluidRow(
          column(width = 4, 
               box(plotlyOutput('demographic_university_top10'), 
                 width = NULL, 
                 solidHeader = TRUE)), # 学校top10
          column(width = 5, 
               box(plotlyOutput('demographic_heatmap'), 
                 width = NULL, 
                 solidHeader = TRUE)), # 学校学历热图
          column(width = 3, # 学校选择
               box(dateRangeInput('demographic_dateRange_2', 
                        '选择用户注册时段', 
                        min = min(daily_login$date_time), 
                        max = max(daily_login$date_time), 
                        language = 'zh-CN'), 
                 width = NULL, 
                 solidHeader = TRUE)) # 注册日期选择
        )
      ), 
      
      tabItem(
        tabName = 'quick_chat',
        
        fluidRow(
          tags$div(title = '包括了主动圈与课程圈等所有类型的圈子', 
               valueBoxOutput('quick_chat_circle', width = 3)), 
          tags$div(title = '各圈子的平均成员数量', 
               valueBoxOutput('avg_circle_user', width = 3))
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
            box(tags$div(title = paste0('活跃圈子：统计期内产生过聊天信息的圈子； ', 
                          '消息数：包括了统计期内产生的私聊与群聊消息； ', 
                          '活跃用户：统计期内主动发送过消息的用户'), 
                   selectInput('quick_chat_data_type', 
                         label = '选择指标', 
                         choices = list('活跃圈子数' = 'active_circle', 
                                '消息数' = 'message', 
                                '活跃用户数' = 'active_user'), 
                         selected = 'message')), 
              width = NULL, 
              solidHeader = TRUE), 
            
            # 时间范围选项
            box(dateRangeInput('quick_chat_date_range', 
                       label = '选择统计区间', 
                       min = min(daily_login$date_time), 
                       max = max(daily_login$date_time), 
                       start = max(daily_login$date_time) - 31, 
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
        
        fluidRow(
          p(helpText(paste0('注意：由于快信模块部分后台数据并非直接入库，而是', 
                    '采用每日4点和16点进行增量更新的方式，因此', 
                    '该模块所呈现的活跃圈子、消息数、活跃用户数等与聊天消息', 
                    '相关的指标均为上一个更新点时刻的数据。')), 
            style = 'font-size:90%')
        )
      ), 
      
      tabItem(
        tabName = 'calendar',
        
        fluidRow(
          tags$div(title = '已结束的活动不纳入统计范围', 
               valueBoxOutput('calendar_activity', width = 3)), 
          tags$div(title = '已结束的活动不纳入统计范围', 
               valueBoxOutput('avg_activity_user', width = 3)) 
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
            box(tags$div(title = paste0('新增活动：在统计期内创建的活动，不论是否已结束； ', 
                          '新增用户：在统计期内新加入过活动的用户； '), 
                   selectInput('calendar_data_type', 
                         label = '选择指标', 
                         choices = list('新增活动数' = 'new_activity', 
                                '新增用户数' = 'new_user'), 
                         selected = 'new_user')), 
              width = NULL, 
              solidHeader = TRUE), 
            
            # 时间范围选项
            box(dateRangeInput('calendar_date_range', 
                       label = '选择统计区间', 
                       min = min(daily_login$date_time), 
                       max = max(daily_login$date_time), 
                       start = max(daily_login$date_time) - 31, 
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
            box(tags$div(title = paste0('活跃企业：统计期内发布过项目的企业，不论项目是否过期； ', 
                          '新增项目：统计期内被发布的项目，不论是否过期； ', 
                          '活跃用户：统计期内浏览、收藏或申请过项目的用户'), 
                   selectInput('cooperation_data_type', 
                         label = '选择指标', 
                         choices = list('活跃企业数' = 'new_company',
                                '新增项目数' = 'new_project', 
                                '活跃用户数' = 'active_user', 
                                '浏览数' = 'new_view', 
                                '收藏数' = 'new_collect', 
                                '申请数' = 'new_apply'), 
                         selected = 'active_user')), 
              width = NULL, 
              solidHeader = TRUE), 
            
            # 时间范围选项
            box(dateRangeInput('calendar_date_range', 
                       label = '选择统计区间', 
                       min = min(daily_login$date_time), 
                       max = max(daily_login$date_time), 
                       start = max(daily_login$date_time) - 31, 
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
            box(tags$div(title = paste0('新增个人用户：在统计期内创建了求职意向的个人用户； ', 
                          '新增企业：在统计期内新创建并通过了审核的企业用户； ', 
                          '新增招聘信息：在统计期内创建的招聘信息（不论是否过期）； ', 
                          '刷新招聘信息：在统计期内刷新过（创建时间在统计期之前）的招聘信息； ', 
                          '个人/企业用户操作：包括了用户浏览和收藏等所有动作'), 
                   selectInput('hr_data_type', 
                         label = '选择指标', 
                         choices = list('新增个人用户' = 'new_user', 
                                '新增企业数' = 'new_company', 
                                '新增招聘信息数' = 'new_recruitment', 
                                '刷新招聘信息数' = 'update_recruitment', 
                                '个人用户操作数' = 'jobseekers_operation', 
                                '企业用户操作数' = 'hr_operation'), 
                         selected = 'new_user')), 
              width = NULL, 
              solidHeader = TRUE), 
            
            # 时间范围选项
            box(dateRangeInput('hr_date_range', 
                       label = '选择统计区间', 
                       min = min(daily_login$date_time), 
                       max = max(daily_login$date_time), 
                       start = max(daily_login$date_time) - 31, 
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
            box(tags$div(title = paste0('新增课程：统计期内被用户创建的课程', 
                          '（系统创建的不纳入统计范围）； ', 
                          '新增用户：统计期内加入课程的学习者用户', 
                          '（被创建者以花名册形式导入但没有思扣账号的不纳入统计范围）； ', 
                          '活跃用户：统计期内浏览、收藏、下载、上传课件或作业（包括删除作业）的用户； ',
                          '新增课程文件：统计期内被上传的课件或作业； ', 
                          '操作数：统计期内与课件或作业有关的浏览、收藏、下载、上传或删除动作的计数'), 
                   selectInput('schedule_data_type', 
                         label = '选择指标', 
                         choices = list('新增课程数' = 'new_course',
                                '新增用户数' = 'new_user', 
                                '活跃用户数' = 'active_user', 
                                '新增课程文件数' = 'new_file', 
                                '操作数' = 'operation'), 
                         selected = 'new_user')), 
              width = NULL, 
              solidHeader = TRUE), 
            
            # 时间范围选项
            box(dateRangeInput('schedule_date_range', 
                       label = '选择统计区间', 
                       min = min(daily_login$date_time), 
                       max = max(daily_login$date_time), 
                       start = max(daily_login$date_time) - 31, 
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
          tags$div(title = '目前有效的出售商品信息数', 
               valueBoxOutput('sell_info', width = 3)),
          tags$div(title = '发布的出售商品信息仍然有效的个人用户（去重）', 
               valueBoxOutput('seller', width = 3)),
          tags$div(title = '目前在架的求购商品信息数', 
               valueBoxOutput('purchase_info', width = 3)),
          tags$div(title = '发布的求购商品信息仍然有效的个人用户（去重）', 
               valueBoxOutput('purchaser', width = 3))
        ), 
        
        fluidRow(
          tags$div(title = '有效出售商品的价格中位数', 
               valueBoxOutput('sell_median', width = 3)),
          
          tags$div(title = '有效的求购商品的价格中位数', 
               valueBoxOutput('buy_median', width = 3)), 
          
          tags$div(title = '有效的出售和求购商品价格之和', 
               valueBoxOutput('sell_buy_total', width = 6))
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
            box(tags$div(title = paste0('新增出售/求购商品：统计期内被创建的出售/求购商品； ', 
                          '活跃卖家/买家：统计期内创建或修改过出售/求购商品信息的用户（去重）； ', 
                          '活跃用户数：统计期内创建或修改过商品信息的用户（去重）'), 
                   selectInput('trade_data_type', 
                         label = '选择指标', 
                         choices = list('新增出售商品数' = 'new_sell_info',
                                '新增求购信息数' = 'new_buy_info', 
                                '活跃卖家数' = 'active_seller', 
                                '活跃买家数' = 'active_buyer', 
                                '活跃用户数' = 'active_trader'), 
                         selected = 'active_trader')), 
              width = NULL, 
              solidHeader = TRUE), 
            
            # 时间范围选项
            box(dateRangeInput('trade_date_range', 
                       label = '选择统计区间', 
                       min = min(daily_login$date_time), 
                       max = max(daily_login$date_time), 
                       start = max(daily_login$date_time) - 31, 
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
            # box(plotlyOutput('trade_price'),
            #     width = NULL,
            #     solidHeader = TRUE)
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
                         choices = list('图书/音像：1' = '1',
                                '文体户外：2' = '2',
                                '生活用品：3' = '3',
                                '小家电：4' = '4',
                                '电脑/配件：5' = '5',
                                '数码产品：6' = '6',
                                '手机：32' = '32',
                                '其它：7' = '7'),
                         selected = '1'),
              width = NULL,
              solidHeader = TRUE),
            
            box(tags$div(title = '价格被分成若干组以绘制直方图，组距为各小组两端点间的距离', 
                   sliderInput('price_binwidth', 
                         '选择价格组距', 
                         min = 1, 
                         max = 50, 
                         value = 5)), 
              width = NULL, 
              solidHeader = TRUE), 
            
            box(tags$div(title = paste0('一组数据的上下四分位数之间的距离为IQR， ', 
                          '通常将超过改组数据上下分位数1.5倍IQR的数据定为异常点'), 
                   checkboxInput('price_outlier', 
                           '是否去除异常价格', 
                           value = FALSE)), 
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
            box(tags$div(title = '地图中气泡所代表的是发布出售商品信息的个人用户地址信息，并非实时定位信息', 
                   leafletOutput('user_location')), 
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
            box(tags$div(title = paste0('活跃企业：统计期内发布过培训信息的企业（不论相关培训信息是否还有效）； ', 
                          '新增培训课程：在统计期内发布的培训课程（不论是否还有效）； ', 
                          '活跃用户：统计期内浏览、收藏、申请过培训课程，或与企业联系的用户'), 
                   selectInput('train_data_type', 
                         label = '选择指标', 
                         choices = list('活跃企业数' = 'new_company', 
                                '新增培训课程数' = 'new_course', 
                                '活跃用户数' = 'active_user', 
                                '浏览数' = 'new_view', 
                                '收藏数' = 'new_collect', 
                                '申请数' = 'new_apply', 
                                '联系数' = 'new_contact'), 
                         selected = 'active_user')), 
              width = NULL, 
              solidHeader = TRUE), 
            
            p(helpText(paste0('注意：由于业务逻辑需要，同一用户对同一培训课程的', 
                      '操作动作在后台数据库中只记作一条记录，因此会存在', 
                      '部分数据前后统计不一致的情况，直观来看，会影响收藏数和', 
                      '联系数的统计准确度，请酌情参考'))), 
            
            # 时间范围选项
            box(dateRangeInput('train_date_range', 
                       label = '选择统计区间', 
                       min = min(daily_login$date_time), 
                       max = max(daily_login$date_time), 
                       start = max(daily_login$date_time) - 31, 
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