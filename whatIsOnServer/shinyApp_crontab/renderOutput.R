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
})

output$con_but1_schedule <- renderText({
  sprintf("<font color=\'#FF0000\'><b> 已修改，修改时间：%s </b></font>", Sys.time())
})

observeEvent(input$refresh_cron_schedule, {
  crontab_schedule$time <- 
    c(input$cron_M_schedule, input$cron_H_schedule, input$cron_md_schedule, 
      input$cron_m_schedule, input$cron_wd_schedule)
  cronWrite(crontab_schedule, crontab, crontab_bak_path)
})

output$con_but2_schedule <- renderText({
  sprintf("<font color=\'#FF0000\'><b> 已修改，修改时间：%s </b></font>", Sys.time())
})