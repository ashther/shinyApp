
output$schedule_course <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'schedule_course'], 
             '累计课程数', 
             icon('university'), 
             'yellow')
})

output$schedule_courseware <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'schedule_courseware'], 
             '累计课件数', 
             icon('upload'), 
             'yellow')
})

output$schedule_homework <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'schedule_homework'], 
             '累计作业数', 
             icon('upload'), 
             'yellow')
})

output$avg_course_user <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'avg_course_user'], 
             '课程平均学习者数', 
             icon('users'), 
             'yellow')
})

output$schedule_plot <- renderDygraph({
    dygraph(schedule_data(), 
            main = sprintf('%s变化趋势',
                           switch(input$schedule_data_type,
                                  'new_course' = '新增课程数',
                                  'new_user' = '新增用户数', 
                                  'active_user' = '活跃用户数', 
                                  'new_file' = '新增课程文件数', 
                                  'operation' = '操作数'))) %>% 
        dySeries(label = sprintf('%s',
                                 switch(input$schedule_data_type,
                                        'new_course' = '新增课程数',
                                        'new_user' = '新增用户数', 
                                        'active_user' = '活跃用户数', 
                                        'new_file' = '新增课程文件数', 
                                        'operation' = '操作数'))) %>%
        dyOptions(fillGraph = TRUE, fillAlpha = 0.2, colors = 'orange') %>% 
        dyLegend(show = 'follow', hideOnMouseOut = TRUE) %>% 
        dyRangeSelector(dateWindow = input$calendar_date_range)
})

output$operate_table <- renderDataTable(
  operate_data(), 
  options = list(
    pageLength = 25
  )
)