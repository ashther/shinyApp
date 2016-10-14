output$mainPanel <- renderUI({
  
  # verbatimTextOutput('test'), 
  tabsetPanel(
    tabPanel(
      
      # ====================== schedule ==========================
      'schedule', 
      tableOutput('result_table_schedule'), 
      plotlyOutput('result_plot_schedule'), 
      verbatimTextOutput('log_schedule'), 
      
      hr(),
      
      fluidRow(
        column(
          width = 10, 
          conditionalPanel(
            "output.superUser == 1", 
            actionButton('modify_arg_schedule', 
                         '修改参数', 
                         icon = icon('warning'), 
                         style = 'color: #fff; background-color: #ff0000;')
          )
        ), 
        
        column(
          width = 2, 
          actionButton('refresh_arg_schedule', 
                       '刷新', 
                       style = 'color: #fff; background-color: #0000ff;')
        )
      ), 
      htmlOutput('con_button_arg_schedule'), 
      
      br(), 
      fluidRow(
        column(
          width = 4, 
          textInput('schedule_arg_interval_days', '间隔时间（天）', 
                    value = arg_schedule$value[arg_schedule$arg == 'interval_days']), 
          textInput('schedule_arg_active_user_days', '活跃用户时间（天）', 
                    value = arg_schedule$value[arg_schedule$arg == 'active_user_days']),
          textInput('schedule_arg_thr', '阈值', 
                    value = arg_schedule$value[arg_schedule$arg == 'thr']),
          textInput('schedule_arg_k', '推荐数', 
                    value = arg_schedule$value[arg_schedule$arg == 'k'])
        ), 
        column(
          width = 4, 
          textInput('schedule_arg_popular_weight', '流行度权重', 
                    value = arg_schedule$value[arg_schedule$arg == 'popular_weight']), 
          textInput('schedule_arg_friend_weight', '友邻权重', 
                    value = arg_schedule$value[arg_schedule$arg == 'friend_weight']),
          textInput('schedule_arg_vitae_weight', '状态权重', 
                    value = arg_schedule$value[arg_schedule$arg == 'vitae_weight']),
          textInput('schedule_arg_CF_weight', '协作过滤权重', 
                    value = arg_schedule$value[arg_schedule$arg == 'CF_weight'])
        ), 
        column(
          width = 4, 
          textInput('schedule_arg_attence_weight', '出席权重（用户评分）', 
                    value = arg_schedule$value[arg_schedule$arg == 'attence_weight']), 
          textInput('schedule_arg_opreate_weight', '操作权重（用户评分）', 
                    value = arg_schedule$value[arg_schedule$arg == 'operate_weight']),
          textInput('schedule_arg_file_weight', '文件权重（课程相似度）', 
                    value = arg_schedule$value[arg_schedule$arg == 'file_weight']),
          textInput('schedule_arg_roster_weight', '推荐数（课程相似度）', 
                    value = arg_schedule$value[arg_schedule$arg == 'roster_weight'])
        )
      ), 
      
      hr(), 
      
      fluidRow(
        column(
          width = 10, 
          conditionalPanel(
            "output.superUser == 1", 
            actionButton('modify_cron_schedule', 
                         '修改定时', 
                         icon = icon('warning'), 
                         style = 'color: #fff; background-color: #ff0000;')
          )
        ), 
        
        column(
          width = 2, 
          actionButton('refresh_cron_schedule', 
                       '获取/刷新', 
                       style = 'color: #fff; background-color: #0000ff;')
        )
      ), 
      htmlOutput('con_button_cron_schedule'), 
      
      br(),
      fluidRow(
        column(width = 2, textInput('cron_M_schedule', '分')),
        column(width = 2, textInput('cron_H_schedule', '时')), 
        column(width = 2, textInput('cron_md_schedule', '日')), 
        column(width = 2, textInput('cron_m_schedule', '月')), 
        column(width = 2, textInput('cron_wd_schedule', '周天'))
      )
    ), 
    
    tabPanel(
      
      # ====================== stone ==========================
      'stone', 
      tableOutput('result_table_stone'), 
      plotlyOutput('result_plot_stone'), 
      verbatimTextOutput('log_stone'), 
      
      hr(),
      
      fluidRow(
        column(
          width = 10, 
          conditionalPanel(
            "output.superUser == 1", 
            actionButton('modify_arg_stone', 
                         '修改参数', 
                         icon = icon('warning'), 
                         style = 'color: #fff; background-color: #ff0000;')
          )
        ), 
        
        column(
          width = 2, 
          actionButton('refresh_arg_stone', 
                       '刷新', 
                       style = 'color: #fff; background-color: #0000ff;')
        )
      ), 
      htmlOutput('con_button_arg_stone'), 
      
      br(), 
      fluidRow(
        column(
          width = 4, 
          textInput('stone_arg_stopwords', '停止词', 
                    value = arg_stone$value[arg_stone$arg == 'stopwords']), 
          textInput('stone_arg_topn', '关键词数量', 
                    value = arg_stone$value[arg_stone$arg == 'topn'])
        ), 
        column(
          width = 4, 
          textInput('stone_arg_resp_weight', '岗位职责权重', 
                    value = arg_stone$value[arg_stone$arg == 'resp_weight']), 
          textInput('stone_arg_reqr_weight', '任职要求权重', 
                    value = arg_stone$value[arg_stone$arg == 'reqr_weight'])
        ), 
        column(
          width = 4, 
          textInput('stone_arg_create_idf', '是否新建idf文件', 
                    value = arg_stone$value[arg_stone$arg == 'create_idf'])
        )
      ), 
      
      hr(), 
      
      fluidRow(
        column(
          width = 10, 
          conditionalPanel(
            "output.superUser == 1", 
            actionButton('modify_cron_stone', 
                         '修改定时', 
                         icon = icon('warning'), 
                         style = 'color: #fff; background-color: #ff0000;')
          )
        ), 
        
        column(
          width = 2, 
          actionButton('refresh_cron_stone', 
                       '获取/刷新', 
                       style = 'color: #fff; background-color: #0000ff;')
        )
      ), 
      htmlOutput('con_button_cron_stone'), 
      
      br(),
      fluidRow(
        column(width = 2, textInput('cron_M_stone', '分')),
        column(width = 2, textInput('cron_H_stone', '时')), 
        column(width = 2, textInput('cron_md_stone', '日')), 
        column(width = 2, textInput('cron_m_stone', '月')), 
        column(width = 2, textInput('cron_wd_stone', '周天'))
      )
    ), 
    
    tabPanel(
      
      # ====================== friend ==========================
      'friend', 
      tableOutput('result_table_friend'), 
      plotlyOutput('result_plot_friend')
    ), 
    
    tabPanel(
      
      # ====================== circle ==========================
      'circle', 
      tableOutput('result_table_circle'), 
      plotlyOutput('result_plot_circle')
    )
  )
  
})

output$sidebarPanel <- renderUI({
  sidebarPanel(
    actionButton('action', 'Search'), 
    
    hr(), 
    br(), 
    
   actionButton('exit', '退出当前账号') 
  )
})

