

shinyUI(fluidPage(
  
  initStore('store', 'shinyApp_download'), 
  
  div(class = "login",
      uiOutput("uiLogin"),
      textOutput("pass")
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel(
        'friend', 
        tableOutput('result_table_friend'), 
        
        fluidRow(
          column(width = 4, plotlyOutput('result_plot_n_friend')), 
          column(width = 4, plotlyOutput('result_plot_user_friend')), 
          column(width = 4, plotlyOutput('result_plot_item_friend'))
        ), 
        
        hr(),
        
        actionButton('refresh_arg_friend', '确认新参数'), 
        
        fluidRow(
          column(
            width = 4, 
            textInput('friend_arg_interval_days', '间隔时间（天）', value = ''), 
            textInput('friend_arg_active_user_days', '活跃用户时间（天）', value = ''),
            textInput('friend_arg_thr', '阈值', value = ''),
            textInput('friend_arg_k', '推荐数', value = '')
          ), 
          column(
            width = 4, 
            textInput('friend_arg_popular_weight', '流行度权重', value = ''), 
            textInput('friend_arg_friend_weight', '友邻权重', value = ''),
            textInput('friend_arg_vitae_weight', '状态权重', value = ''),
            textInput('friend_arg_CF_weight', '协作过滤权重', value = '')
          ), 
          column(
            width = 4, 
            textInput('friend_arg_attence_weight', '出席权重（用户评分）', value = ''), 
            textInput('friend_arg_opreate_weight', '操作权重（用户评分）', value = ''),
            textInput('friend_arg_file_weight', '文件权重（课程相似度）', value = ''),
            textInput('friend_arg_roster_weight', '推荐数（课程相似度）', value = '')
          )
        ), 
        
        hr(), 
        actionButton('refresh_cron_friend', '确认新定时'), 
        
        textInput('cron_friend', '定时任务', value = '')
      ),
      
      tabPanel(
        'circle'
      )
    )
  )
))