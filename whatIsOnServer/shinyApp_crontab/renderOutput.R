
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


observeEvent(input$refresh_arg_schedule, {
  data.frame(
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
  
  output$con_button_arg_schedule <- myMessage()
})

observeEvent(input$refresh_cron_schedule, {
  crontab_schedule$time <- 
    c(input$cron_M_schedule, input$cron_H_schedule, input$cron_md_schedule, 
      input$cron_m_schedule, input$cron_wd_schedule)
  cronWrite(crontab_schedule, crontab, crontab_bak_path)
  
  output$con_button_cron_schedule <- myMessage()
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


observeEvent(input$refresh_arg_stone, {
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
  
  output$con_button_arg_stone <- myMessage()
})

observeEvent(input$refresh_cron_stone, {
  crontab_stone$time <- 
    c(input$cron_M_stone, input$cron_H_stone, input$cron_md_stone, 
      input$cron_m_stone, input$cron_wd_stone)
  cronWrite(crontab_stone, crontab, crontab_bak_path)
  
  output$con_button_cron_stone <- myMessage()
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






