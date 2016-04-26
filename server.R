
shinyServer(function(input, output, session) {
    
    # 当选择hourly时去掉rentention选项
    observe({
        if (input$login_date_format == 'hourly') {
            updateSelectInput(session, 
                              'login_data_type', 
                              choices = list('new' = 'new',
                                             'active' = 'active',
                                             'login' = 'log_in'), 
                              selected = 'log_in')
        } else {
            updateSelectInput(session, 
                              'login_data_type', 
                              choices = list('new' = 'new',
                                             'active' = 'active',
                                             'login' = 'log_in', 
                                             'retention' = 'retention'), 
                              selected = 'active')
            
            updateDateRangeInput(session,
                                 'login_date_range',
                                 min = min(daily_login$date_time), 
                                 max = max(daily_login$date_time), 
                                 start = min(daily_login$date_time), 
                                 end = max(daily_login$date_time))
        }
    })
    
    # 载入数据刷新过程
    source('dataRefresh.R')
    # 载入数据框转时间序列过程
    source('dataToXts.R')
    
    # 登录数据筛选
    login_data <- reactive({
        get(paste(input$login_date_format, input$login_data_type, sep = '_'))
    })
    
    # 日登陆频次数据筛选
    login_freq_data <- reactive({
        paste(input$login_data_type_freq, input$login_freq_type, sep = '_', collapse = ',') %>%
            sprintf('cbind(%s)', .) %>%
            parse(text = .) %>%
            eval()
    })
    
    quick_chat_data <- reactive({
        get(paste(input$quick_chat_date_format, 'quick_chat', input$quick_chat_data_type, sep = '_'))
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
    output$login_plot_1 <- renderDygraph({
        dygraph(login_data()) %>% 
            dyOptions(fillGraph = TRUE, fillAlpha = 0.2) %>% 
            dyLegend(show = 'follow', hideOnMouseOut = TRUE) %>% 
            dyRangeSelector(dateWindow = input$login_date_range)
    })
    
    # 日登陆频次数据绘图渲染
    output$login_plot_2 <- renderDygraph({
        dygraph(login_freq_data()) %>% 
            dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
            dyAxis('y', label = 'user number') %>% 
            dyLegend(show = 'follow', hideOnMouseOut = TRUE) %>% 
            dyRangeSelector(dateWindow = input$login_date_range_freq)
    })
    
    # 当省份选择变动时，更新对应的城市选项
    observe({
        city_update <- city_with_quote[city_location$province == input$province]
        
        updateSelectInput(session, 
                          'city', 
                          choices = city_update %>%
                              paste0(., '=', .) %>%
                              paste(collapse = ',') %>%
                              sprintf('list(%s)', .) %>%
                              parse(text = .) %>%
                              eval())
    })
    
    # 地图输出
    output$user_location <- renderLeaflet({
        user_location %>% 
            leaflet() %>% 
            addTiles() %>% 
            addCircleMarkers(lng = user_location$longitude,
                             lat = user_location$latitude, 
                             radius = user_location$n, 
                             fill = TRUE, 
                             popup = as.character(user_location$n)) %>% 
            setView(lng = mean(city_location$lng[city_location$city == input$city]),
                    lat = mean(city_location$lat[city_location$city == input$city]),
                    zoom = 12)
    })
    
    output$quick_chat_circle <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'quick_chat_circle'], 
                 'circle number', 
                 icon('users'))
    })
    
    output$avg_circle_user <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'avg_circle_user'], 
                 'average user number per circle', 
                 icon('users'))
    })
    
    output$quick_chat_plot <- renderDygraph({
        dygraph(quick_chat_data()) %>% 
            dyOptions(fillGraph = TRUE, fillAlpha = 0.2) %>% 
            dyLegend(show = 'follow', hideOnMouseOut = TRUE) %>% 
            dyRangeSelector(dateWindow = input$quick_chat_date_range)
    })
})



















