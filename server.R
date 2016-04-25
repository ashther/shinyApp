
shinyServer(function(input, output, session) {
    
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
    
    observe({
        if (input$province == '安徽省') {
            updateSelectInput(session, 
                              'city', 
                              choices = list('安庆市' = '安庆市', 
                                             '蚌埠市' = '蚌埠市', 
                                             '亳州市' = '亳州市', 
                                             '巢湖市' = '巢湖市', 
                                             '池州市' = '池州市', 
                                             '滁州市' = '滁州市', 
                                             '阜阳市' = '阜阳市', 
                                             '合肥市' = '合肥市', 
                                             '淮北市' = '淮北市', 
                                             '淮南市' = '淮南市', 
                                             '黄山市' = '黄山市', 
                                             '六安市' = '六安市', 
                                             '马鞍山市' = '马鞍山市', 
                                             '宿州市' = '宿州市', 
                                             '铜陵市' = '铜陵市', 
                                             '芜湖市' = '芜湖市', 
                                             '宣城市' = '宣城市'), 
                              selected = '合肥市')
        } else if (input$province == '陕西省') {
            updateSelectInput(session, 
                              'city', 
                              choices = list('安康市' = '安康市', 
                                             '宝鸡市' = '宝鸡市', 
                                             '汉中市' = '汉中市', 
                                             '商洛市' = '商洛市', 
                                             '铜川市' = '铜川市', 
                                             '渭南市' = '渭南市', 
                                             '西安市' = '西安市',
                                             '咸阳市' = '咸阳市',
                                             '延安市' = '延安市',
                                             '榆林市' = '榆林市'), 
                              selected = '西安市')
        }
    })
    
    source('dataRefresh.R')
    
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
    
    output$user_location <- renderLeaflet({
        user_location %>% 
            leaflet() %>% 
            addTiles() %>% 
            addCircleMarkers(radius = ~n, 
                             fill = TRUE, 
                             popup = ~as.character(n)) %>% 
            setView(lng = input$user_location_lng, 
                    lat = input$user_location_lat, 
                    zoom = 12)
    })
})



















