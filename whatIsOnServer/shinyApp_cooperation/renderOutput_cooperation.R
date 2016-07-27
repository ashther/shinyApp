
output$cooperation_company <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'cooperation_company'], 
             '累计企业数', 
             icon('briefcase', lib = 'glyphicon'), 
             'green')
})

output$cooperation_project <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'cooperation_project'], 
             '累计项目数', 
             icon('folder-open', lib = 'glyphicon'), 
             'green')
})

output$cooperation_user <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'cooperation_user'], 
             '累计用户数', 
             icon('users'), 
             'green')
})

output$cooperation_plot <- renderDygraph({
    dygraph(cooperation_data(), 
            main = sprintf('%s变化趋势',
                           switch(input$cooperation_data_type,
                                  'new_company' = '活跃企业数',
                                  'new_project' = '新增项目数', 
                                  'active_user' = '活跃用户数', 
                                  'new_view' = '浏览数', 
                                  'new_collect' = '收藏数', 
                                  'new_apply' = '申请数'))) %>% 
        dySeries(label = sprintf('%s',
                                 switch(input$cooperation_data_type,
                                        'new_company' = '活跃企业数',
                                        'new_project' = '新增项目数', 
                                        'active_user' = '活跃用户数', 
                                        'new_view' = '浏览数', 
                                        'new_collect' = '收藏数', 
                                        'new_apply' = '申请数'))) %>%
        dyOptions(fillGraph = TRUE, fillAlpha = 0.2, colors = 'green') %>% 
        dyLegend(show = 'follow', hideOnMouseOut = TRUE) %>% 
        dyRangeSelector(dateWindow = input$calendar_date_range)
})