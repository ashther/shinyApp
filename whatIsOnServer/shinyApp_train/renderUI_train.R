
output$train_date_format_ui <- renderUI({
  selectInput('train_date_format', 
              label = '选择统计周期', 
              choices = list('小时' = 'hourly', 
                             '日' = 'daily', 
                             '周' = 'weekly', 
                             '月' = 'monthly'), 
              selected = 'daily')
})

output$train_data_type_ui <- renderUI({
  tags$div(title = paste0('活跃企业：统计期内发布过培训信息的企业（不论相关培训信息是否还有效）； ', 
                          '新增培训课程：在统计期内发布的培训课程（不论是否还有效）； ', 
                          '活跃用户：统计期内浏览、收藏、申请过培训课程，或与企业联系的用户'), 
           selectInput('train_data_type', 
                       label = '选择指标', 
                       choices = list('活跃企业数' = 'new_company', 
                                      '新增培训课程数' = 'new_course', 
                                      '活跃用户数' = 'active_user', 
                                      '浏览数' = 'new_view', 
                                      '收藏数' = 'new_collect', 
                                      '申请数' = 'new_apply', 
                                      '联系数' = 'new_contact'), 
                       selected = 'active_user'))
})

output$help_text_ui_1 <- renderUI({
  p(helpText(paste0('注意：由于业务逻辑需要，同一用户对同一培训课程的', 
                    '操作动作在后台数据库中只记作一条记录，因此会存在', 
                    '部分数据前后统计不一致的情况，直观来看，会影响收藏数和', 
                    '联系数的统计准确度，请酌情参考')))
})

output$train_date_range_ui <- renderUI({
  dateRangeInput('train_date_range', 
                 label = '选择统计区间', 
                 min = min(daily_train$date_time), 
                 max = max(daily_train$date_time), 
                 start = max(daily_train$date_time) - 31, 
                 language = 'zh-CN')
})

output$help_text_ui_2 <- renderUI({
  p(helpText(paste0('注意：当统计周期为周/月时， ', 
                    '图的横坐标开始于所选周/月的第一天，表示当周/月，', 
                    '如统计周期为周时，2016-04-11表示4月11日-18日这一周， ', 
                    '而统计周期为月时，2016-04-01表示4月' )), 
    style = 'font-size:85%')
})