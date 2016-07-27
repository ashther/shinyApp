
output$hr_date_format_ui <- renderUI({
  selectInput('hr_date_format', 
              label = '选择统计周期', 
              choices = list('小时' = 'hourly', 
                             '日' = 'daily', 
                             '周' = 'weekly', 
                             '月' = 'monthly'), 
              selected = 'daily')
})


output$hr_data_type_ui <- renderUI({
  tags$div(title = paste0('新增个人用户：在统计期内创建了求职意向的个人用户； ', 
                          '新增企业：在统计期内新创建并通过了审核的企业用户； ', 
                          '新增招聘信息：在统计期内创建的招聘信息（不论是否过期）； ', 
                          '刷新招聘信息：在统计期内刷新过（创建时间在统计期之前）的招聘信息； ', 
                          '个人/企业用户操作：包括了用户浏览和收藏等所有动作'), 
           selectInput('hr_data_type', 
                       label = '选择指标', 
                       choices = list('新增个人用户' = 'new_user', 
                                      '新增企业数' = 'new_company', 
                                      '新增招聘信息数' = 'new_recruitment', 
                                      '刷新招聘信息数' = 'update_recruitment', 
                                      '个人用户操作数' = 'jobseekers_operation', 
                                      '企业用户操作数' = 'hr_operation'), 
                       selected = 'new_user'))
})


output$hr_date_range_ui <- renderUI({
  dateRangeInput('hr_date_range', 
                 label = '选择统计区间', 
                 min = min(daily_hr$date_time), 
                 max = max(daily_hr$date_time), 
                 start = max(daily_hr$date_time) - 31, 
                 language = 'zh-CN')
})

output$help_text_ui <- renderUI({
  p(helpText(paste0('注意：当统计周期为周/月时， ', 
                    '图的横坐标开始于所选周/月的第一天，表示当周/月，', 
                    '如统计周期为周时，2016-04-11表示4月11日-18日这一周， ', 
                    '而统计周期为月时，2016-04-01表示4月' )), 
    style = 'font-size:85%')
})