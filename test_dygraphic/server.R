
shinyServer(function(input, output) {
    
    source('dataRefresh.R')
    
    source('dataToXts.R')
    
    # 登录数据筛选
    data_login_range <- reactive({
        get(paste(input$date_format, input$data_type, sep = '_'))
    })
    
    # 日登陆频次数据筛选
    data_freq_range <- reactive({
        paste(input$freq_data_type, input$freq_type, sep = '_', collapse = ',') %>% 
            sprintf('cbind(%s)', .) %>% 
            parse(text = .) %>% 
            eval()
    })
    
    # 累计用户数
    output$total_user <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'total_user'], 
                 'total user', 
                 icon('users'))
    })
    # 当日新增用户数
    output$new_user_today <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'new_user'], 
                 'new user', 
                 icon('user-plus'))
    })
    # 当日活跃用户数
    output$active_user_today <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'active_user'], 
                 'active user', 
                 icon('user'))
    })
    # 当日登陆次数
    output$login_times_today <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'login_times'], 
                 'login', 
                 icon('power-off'))
    })
    
    # 登录数据绘图渲染
    output$plot_login <- renderDygraph({
        dygraph(data_login_range()) %>% 
            dyOptions(fillGraph = TRUE, fillAlpha = 0.2) %>% 
            dyRangeSelector(dateWindow = input$date_range)
    })
    
    # 日登陆频次数据绘图渲染
    output$plot_daily_freq <- renderDygraph({
        dygraph(data_freq_range()) %>% 
            dyOptions(fillGraph = TRUE, fillAlpha = 0.2) %>% 
            dyRangeSelector(dateWindow = input$freq_date_range)
    })
})



















