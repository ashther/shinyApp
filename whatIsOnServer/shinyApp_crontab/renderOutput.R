
# ============================ schedule ======================

output$result_table_schedule <- renderTable(
  rec_log %>% 
    filter(table_name == 'event') %>% 
    arrange(desc(start_time)) %>% 
    select(-start_date) %>% 
    head(3), 
  striped = TRUE, 
  hover = TRUE, 
  align = 'c'
)

output$result_plot_schedule <- renderPlotly({
  temp <- filter(rec_log_plot, table_name == 'event')
  
  p_n <- simplePlot(temp, 'start_date', 'recommend_n')
  p_user <- simplePlot(temp, 'start_date', 'user_n')
  p_item <- simplePlot(temp, 'start_date', 'item_n')
  p_update <- simplePlot(temp, 'start_date', 'update_time')
  
  subplot(p_n, p_user, p_item, p_update, nrows = 2, 
          titleX = FALSE, titleY = TRUE, margin = 0.07) %>% 
    hide_legend()
})

output$log_schedule <- renderPrint({
  log_schedule
})


observeEvent(input$modify_arg_schedule, {
  withProgress(message = '修改参数...', value = 0, {
    setProgress(0.5)
    
    status <- data.frame(
      arg = arg_schedule$arg, 
      value = c(
        input$schedule_arg_interval_days, 
        input$schedule_arg_active_user_days,
        input$schedule_arg_popular_weight,
        input$schedule_arg_friend_weight,
        input$schedule_arg_vitae_weight,
        input$schedule_arg_CF_weight,
        input$schedule_arg_attence_weight,
        input$schedule_arg_opreate_weight,
        input$schedule_arg_file_weight,
        input$schedule_arg_roster_weight, 
        input$schedule_arg_thr,
        input$schedule_arg_k
      ), 
      stringsAsFactors = FALSE, row.names = NULL
    ) %>% 
      argWrite(schedule_arg_path)
    
    output$con_button_arg_schedule <- myMessage(status)
    
    setProgress(1)
  })
})

observeEvent(input$refresh_arg_schedule, {
  output$con_button_arg_schedule <- renderText({})
  arg_schedule <- argParse(schedule_arg_path)
  
  updateTextInput(session, 'schedule_arg_interval_days', '间隔时间（天）',
                  value = arg_schedule$value[arg_schedule$arg == 'interval_days']) 
  updateTextInput(session, 'schedule_arg_active_user_days', '活跃用户时间（天）',
                  value = arg_schedule$value[arg_schedule$arg == 'active_user_days'])
  updateTextInput(session, 'schedule_arg_thr', '阈值',
                  value = arg_schedule$value[arg_schedule$arg == 'thr'])
  updateTextInput(session, 'schedule_arg_k', '推荐数',
                  value = arg_schedule$value[arg_schedule$arg == 'k'])
  updateTextInput(session, 'schedule_arg_popular_weight', '流行度权重',
                  value = arg_schedule$value[arg_schedule$arg == 'popular_weight'])
  updateTextInput(session, 'schedule_arg_friend_weight', '友邻权重',
                  value = arg_schedule$value[arg_schedule$arg == 'friend_weight'])
  updateTextInput(session, 'schedule_arg_vitae_weight', '状态权重',
                  value = arg_schedule$value[arg_schedule$arg == 'vitae_weight'])
  updateTextInput(session, 'schedule_arg_CF_weight', '协作过滤权重',
                  value = arg_schedule$value[arg_schedule$arg == 'CF_weight'])
  updateTextInput(session, 'schedule_arg_attence_weight', '出席权重（用户评分）',
                  value = arg_schedule$value[arg_schedule$arg == 'attence_weight'])
  updateTextInput(session, 'schedule_arg_opreate_weight', '操作权重（用户评分）',
                  value = arg_schedule$value[arg_schedule$arg == 'operate_weight'])
  updateTextInput(session, 'schedule_arg_file_weight', '文件权重（课程相似度）',
                  value = arg_schedule$value[arg_schedule$arg == 'file_weight'])
  updateTextInput(session, 'schedule_arg_roster_weight', '推荐数（课程相似度）',
                  value = arg_schedule$value[arg_schedule$arg == 'roster_weight'])
})

observeEvent(input$modify_cron_schedule, {
  withProgress(message = '修改定时任务...', value = 0, {
    
    setProgress(0.33)
    crontab <- cronGet()
    
    setProgress(0.67)
    crontab_schedule$time <- 
      c(input$cron_M_schedule, input$cron_H_schedule, input$cron_md_schedule, 
        input$cron_m_schedule, input$cron_wd_schedule)
    status <- cronWrite(crontab_schedule, crontab, crontab_bak_path)
    
    output$con_button_cron_schedule <- myMessage(status)
    setProgress(1)
  })
})

observeEvent(input$refresh_cron_schedule, {
  output$con_button_cron_schedule <- renderText({})
  withProgress(message = '获取定时任务...', value = 0, {
    setProgress(0.5)
    crontab <- cronGet()
    
    setProgress(0.75)
    crontab_schedule <<- cronParse(crontab, '/schedule/')
    
    setProgress(1)
  })
  
  updateTextInput(session, 'cron_M_schedule', '分', value = crontab_schedule$time[1])
  updateTextInput(session, 'cron_H_schedule', '时', value = crontab_schedule$time[2])
  updateTextInput(session, 'cron_md_schedule', '日', value = crontab_schedule$time[3])
  updateTextInput(session, 'cron_m_schedule', '月', value = crontab_schedule$time[4])
  updateTextInput(session, 'cron_wd_schedule', '周天', value = crontab_schedule$time[5])
})

# ============================= stone ============================

output$result_table_stone <- renderTable(
  rec_log %>% 
    filter(table_name == 'stone') %>% 
    arrange(desc(start_time)) %>% 
    select(-start_date) %>% 
    head(3), 
  striped = TRUE, 
  hover = TRUE, 
  align = 'c'
)

output$result_plot_stone <- renderPlotly({
  temp <- filter(rec_log_plot, table_name == 'stone')
  
  p_n <- simplePlot(temp, 'start_date', 'recommend_n')
  p_update <- simplePlot(temp, 'start_date', 'update_time')
  
  subplot(p_n, p_update,
          titleX = FALSE, titleY = TRUE, margin = 0.07) %>% 
    hide_legend()
})

output$log_stone <- renderPrint({
  log_stone
})


observeEvent(input$modify_arg_stone, {
  withProgress(message = '修改参数...', value = 0, {
    
    setProgress(0.5)
    
    status <- 
      data.frame(
        arg = arg_stone$arg, 
        value = c(
          input$stone_arg_stopwords, 
          input$stone_arg_topn, 
          input$stone_arg_resp_weight, 
          input$stone_arg_reqr_weight, 
          input$stone_arg_create_idf
        ), 
        stringsAsFactors = FALSE, row.names = NULL
      ) %>%
      argWrite(stone_arg_path)
    
    output$con_button_arg_stone <- myMessage(status)

    setProgress(1)
  }) 
})

observeEvent(input$refresh_arg_stone, {
  output$con_button_arg_stone <- renderText({})
  arg_stone <- argParse(stone_arg_path)
  
  updateTextInput(session, 
                  'stone_arg_stopwords', '停止词',
                  value = arg_stone$value[arg_stone$arg == 'stopwords'])
  updateTextInput(session, 
                  inputId = 'stone_arg_topn', 
                  value = arg_stone$value[arg_stone$arg == 'topn'])
  updateTextInput(session, 
                  'stone_arg_resp_weight', '岗位职责权重',
                  value = arg_stone$value[arg_stone$arg == 'resp_weight'])
  updateTextInput(session, 
                  'stone_arg_reqr_weight', '任职要求权重',
                  value = arg_stone$value[arg_stone$arg == 'reqr_weight'])
  updateTextInput(session, 
                  'stone_arg_create_idf', '是否新建idf文件',
                  value = arg_stone$value[arg_stone$arg == 'create_idf'])
  
})

observeEvent(input$modify_cron_stone, {
 withProgress(message = '修改定时任务...',value = 0, {
   
   setProgress(0.33)
   crontab <- cronGet()
   
   setProgress(0.67)
   crontab_stone$time <- 
     c(input$cron_M_stone, 
       input$cron_H_stone, 
       input$cron_md_stone, 
       input$cron_m_stone, 
       input$cron_wd_stone)
   
   status <- cronWrite(crontab_stone, crontab, crontab_bak_path)
   
   output$con_button_cron_stone <- myMessage(status)

   setProgress(1)
 })
})

observeEvent(input$refresh_cron_stone, {
  output$con_button_cron_stone <- renderText({})
  withProgress(message = '获取定时任务...', value = 0, {
    setProgress(0.5)
    crontab <- cronGet()
    
    setProgress(0.75)
    crontab_stone <<- cronParse(crontab, '/stone')
    
    setProgress(1)
  })
  
  updateTextInput(session, 'cron_M_stone', '分', value = crontab_stone$time[1])
  updateTextInput(session, 'cron_H_stone', '时', value = crontab_stone$time[2])
  updateTextInput(session, 'cron_md_stone', '日', value = crontab_stone$time[3])
  updateTextInput(session, 'cron_m_stone', '月', value = crontab_stone$time[4])
  updateTextInput(session, 'cron_wd_stone', '周天', value = crontab_stone$time[5])
})

# ============================== friend ===============================

output$result_table_friend <- renderTable(
  rec_log %>% 
    filter(table_name == 'friend') %>% 
    arrange(desc(start_time)) %>% 
    select(-start_date) %>% 
    head(3), 
  striped = TRUE, 
  hover = TRUE, 
  align = 'c'
)

output$result_plot_friend <- renderPlotly({
  temp <- filter(rec_log_plot, table_name == 'friend')
  
  p_n <- simplePlot(temp, 'start_date', 'recommend_n')
  p_user <- simplePlot(temp, 'start_date', 'user_n')
  p_item <- simplePlot(temp, 'start_date', 'item_n')
  p_update <- simplePlot(temp, 'start_date', 'update_time')
  
  subplot(p_n, p_user, p_item, p_update, nrows = 2,
          titleX = FALSE, titleY = TRUE, margin = 0.07) %>% 
    hide_legend()
})

# ============================ circle =================================
output$result_table_circle <- renderTable(
  rec_log %>% 
    filter(table_name == 'circle') %>% 
    arrange(desc(start_time)) %>% 
    select(-start_date) %>% 
    head(3), 
  striped = TRUE, 
  hover = TRUE, 
  align = 'c'
)

output$result_plot_circle <- renderPlotly({
  temp <- filter(rec_log_plot, table_name == 'circle')
  
  p_n <- simplePlot(temp, 'start_date', 'recommend_n')
  p_user <- simplePlot(temp, 'start_date', 'user_n')
  p_item <- simplePlot(temp, 'start_date', 'item_n')
  p_update <- simplePlot(temp, 'start_date', 'update_time')
  
  subplot(p_n, p_user, p_item, p_update, nrows = 2,
          titleX = FALSE, titleY = TRUE, margin = 0.07) %>% 
    hide_legend()
})


output$test <- renderPrint({
  
})






