
output$train_company <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'train_company'], 
             '累计企业数', 
             icon('briefcase', lib = 'glyphicon'), 
             'purple')
})

output$train_course <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'train_course'], 
             '培训课程数', 
             icon('book'), 
             'purple')
})

output$train_user <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'train_user'], 
             '累计用户数', 
             icon('users'), 
             'purple')
})

output$train_plot <- renderDygraph({
    dygraph(train_data(), 
            main = sprintf('%s变化趋势',
                           switch(input$train_data_type,
                                  'new_company' = '活跃企业数',
                                  'new_course' = '新增培训课程数', 
                                  'active_user' = '活跃用户数', 
                                  'new_view' = '浏览数', 
                                  'new_collect' = '收藏数', 
                                  'new_apply' = '申请数', 
                                  'new_contact' = '联系数'))) %>% 
        dySeries(label = sprintf('%s',
                                 switch(input$train_data_type,
                                        'new_company' = '活跃企业数',
                                        'new_course' = '新增培训课程数', 
                                        'active_user' = '活跃用户数', 
                                        'new_view' = '浏览数', 
                                        'new_collect' = '收藏数', 
                                        'new_apply' = '申请数', 
                                        'new_contact' = '联系数'))) %>%
        dyOptions(fillGraph = TRUE, fillAlpha = 0.2, colors = 'purple') %>% 
        dyLegend(show = 'follow', hideOnMouseOut = TRUE) %>% 
        dyRangeSelector(dateWindow = input$calendar_date_range)
})