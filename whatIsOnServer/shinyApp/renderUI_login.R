
output$hourly_login_plot_select_render <- renderUI({
  selectInput(inputId = 'hourly_login_plot_select', 
              label = '选择指标', 
              choices = list(
                '新增用户数' = 'new', 
                '活跃用户数' = 'active', 
                '登陆次数' = 'log_in'
              ), selected = 'active')
})

output$hourly_login_plot_compare_render <- renderUI({
  selectInput(inputId = 'hourly_login_plot_compare', 
              label = '选择对比时间段', 
              choices = list(
                '昨日' = '1day', 
                '7日' = '7days', 
                '30日' = '30days'
              ), selected = '1day')
})

output$login_date_format_render <- renderUI({
    selectInput(inputId = 'login_date_format',
                label = '选择统计周期',
                choices = list(
                    '日' = 'daily',
                    '周' = 'weekly',
                    '月' = 'monthly'),
                selected = 'daily')
})

output$login_data_type_render <- renderUI({
    selectInput('login_data_type',
                label = '选择指标',
                choices = list('新增用户数' = 'new',
                               '活跃用户数' = 'active',
                               '登陆次数' = 'log_in',
                               '留存率' = 'retention'),
                selected = 'active')
})

output$login_date_range_render <- renderUI({
    dateRangeInput('login_date_range',
                   label = '选择统计区间',
                   min = min(daily_login$date_time),
                   max = max(daily_login$date_time),
                   start = Sys.Date() - 31,
                   language = 'zh-CN')
})


output$login_help_text <- renderUI({
    p(helpText(paste0('注意：当统计周期为周/月时， ',
                      '图的横坐标开始于所选周/月的第一天，表示当周/月，',
                      '如统计周期为周时，2016-04-11表示4月11日-18日这一周， ',
                      '而统计周期为月时，2016-04-01表示4月' )),
      style = 'font-size:85%')
})

output$login_data_type_freq_render <- renderUI({
    selectInput('login_data_type_freq',
                label = '选择指标',
                choices = list('日登陆频次' = 'daily_freq'),
                selected = 'daily_freq')
})

output$login_date_range_freq_render <- renderUI({
    dateRangeInput('login_date_range_freq',
                   label = '选择统计区间',
                   min = min(daily_login$date_time),
                   max = max(daily_login$date_time),
                   start = Sys.Date() - 31,
                   language = 'zh-CN')
})

output$login_freq_type_render <- renderUI({
    checkboxGroupInput('login_freq_type',
                       label = '选择频次区间',
                       choices = list('大于5次' = '5p',
                                      '5次' = '5',
                                      '4次' = '4',
                                      '3次' = '3',
                                      '2次' = '2',
                                      '1次' = '1'),
                       selected = '1')
})






















