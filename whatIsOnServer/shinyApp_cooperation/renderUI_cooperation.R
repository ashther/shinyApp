

output$cooperation_date_format_ui <- renderUI({
  selectInput('cooperation_date_format', 
              label = '寻找统计周期', 
              choices = list('小时' = 'hourly', 
                             '日' = 'daily', 
                             '周' = 'weekly', 
                             '月' = 'monthly'), 
              selected = 'daily')
})


output$cooperation_data_type_ui <- renderUI({
  tags$div(title = paste0('活跃企业：统计期内发布过项目的企业，不论项目是否过期； ', 
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
                       selected = 'active_user'))
})


output$calendar_date_range_ui <- renderUI({
  dateRangeInput('calendar_date_range', 
                 label = '选择统计区间', 
                 min = min(daily_cooperation$date_time), 
                 max = max(daily_cooperation$date_time), 
                 start = max(daily_cooperation$date_time) - 31, 
                 language = 'zh-CN')
})

output$help_text_ui <- renderUI({
  p(helpText(paste0('注意：当统计周期为周/月时， ', 
                    '图的横坐标开始于所选周/月的第一天，表示当周/月，', 
                    '如统计周期为周时，2016-04-11表示4月11日-18日这一周， ', 
                    '而统计周期为月时，2016-04-01表示4月' )), 
    style = 'font-size:85%')
})