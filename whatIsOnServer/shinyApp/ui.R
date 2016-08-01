
library(shinydashboard)
library(dygraphs)
library(xts)
library(leaflet)
library(ggplot2)
library(plotly)
library(digest)

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
      menuItem('渠道来源及应用版本', 
               tabName = 'channel', 
               icon = icon('cloud-download')), 
      menuItem('用户登录定位统计', 
               tabName = 'geo', 
               icon = icon('map-marker'))
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
        
        #第四行，日登陆频次统计
        fluidRow(
          
          # 第四行第一列，日登陆频次图
          column(
            width = 8, 
            dygraphOutput('login_plot_2')
          ), 
          
          # 第四行第二列，日登陆频次绘图选项
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
        tabName = 'geo', 
        
        fluidRow(
          column(
            width = 9, 
            box(
              title = '用户登录定位统计', 
              leafletOutput('app_start', 
                            height = 700), 
              width = NULL, 
              height = 800,
              solidHeader = TRUE
            )
          ), 
          
          column(
            width = 3, 
            box(
              tags$div(title = 'app_start_city'), 
              selectizeInput('app_start_city', 
                             '选择城市', 
                             choices = city_location$city, 
                             selected = '西安市'), 
              width = NULL, 
              solidHeader = TRUE
            ), 
            
            box(
              tags$div(title = 'app_start_userType'), 
              selectInput('app_start_userType',
                          '用户类型',
                          choices = list(
                            '全体用户' = 'all', 
                            '新增用户' = 'new', 
                            '存量用户' = 'old'
                          ), 
                          selected = 'all'), 
              width = NULL, 
              solidHeader = TRUE
            ), 
            
            box(
              tags$div(title = 'app_start_date_range'), 
              dateRangeInput('app_start_date_range', 
                             label = '选择统计区间', 
                             min = min(app_start$time_stamp), 
                             max = max(app_start$time_stamp), 
                             start = max(app_start$time_stamp), 
                             language = 'zh-CN'), 
              width = NULL, 
              solidHeader = TRUE
            ), 
            
            box(
              tags$div(title = 'app_start_topArea'),
              tableOutput('topArea'),
              width = NULL,
              solidHeader = TRUE
            ),
            
            p(helpText('对登录次数前10的地区统计仅供参考，
                     当用户位于相邻城市如西安与咸阳交界处时，
                     用户可能基于距离而非行政区域被划分至不同城市。'), 
              style = 'font-size:85%'), 
            
            uiOutput('specific_user_geo_ui')
          )
        )
      ),
      
      tabItem(
        tabName = 'demographic', 
        
        fluidRow(
          column(width = 9, 
                 
               fluidRow(# 删除异常确定、年龄bar图
                 box(tags$div(title = paste0('一组数据的上下四分位数之间的距离为IQR， ', 
                               '通常将超过改组数据上下分位数1.5倍IQR的数据定为异常点'), 
                      checkboxInput('demographic_age_outlier', 
                              '去除异常年龄', 
                              value = TRUE)), 
                   width = NULL, 
                   solidHeader = TRUE, 
                   background = 'red'), 
                 
                 box(plotlyOutput('demographic_age_plot'), 
                   width = NULL, 
                   solidHeader = TRUE)
               ), 
               fluidRow(
                 column(width = 6, 
                    box(checkboxInput('demographic_gender_null', 
                            '去除未填写性别的用户', 
                            value = TRUE), 
                      width = NULL, 
                      solidHeader = TRUE, 
                      background = 'red'), 
                    
                    box(plotlyOutput('demographic_gender_plot'), 
                      width = NULL, 
                      solidHeader = TRUE)), # 删除异常确定、性别pie图
                 column(width = 6, 
                    box(checkboxInput('demographic_degree_null', 
                            '去除未填写受教育程度的用户', 
                            value = TRUE), 
                      width = NULL, 
                      solidHeader = TRUE, 
                      background = 'red'), 
                    
                    box(plotlyOutput('demographic_degree_plot'), 
                      width = NULL, 
                      solidHeader = TRUE))# 删除异常确定、学历pie图
               )), 
          column(width = 3, 
               box(selectizeInput(
                 'demographic_university_select', 
                 '选择学校', 
                 c('不限', 
                   na.omit(
                     unique(demographic$university[demographic$status_category == 1])
                   ))
               ), 
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
        
        br(), 
        br(),
        
        fluidRow(
          column(width = 9, 
               box(plotlyOutput('demographic_university_top10'), 
                 width = NULL, 
                 solidHeader = TRUE)), # 学校top10
          # column(width = 4, 
          #      box(plotlyOutput('demographic_heatmap'), 
          #        width = NULL, 
          #        solidHeader = TRUE)), # 学校学历热图
          column(width = 3, # 学校选择
               box(dateRangeInput('demographic_dateRange_2', 
                        '选择用户注册时段', 
                        min = min(daily_login$date_time), 
                        max = max(daily_login$date_time), 
                        start = min(daily_login$date_time), 
                        end = max(daily_login$date_time),
                        language = 'zh-CN'), 
                 width = NULL, 
                 solidHeader = TRUE), 
               p(helpText('选项对图4有效'), 
                 style = 'font-size:85%')) # 注册日期选择
        )
      ), 
      
      # 渠道来源及应用版本号
      tabItem(
        tabName = 'channel', 
        
          fluidRow(

            #　第一列
            column(
              width = 9,
              fluidRow(
                # 第一列中的第一行第一列，渠道来源
                column(
                  width = 6,
                  box(plotlyOutput('channel'),
                      width = NULL,
                      solidHeader = TRUE)
                ),

                # 第一列中第一行第二列，版本
                column(
                  width = 6,
                  box(plotlyOutput('versionCode'),
                      width = NULL,
                      solidHeader = TRUE)
                )
              ),

              # 第一列中的第二行，渠道版本热图
              fluidRow(
                box(plotlyOutput('channel_version_heatmap'),
                    width = NULL,
                    solidHeader = TRUE)
              )
            ),

            # 第二列，参数
            column(
              width = 3,
              box(checkboxInput('channel_null',
                                '去除无渠道来源的用户',
                                value = TRUE),
                  width = NULL,
                  solidHeader = TRUE,
                  background = 'red'),

              box(checkboxInput('channel_other',
                                '去除其他渠道来源的用户',
                                value = FALSE),
                  width = NULL,
                  solidHeader = TRUE,
                  background = 'red'),

              box(
                tags$div(title = 'channel_userType'),
                selectInput('channel_userType',
                            '用户类型',
                            choices = list(
                              '全体用户' = 'all',
                              '存量用户' = 'old',
                              '新增用户' = 'new'
                            ),
                            selected = 'all'),
                width = NULL,
                solidHeader = TRUE
              ),

              box(
                tags$div(title = 'channel_date_range'),
                dateRangeInput('channel_date_range',
                               label = '选择统计区间',
                               min = min(app_start$time_stamp),
                               max = max(app_start$time_stamp),
                               start = max(app_start$time_stamp),
                               language = 'zh-CN'),
                width = NULL,
                solidHeader = TRUE
              )
            )
          )
      )
    )
  )
))