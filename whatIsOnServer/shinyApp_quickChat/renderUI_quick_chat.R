
output$quick_chat_date_format_ui <- renderUI({
  selectInput('quick_chat_date_format', 
              label = '选择统计周期', 
              choices = list('小时' = 'hourly', 
                             '日' = 'daily', 
                             '周' = 'weekly', 
                             '月' = 'monthly'), 
              selected = 'daily')
})

output$quick_chat_data_type_ui <- renderUI({
  tags$div(title = paste0('活跃圈子：统计期内产生过聊天信息的圈子； ', 
                          '消息数：包括了统计期内产生的私聊与群聊消息； ', 
                          '活跃用户：统计期内主动发送过消息的用户'), 
           selectInput('quick_chat_data_type', 
                       label = '选择指标', 
                       choices = list('活跃圈子数' = 'active_circle', 
                                      '消息数' = 'message', 
                                      '活跃用户数' = 'active_user'), 
                       selected = 'message'))
})

output$quick_chat_date_range_ui <- renderUI({
  dateRangeInput('quick_chat_date_range', 
                 label = '选择统计区间', 
                 min = min(daily_quick_chat$date_time), 
                 max = max(daily_quick_chat$date_time), 
                 start = max(daily_quick_chat$date_time) - 31, 
                 language = 'zh-CN')
})

output$help_text_ui_1 <- renderUI({
  p(helpText(paste0('注意：当统计周期为周/月时， ', 
                    '图的横坐标开始于所选周/月的第一天，表示当周/月，', 
                    '如统计周期为周时，2016-04-11表示4月11日-18日这一周， ', 
                    '而统计周期为月时，2016-04-01表示4月' )), 
    style = 'font-size:85%')
})

output$help_text_ui_2 <- renderUI({
  p(helpText(paste0('注意：由于快信模块部分后台数据并非直接入库，而是', 
                    '采用每日4点和16点进行增量更新的方式，因此', 
                    '该模块所呈现的活跃圈子、消息数、活跃用户数等与聊天消息', 
                    '相关的指标均为上一个更新点时刻的数据。')), 
    style = 'font-size:90%')
})