
output$hourly_login_plot <- renderDygraph({
    dygraph(cbind(hourly_new, hourly_active), 
            main = '新增及活跃用户数（每小时）') %>% 
        dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>% 
        dyAxis('y', independentTicks = TRUE) %>% 
        dyAxis('y2', independentTicks = FALSE) %>% 
        dySeries('new', label = '新增用户数', axis = 'y') %>% 
        dySeries('active', label = '活跃用户数', axis = 'y2') %>%
        dyOptions(fillGraph = FALSE, fillAlpha = 0.2) %>% 
        dyLegend(show = 'always', hideOnMouseOut = TRUE) %>% 
        dyRangeSelector(dateWindow = c(as.POSIXct(Sys.Date() - 1), 
                                       Sys.time()))
})

# 累计用户数
output$total_user <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'total_user'], 
             '累计用户数', 
             icon('users'))
})

# 当日新增用户数
output$new_user_today <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'new_user'], 
             '当日新增用户数', 
             icon('user-plus'))
})

# 当日活跃用户数
output$active_user_today <- renderValueBox({
    valueBox(sprintf('%s(%s%%)', 
                     point_data$value[point_data$item == 'active_user'], 
                     round(100 - point_data$value[point_data$item == 'active_user_new'] / 
                               point_data$value[point_data$item == 'active_user'] * 100, 2)), 
             '当日活跃用户数', 
             icon('user'))
})

# 当日登陆次数
output$login_times_today <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'login_times'], 
             '当日登录次数', 
             icon('power-off'))
})

# 登录数据绘图渲染
output$login_plot_1 <- renderDygraph({
    dygraph(login_data(), 
            main = sprintf('%s变化趋势',
                           switch(input$login_data_type,
                                  'new' = '新增用户数',
                                  'active' = '活跃用户数',
                                  'log_in' = '登陆次数',
                                  'retention' = '留存率'))) %>% 
        dySeries(label = sprintf('%s',
                                 switch(input$login_data_type,
                                        'new' = '新增用户数',
                                        'active' = '活跃用户数',
                                        'log_in' = '登陆次数',
                                        'retention' = '留存率'))) %>% 
        dyOptions(fillGraph = TRUE, fillAlpha = 0.2) %>% 
        dyLegend(show = 'follow', hideOnMouseOut = TRUE) %>% 
        dyRangeSelector(dateWindow = input$login_date_range)
})

# 日登陆频次数据绘图渲染
output$login_plot_2 <- renderDygraph({
    dygraph(login_freq_data(), main = '不同日登陆频次区间用户数') %>% 
        dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
        dyAxis('y', label = '用户数') %>% 
        dyLegend(show = 'always', hideOnMouseOut = TRUE, width = 400) %>% 
        dyRangeSelector(dateWindow = input$login_date_range_freq)
})

