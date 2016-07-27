
output$calendar_activity <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'calendar_activity'], 
             '累计活动数', 
             icon('calendar'), 
             'light-blue')
})

output$avg_activity_user <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'avg_activity_user'], 
             '活动平均用户数', 
             icon('users'), 
             'light-blue')
})

output$calendar_plot <- renderDygraph({
    dygraph(calendar_data(), 
            main = sprintf('%s变化趋势',
                           switch(input$calendar_data_type,
                                  'new_activity' = '新增活动数',
                                  'new_user' = '新增用户数'))) %>% 
        dySeries(label = sprintf('%s',
                                 switch(input$calendar_data_type,
                                        'new_activity' = '新增活动数',
                                        'new_user' = '新增用户数'))) %>%
        dyOptions(fillGraph = TRUE, fillAlpha = 0.2, colors = 'light-blue') %>% 
        dyLegend(show = 'follow', hideOnMouseOut = TRUE) %>% 
        dyRangeSelector(dateWindow = input$calendar_date_range)
})