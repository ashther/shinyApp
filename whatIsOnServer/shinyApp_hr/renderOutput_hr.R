
output$jobseeker <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'jobseeker'], 
             '求职用户数', 
             icon('users'), 
             'blue')
})

output$hr_company <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'hr_company'], 
             '招聘企业数', 
             icon('briefcase', lib = 'glyphicon'), 
             'blue')
})

output$recruitment <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'recruitment'], 
             '招聘信息数', 
             icon('file-text'), 
             'blue')
})

output$hr_plot <- renderDygraph({
    dygraph(hr_data(), 
            main = sprintf('%s变化趋势',
                           switch(input$hr_data_type,
                                  'new_user' = '新增个人用户',
                                  'new_company' = '新增企业数', 
                                  'new_recruitment' = '新增招聘信息数', 
                                  'update_recruitment' = '刷新招聘信息数', 
                                  'jobseekers_operation' = '个人用户操作数', 
                                  'hr_operation' = '企业用户操作数'))) %>% 
        dySeries(label = sprintf('%s',
                                 switch(input$hr_data_type,
                                        'new_user' = '新增个人用户',
                                        'new_company' = '新增企业数', 
                                        'new_recruitment' = '新增招聘信息数', 
                                        'update_recruitment' = '刷新招聘信息数', 
                                        'jobseekers_operation' = '个人用户操作数', 
                                        'hr_operation' = '企业用户操作数'))) %>%
        dyOptions(fillGraph = TRUE, fillAlpha = 0.2, colors = 'blue') %>% 
        dyLegend(show = 'follow', hideOnMouseOut = TRUE) %>% 
        dyRangeSelector(dateWindow = input$calendar_date_range)
})