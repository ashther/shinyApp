
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
      menuItem('自贸区', 
           tabName = 'trade', 
           icon = icon('rmb'))
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
            dygraphOutput('trade_plot')
          ), 
          
          # 第二行第二列，绘图选项
          column(
            width = 4, 
            
            # 小时/日/周/月选项
            uiOutput('trade_date_format_ui'), 
            
            # 数据类型选项
            uiOutput('trade_data_type_ui'), 
            
            # 时间范围选项
            uiOutput('trade_date_range_ui'),
            
            uiOutput('help_text_ui_1')
          )
        ), 
        
        br(), 
        br(), 
        
        fluidRow(
          
          column(
            width = 8, 
            plotlyOutput('trade_price')
          ), 
          
          column(
            width = 4, 
            
            uiOutput('price_type_ui'), 
            
            uiOutput('price_category_ui'),
            
            uiOutput('price_outlier_ui')
          )
        )
        
        # br(), 
        # br(),
        # 
        # #第四行，地图
        # fluidRow(
        #   
        #   # 第四行第一列，地图
        #   column(
        #     width = 8, 
        #     tags$div(title = '地图中气泡所代表的是发布出售商品信息的个人用户地址信息，并非实时定位信息', 
        #              leafletOutput('user_location'))
        #   ), 
        #   
        #   # 第四行第二列，地图选项
        #   column(
        #     width = 4, 
        #     
        #     # 省份选项
        #     uiOutput('province_ui'), 
        #     
        #     # 城市选项
        #     uiOutput('city_ui'), 
        #     
        #     # 日期选项
        #     uiOutput('map_date_range_ui')
        #   )
        # )
      )
    )
  )
))