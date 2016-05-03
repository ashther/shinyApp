
shinyServer(function(input, output, session) {
    
    # 当选择hourly时去掉rentention选项
    observe({
        if (input$login_date_format == 'hourly') {
            updateSelectInput(session, 
                              'login_data_type', 
                              choices = list('新增用户数' = 'new',
                                             '活跃用户数' = 'active',
                                             '登陆次数' = 'log_in'), 
                              selected = 'log_in')
        } else {
            updateSelectInput(session, 
                              'login_data_type', 
                              choices = list('新增用户数' = 'new',
                                             '活跃用户数' = 'active',
                                             '登陆次数' = 'log_in', 
                                             '留存率' = 'retention'), 
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
    
    map_data <- reactive({
        subset(user_location, create_time >= input$map_date_range[1] & 
                              create_time <= input$map_date_range[2])
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
        valueBox(point_data$value[point_data$item == 'active_user'], 
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
        
        user_location_temp <- map_data() %>% 
            mutate(longitude = round(as.numeric(longitude), 2),
                   latitude = round(as.numeric(latitude), 2)) %>%
            group_by(longitude, latitude) %>%
            summarise(n = n()) %>%
            ungroup() %>%
            arrange(desc(n)) %>%
            as.data.frame()
        
        user_location_temp %>% 
            leaflet() %>% 
            addTiles(urlTemplate = 'http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png') %>% 
            addCircleMarkers(lng = user_location_temp$longitude,
                             lat = user_location_temp$latitude, 
                             radius = user_location_temp$n, 
                             fillOpacity = 0.4,  #when user scale get larger use stroke = FALSE & fillOpacity = 0.35
                             popup = as.character(user_location_temp$n)) %>% 
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
    
    # calendar ===============================================================
    calendar_data <- reactive({
        get(paste(input$calendar_date_format, 'calendar', input$calendar_data_type, sep = '_'))
    })
    
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
    
    # cooperation ===============================================================
    cooperation_data <- reactive({
        get(paste(input$cooperation_date_format, 'cooperation', input$cooperation_data_type, sep = '_'))
    })
    
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
    
    # hr ===============================================================
    hr_data <- reactive({
        get(paste(input$hr_date_format, 'hr', input$hr_data_type, sep = '_'))
    })
    
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
    
    # schedule ===============================================================
    schedule_data <- reactive({
        get(paste(input$schedule_date_format, 'schedule', input$schedule_data_type, sep = '_'))
    })
    
    output$schedule_course <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'schedule_course'], 
                 '累计课程数', 
                 icon('university'), 
                 'yellow')
    })
    
    output$schedule_courseware <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'schedule_courseware'], 
                 '累计课件数', 
                 icon('upload'), 
                 'yellow')
    })
    
    output$schedule_homework <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'schedule_homework'], 
                 '累计作业数', 
                 icon('upload'), 
                 'yellow')
    })
    
    output$avg_course_user <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'avg_course_user'], 
                 '课程平均学习者数', 
                 icon('users'), 
                 'yellow')
    })
    
    output$schedule_plot <- renderDygraph({
        dygraph(schedule_data(), 
                main = sprintf('%s变化趋势',
                               switch(input$schedule_data_type,
                                      'new_course' = '新增课程数',
                                      'new_user' = '新增用户数', 
                                      'active_user' = '活跃用户数', 
                                      'new_file' = '新增课程文件数', 
                                      'operation' = '操作数'))) %>% 
            dySeries(label = sprintf('%s',
                                     switch(input$schedule_data_type,
                                            'new_course' = '新增课程数',
                                            'new_user' = '新增用户数', 
                                            'active_user' = '活跃用户数', 
                                            'new_file' = '新增课程文件数', 
                                            'operation' = '操作数'))) %>%
            dyOptions(fillGraph = TRUE, fillAlpha = 0.2, colors = 'orange') %>% 
            dyLegend(show = 'follow', hideOnMouseOut = TRUE) %>% 
            dyRangeSelector(dateWindow = input$calendar_date_range)
    })
    
    # trade ===============================================================
    trade_data <- reactive({
        get(paste(input$trade_date_format, 'trade', input$trade_data_type, sep = '_'))
    })
    
    price_data <- reactive({
        price_data_temp <- subset(get(input$price_type), type %in% input$price_category)
        
        if (input$price_outlier) {
            price_data_temp <- 
                subset(price_data_temp, 
                       price <= quantile(sell_price$price, 0.75) + 1.5 * IQR(sell_price$price) &
                           price >= quantile(sell_price$price, 0.25) - 1.5 * IQR(sell_price$price))
            
        }
        
        return(price_data_temp)
    })
    
    output$sell_info <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'sell_info'], 
                 '出售商品数', 
                 icon('mobile'), 
                 'maroon')
    })
    
    output$seller <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'seller'], 
                 '累计卖家数', 
                 icon('users'), 
                 'maroon')
    })
    
    output$purchase_info <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'purchase_info'], 
                 '求购信息数', 
                 icon('laptop'), 
                 'maroon')
    })
    
    output$purchaser <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'purchaser'], 
                 '累计买家数', 
                 icon('users'), 
                 'maroon')
    })
    
    output$sell_median <- renderValueBox({
        valueBox(median(sell_price$price), 
                 '出售价格价中位数', 
                 icon('rmb'), 
                 'maroon')
    })
    
    output$sell_mean <- renderValueBox({
        valueBox(round(mean(sell_price$price), 2), 
                 '出售价格平均数', 
                 icon('rmb'), 
                 'maroon')
    })
    
    output$buy_median <- renderValueBox({
        valueBox(median(buy_price$price), 
                 '求购价格中位数', 
                 icon('rmb'), 
                 'maroon')
    })
    
    output$buy_mean <- renderValueBox({
        valueBox(round(mean(buy_price$price), 2), 
                 '求购价格平均数', 
                 icon('rmb'), 
                 'maroon')
    })
    
    output$trade_plot <- renderDygraph({
        dygraph(trade_data(), 
                main = sprintf('%s变化趋势',
                               switch(input$trade_data_type,
                                      'new_sell_info' = '新增出售商品数',
                                      'new_buy_info' = '新增求购信息数', 
                                      'active_seller' = '活跃卖家数', 
                                      'active_buyer' = '活跃买家数', 
                                      'active_trader' = '活跃用户数'))) %>% 
            dySeries(label = sprintf('%s',
                                     switch(input$trade_data_type,
                                            'new_sell_info' = '新增出售商品数',
                                            'new_buy_info' = '新增求购信息数', 
                                            'active_seller' = '活跃卖家数', 
                                            'active_buyer' = '活跃买家数', 
                                            'active_trader' = '活跃用户数'))) %>%
            dyOptions(fillGraph = TRUE, fillAlpha = 0.2, colors = 'maroon') %>% 
            dyLegend(show = 'follow', hideOnMouseOut = TRUE) %>% 
            dyRangeSelector(dateWindow = input$calendar_date_range)
    })
    
    output$trade_price <- renderPlot({
        
        ggplot(price_data(), aes(x = price, fill = type)) + 
            geom_histogram(alpha = 0.5, binwidth = input$price_binwidth) + 
            xlab('price(yuan)') + 
            ylab('information') + 
            ggtitle(sprintf('%s', switch(input$price_type,
                                            'sell_price' = 'sell price',
                                            'buy_price' = 'buy price')))
    })
    
    # train ===============================================================
    train_data <- reactive({
        get(paste(input$train_date_format, 'train', input$train_data_type, sep = '_'))
    })
    
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
})



















