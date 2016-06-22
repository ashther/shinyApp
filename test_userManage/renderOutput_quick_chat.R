
output$quick_chat_circle <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'quick_chat_circle'], 
             '累计圈子数', 
             icon('object-group'), 
             'olive')
})

output$avg_circle_user <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'avg_circle_user'], 
             '圈子平均用户数', 
             icon('users'), 
             'olive')
})

output$quick_chat_plot <- renderDygraph({
    dygraph(quick_chat_data(), 
            main = sprintf('%s变化趋势',
                           switch(input$quick_chat_data_type,
                                  'active_circle' = '活跃圈子数',
                                  'message' = '消息数',
                                  'active_user' = '活跃用户数'))) %>% 
        dySeries(label = sprintf('%s',
                                 switch(input$quick_chat_data_type,
                                        'active_circle' = '活跃圈子数',
                                        'message' = '消息数',
                                        'active_user' = '活跃用户数'))) %>% 
        dyOptions(fillGraph = TRUE, fillAlpha = 0.2, colors = 'olive') %>% 
        dyLegend(show = 'follow', hideOnMouseOut = TRUE) %>% 
        dyRangeSelector(dateWindow = input$quick_chat_date_range)
})