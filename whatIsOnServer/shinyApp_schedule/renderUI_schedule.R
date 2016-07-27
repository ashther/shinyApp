
output$schedule_date_format_ui <- renderUI({
  selectInput('schedule_date_format', 
              label = '选择统计周期', 
              choices = list('小时' = 'hourly', 
                             '日' = 'daily', 
                             '周' = 'weekly', 
                             '月' = 'monthly'), 
              selected = 'daily')
})


output$schedule_data_type_ui <- renderUI({
  tags$div(title = paste0('新增课程：统计期内被用户创建的课程', 
                          '（系统创建的不纳入统计范围）； ', 
                          '新增用户：统计期内加入课程的学习者用户', 
                          '（被创建者以花名册形式导入但没有思扣账号的不纳入统计范围）； ', 
                          '活跃用户：统计期内浏览、收藏、下载、上传课件或作业（包括删除作业）的用户； ',
                          '新增课程文件：统计期内被上传的课件或作业； ', 
                          '操作数：统计期内与课件或作业有关的浏览、收藏、下载、上传或删除动作的计数'), 
           selectInput('schedule_data_type', 
                       label = '选择指标', 
                       choices = list('新增课程数' = 'new_course',
                                      '新增用户数' = 'new_user', 
                                      '活跃用户数' = 'active_user', 
                                      '新增课程文件数' = 'new_file', 
                                      '操作数' = 'operation'), 
                       selected = 'new_user'))
})


output$schedule_date_range_ui <- renderUI({
  dateRangeInput('schedule_date_range', 
                 label = '选择统计区间', 
                 min = min(daily_schedule$date_time), 
                 max = max(daily_schedule$date_time), 
                 start = max(daily_schedule$date_time) - 31, 
                 language = 'zh-CN')
})


output$help_text_ui_1 <- renderUI({
  p(helpText(paste0('注意：当统计周期为周/月时， ', 
                    '图的横坐标开始于所选周/月的第一天，表示当周/月，', 
                    '如统计周期为周时，2016-04-11表示4月11日-18日这一周， ', 
                    '而统计周期为月时，2016-04-01表示4月' )), 
    style = 'font-size:85%')
})