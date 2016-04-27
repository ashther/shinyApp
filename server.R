
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
            addTiles(urlTemplate = 'http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png') %>% 
            addCircleMarkers(lng = user_location$longitude,
                             lat = user_location$latitude, 
                             radius = user_location$n, 
                             fillOpacity = 0.4,  #when user scale get larger use stroke = FALSE & fillOpacity = 0.35
                             popup = as.character(user_location$n)) %>% 
            setView(lng = mean(city_location$lng[city_location$city == input$city]),
                    lat = mean(city_location$lat[city_location$city == input$city]),
                    zoom = 12)
    })
    
    # quick_chat===============================================================
    quick_chat_data <- reactive({
        get(paste(input$quick_chat_date_format, 'quick_chat', input$quick_chat_data_type, sep = '_'))
    })
    
    output$quick_chat_circle <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'quick_chat_circle'], 
                 'circle number', 
                 icon('object-group'), 
                 'olive')
    })
    
    output$avg_circle_user <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'avg_circle_user'], 
                 'average user number per circle', 
                 icon('users'), 
                 'olive')
    })
    
    output$quick_chat_plot <- renderDygraph({
        dygraph(quick_chat_data()) %>% 
            dyOptions(fillGraph = TRUE, fillAlpha = 0.2, colors = 'olive') %>% 
            dyLegend(show = 'follow', hideOnMouseOut = TRUE) %>% 
            dyRangeSelector(dateWindow = input$quick_chat_date_range)
    })
    
    # calendar ===============================================================
    calendar_data <- reactive({
        get(paste(input$calendar_date_format, 'calendar', input$calendar_data_type, sep = '_'))
    })
    
    output$calendar_activity <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'calendar_activity'], 
                 'activity number', 
                 icon('calendar'), 
                 'light-blue')
    })
    
    output$avg_activity_user <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'avg_activity_user'], 
                 'average user number per activity', 
                 icon('users'), 
                 'light-blue')
    })
    
    output$calendar_plot <- renderDygraph({
        dygraph(calendar_data()) %>% 
            dyOptions(fillGraph = TRUE, fillAlpha = 0.2, colors = 'light-blue') %>% 
            dyLegend(show = 'follow', hideOnMouseOut = TRUE) %>% 
            dyRangeSelector(dateWindow = input$calendar_date_range)
    })
    
    # cooperation ===============================================================
    cooperation_data <- reactive({
        get(paste(input$cooperation_date_format, 'cooperation', input$cooperation_data_type, sep = '_'))
    })
    
    output$cooperation_company <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'cooperation_company'], 
                 'cooperation company number', 
                 icon('briefcase', lib = 'glyphicon'), 
                 'green')
    })
    
    output$cooperation_project <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'cooperation_project'], 
                 'cooperation project number', 
                 icon('folder-open', lib = 'glyphicon'), 
                 'green')
    })
    
    output$cooperation_user <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'cooperation_user'], 
                 'cooperation user number', 
                 icon('users'), 
                 'green')
    })
    
    output$cooperation_plot <- renderDygraph({
        dygraph(cooperation_data()) %>% 
            dyOptions(fillGraph = TRUE, fillAlpha = 0.2, colors = 'green') %>% 
            dyLegend(show = 'follow', hideOnMouseOut = TRUE) %>% 
            dyRangeSelector(dateWindow = input$calendar_date_range)
    })
    
    # hr ===============================================================
    hr_data <- reactive({
        get(paste(input$hr_date_format, 'hr', input$hr_data_type, sep = '_'))
    })
    
    output$jobseeker <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'jobseeker'], 
                 'jobseekers number', 
                 icon('users'), 
                 'blue')
    })
    
    output$hr_company <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'hr_company'], 
                 'company number', 
                 icon('briefcase', lib = 'glyphicon'), 
                 'blue')
    })
    
    output$recruitment <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'recruitment'], 
                 'recruitment number', 
                 icon('file-text'), 
                 'blue')
    })
    
    output$hr_plot <- renderDygraph({
        dygraph(hr_data()) %>% 
            dyOptions(fillGraph = TRUE, fillAlpha = 0.2, colors = 'blue') %>% 
            dyLegend(show = 'follow', hideOnMouseOut = TRUE) %>% 
            dyRangeSelector(dateWindow = input$calendar_date_range)
    })
    
    # schedule ===============================================================
    schedule_data <- reactive({
        get(paste(input$schedule_date_format, 'schedule', input$schedule_data_type, sep = '_'))
    })
    
    output$schedule_course <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'schedule_course'], 
                 'schedule course number', 
                 icon('university'), 
                 'yellow')
    })
    
    output$upload_course_file <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'upload_course_file'], 
                 'upload file number', 
                 icon('upload'), 
                 'yellow')
    })
    
    output$avg_course_user <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'avg_course_user'], 
                 'average user per course', 
                 icon('users'), 
                 'yellow')
    })
    
    output$schedule_plot <- renderDygraph({
        dygraph(schedule_data()) %>% 
            dyOptions(fillGraph = TRUE, fillAlpha = 0.2, colors = 'orange') %>% 
            dyLegend(show = 'follow', hideOnMouseOut = TRUE) %>% 
            dyRangeSelector(dateWindow = input$calendar_date_range)
    })
    
    # trade ===============================================================
    trade_data <- reactive({
        get(paste(input$trade_date_format, 'trade', input$trade_data_type, sep = '_'))
    })
    
    output$sell_info <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'sell_info'], 
                 'sell information number', 
                 icon('mobile'), 
                 'maroon')
    })
    
    output$seller <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'seller'], 
                 'seller number', 
                 icon('users'), 
                 'maroon')
    })
    
    output$purchase_info <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'purchase_info'], 
                 'purchase information number', 
                 icon('laptop'), 
                 'maroon')
    })
    
    output$purchaser <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'purchaser'], 
                 'buyer number', 
                 icon('users'), 
                 'maroon')
    })
    
    output$trade_plot <- renderDygraph({
        dygraph(trade_data()) %>% 
            dyOptions(fillGraph = TRUE, fillAlpha = 0.2, colors = 'maroon') %>% 
            dyLegend(show = 'follow', hideOnMouseOut = TRUE) %>% 
            dyRangeSelector(dateWindow = input$calendar_date_range)
    })
    
    # train ===============================================================
    train_data <- reactive({
        get(paste(input$train_date_format, 'train', input$train_data_type, sep = '_'))
    })
    
    output$train_company <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'train_company'], 
                 'company number', 
                 icon('briefcase', lib = 'glyphicon'), 
                 'purple')
    })
    
    output$train_course <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'train_course'], 
                 'course number', 
                 icon('book'), 
                 'purple')
    })
    
    output$train_user <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'train_user'], 
                 'user number', 
                 icon('users'), 
                 'purple')
    })
    
    output$train_plot <- renderDygraph({
        dygraph(train_data()) %>% 
            dyOptions(fillGraph = TRUE, fillAlpha = 0.2, colors = 'purple') %>% 
            dyLegend(show = 'follow', hideOnMouseOut = TRUE) %>% 
            dyRangeSelector(dateWindow = input$calendar_date_range)
    })
})



















