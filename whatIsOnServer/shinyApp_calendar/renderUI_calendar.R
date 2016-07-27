

output$calendar_date_format_ui <- renderUI({
  selectInput('calendar_date_format', 
              label = '选择统计周期', 
              choices = list('小时' = 'hourly', 
                             '日' = 'daily', 
                             '周' = 'weekly', 
                             '月' = 'monthly'), 
              selected = 'daily')
})


output$calendar_data_type_ui <- renderUI({
  tags$div(title = paste0('新增活动：在统计期内创建的活动，不论是否已结束； ', 
                          '新增用户：在统计期内新加入过活动的用户； '), 
           selectInput('calendar_data_type', 
                       label = '选择指标', 
                       choices = list('新增活动数' = 'new_activity', 
                                      '新增用户数' = 'new_user'), 
                       selected = 'new_user'))
})


output$calendar_date_range_ui <- renderUI({
  dateRangeInput('calendar_date_range', 
                 label = '选择统计区间', 
                 min = min(daily_calendar$date_time), 
                 max = max(daily_calendar$date_time), 
                 start = max(daily_calendar$date_time) - 31, 
                 language = 'zh-CN')
})

output$help_text_ui <- renderUI({
  p(helpText(paste0('注意：当统计周期为周/月时， ', 
                    '图的横坐标开始于所选周/月的第一天，表示当周/月，', 
                    '如统计周期为周时，2016-04-11表示4月11日-18日这一周， ', 
                    '而统计周期为月时，2016-04-01表示4月' )), 
    style = 'font-size:85%')
})
