
user_passwd <- data.frame(user = c('sunlj', 'zhoumn', 'zhangp', 'chenmq', 'yyzx'), 
              passwd = c('sunlj', 'zhoumn', 'zhangp', 'chenmq', 'yyzx123'), 
              stringsAsFactors = FALSE)
logged <- FALSE

shinyServer(function(input, output, session) {
  
  login_check <- reactiveValues(logged = logged)
  
  source('login.R', encoding = 'utf-8', local = TRUE)
  # 载入数据刷新过程
  source('dataRefresh.R', encoding = 'utf-8', local = TRUE)
  # 载入数据框转时间序列过程
  source('dataToXts.R', encoding = 'utf-8', local = TRUE)
  
  # 用户登录后渲染首页UI
  observe({
    if (login_check$logged == TRUE) {
      source('renderUI_login.R', encoding = 'utf-8', local = TRUE)
    }
  })
  
  # 登录日志入库
  observe({
    if (login_check$logged == TRUE) {
      source('shinyServerLog.R', encoding = 'utf-8', local = TRUE)
    }
  })
  
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
  
  # 用户登陆后渲染首页输出图表
  observe({
    if (login_check$logged == TRUE) { 
      source('renderOutput_login.R', encoding = 'utf-8', local = TRUE)
    }
  })
  
  # demographic =============================================================
  demographic_temp_data <- reactive({
    if (input$demographic_university_select == '不限') {
      temp <- subset(
        demographic, regist_time >= as.POSIXct(input$demographic_dateRange_1[1]) & 
          regist_time <= as.POSIXct(input$demographic_dateRange_1[2])
      ) 
    } else {
      temp <- subset(
        demographic, university == input$demographic_university_select & 
          regist_time >= as.POSIXct(input$demographic_dateRange_1[1]) & 
          regist_time <= as.POSIXct(input$demographic_dateRange_1[2])
      )
    }
    return(temp)
  })
  
  demographic_age_data <- reactive({
    
    temp <- demographic_temp_data()
    if (input$demographic_age_outlier) {
      temp <- 
        subset(temp, 
             age <= quantile(temp$age, 0.75, na.rm = TRUE) + 1.5 * IQR(temp$age, na.rm = TRUE) &
               age >= quantile(temp$age, 0.25, na.rm = TRUE) - 1.5 * IQR(temp$age, na.rm = TRUE))
      
    }
    return(temp)
  })
  
  demographic_degree_data <- reactive({
    
    temp <- demographic_temp_data()
    if (input$demographic_degree_null) {
      temp <- temp[!is.na(temp$degree), ]
    }
    temp <- temp %>% 
      group_by(degree) %>% 
      tally()
    
    temp$degree[temp$degree == '1'] <- '博士后'
    temp$degree[temp$degree == '2'] <- '博士'
    temp$degree[temp$degree == '3'] <- '硕士'
    temp$degree[temp$degree == '4'] <- '本科'
    temp$degree[temp$degree == '5'] <- '大专'
    temp$degree[temp$degree == '6'] <- '高中/中专'
    temp$degree[temp$degree == '7'] <- '初中及以下'
    return(temp)
  })
  
  demographic_gender_data <- reactive({
    
    temp <- demographic_temp_data()
    if (input$demographic_gender_null) {
      temp <- temp[!is.na(temp$gender), ]
    }
    temp <- temp %>% 
      group_by(gender) %>% 
      tally()

    return(temp)
  })
  
  demographic_university_top10 <- reactive({
    demographic %>% 
      filter(!is.na(university) & 
             status_category == 1 & 
             regist_time >= as.POSIXct(input$demographic_dateRange_2[1]) & 
             regist_time <= as.POSIXct(input$demographic_dateRange_2[2])) %>% 
      group_by(university) %>% 
      summarise(n = n()) %>% 
      ungroup() %>% 
      mutate(r = rank(n, ties.method = 'random')) %>% 
      top_n(10, r) %>% 
      arrange(desc(r)) %>% 
      select(university, n)
  })
  
  demographic_heatmap_data <- reactive({
    demographic[demographic$university %in% demographic_university_top10()$university, 
          c('university', 'degree')]
  })
  
  observe({
    if (login_check$logged == TRUE) {
      source('renderOutput_demographic.R', encoding = 'utf-8', local = TRUE)
    }
  })
  
  # geo======================================================================
  
  app_start_dateRange_data <- reactive({
    app_start[
      app_start$time_stamp >= input$app_start_date_range[1] & 
        app_start$time_stamp <= input$app_start_date_range[2], 
      ]
  })
  
  app_start_data <- reactive({
    if (input$user_name == 'sunlj') {
      if (input$specific_user_geo != 'noSpecific') {
        return(
          subset(app_start_dateRange_data(),
                 user_id == input$specific_user_geo)
        )
      } else {
        return(
          switch(
            input$app_start_userType,
            'all' = app_start_dateRange_data(),
            'new' = subset(app_start_dateRange_data(),
                           regist_time >= input$app_start_date_range[1] &
                             regist_time <= input$app_start_date_range[2]),
            'old' = subset(app_start_dateRange_data(),
                           regist_time < input$app_start_date_range[1])
          )
        )
      }
    } else {
      return(
        switch(
          input$app_start_userType,
          'all' = app_start_dateRange_data(),
          'new' = subset(app_start_dateRange_data(),
                         regist_time >= input$app_start_date_range[1] &
                           regist_time <= input$app_start_date_range[2]),
          'old' = subset(app_start_dateRange_data(),
                         regist_time < input$app_start_date_range[1])
        )
      )
    }
  })
  
  app_start_top10 <- reactive({
    result <- sapply(1:nrow(app_start_data()), function(x) {
      city_location$city[
        which.min(
          sqrt(
            (app_start_data()$lon[x] - city_location$lng) ^ 2 + 
              (app_start_data()$lat[x] - city_location$lat) ^ 2
          )
        )
      ]
    }) %>% 
      table() %>% 
      sort(decreasing = TRUE)
    if (length(result) > 0) {
      result <- result[1:ifelse(10 <= length(result), 10, length(result))]
      return(data.frame('地区' = names(result), 
                        '登录次数' = unname(result), 
                        stringsAsFactors = FALSE, 
                        row.names = NULL))
    } else {
      return(NULL)
    }
  })
  
  # 渲染地图模块输出图表
  observe({
    if (login_check$logged == TRUE) {
      source('renderOutput_geo.R', encoding = 'utf-8', local = TRUE)
    }
  })
  
  # channel==================================================================
  
  channel_dateRange_data <- reactive({
    app_start[
      app_start$time_stamp >= input$channel_date_range[1] & 
        app_start$time_stamp <= input$channel_date_range[2], 
      ]
  })
  
  channel_data <- reactive({
    result <- switch(
      input$channel_userType,
      'all' = channel_dateRange_data(),
      'new' = subset(channel_dateRange_data(),
                     regist_time >= input$channel_date_range[1] &
                       regist_time <= input$channel_date_range[2]),
      'old' = subset(channel_dateRange_data(),
                     regist_time < input$channel_date_range[1])
    )
    
    if (input$channel_null) {
      result <- filter(result, version != '缺失' & channel != '缺失')
    }
    
    result <- result %>% 
      group_by(user_id) %>%
      arrange(desc(timestamp)) %>% 
      top_n(1, timestamp) %>% 
      ungroup()
    
    if (input$channel_other) {
      result <- filter(result, channel != '其他')
    }
    
    return(result)
  })
  
  observe({
    if (login_check$logged == TRUE) {
      source('renderOutput_channel.R', encoding = 'utf-8', local = TRUE)
    }
  })
  
  # quick_chat===============================================================
  quick_chat_data <- reactive({
    get(paste(input$quick_chat_date_format, 'quick_chat', input$quick_chat_data_type, sep = '_'))
  })
  
  # 渲染快信模块输出图表
  observe({
    if (login_check$logged == TRUE) {
      source('renderOutput_quick_chat.R', encoding = 'utf-8', local = TRUE)
    }
  })
  
  # calendar ===============================================================
  calendar_data <- reactive({
    get(paste(input$calendar_date_format, 'calendar', input$calendar_data_type, sep = '_'))
  })
  
  # 渲染勤务表模块输出图表
  observe({
    if (login_check$logged == TRUE) {
      source('renderOutput_calendar.R', encoding = 'utf-8', local = TRUE)
    }
  })
  
  
  
  # cooperation ===============================================================
  cooperation_data <- reactive({
    get(paste(input$cooperation_date_format, 'cooperation', input$cooperation_data_type, sep = '_'))
  })
  
  # 渲染技术合作模块输出图表
  observe({
    if (login_check$logged == TRUE) {
      source('renderOutput_cooperation.R', encoding = 'utf-8', local = TRUE)
    }
  })
  
  
  
  # hr ===============================================================
  hr_data <- reactive({
    get(paste(input$hr_date_format, 'hr', input$hr_data_type, sep = '_'))
  })
  
  # 渲染hr模块输出图表
  observe({
    if (login_check$logged == TRUE) {
      source('renderOutput_hr.R', encoding = 'utf-8', local = TRUE)
    }
  })
  
  
  
  # schedule ===============================================================
  schedule_data <- reactive({
    get(paste(input$schedule_date_format, 'schedule', input$schedule_data_type, sep = '_'))
  })
  
  observe({
    if (login_check$logged == TRUE) {
      source('renderOutput_schedule.R', encoding = 'utf-8', local = TRUE)
    }
  })
  
  
  
  # trade ===============================================================
  
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
  
  map_data <- reactive({
    subset(user_location, create_time >= input$map_date_range[1] & 
             create_time <= input$map_date_range[2])
  })
  
  trade_data <- reactive({
    get(paste(input$trade_date_format, 'trade', input$trade_data_type, sep = '_'))
  })
  
  price_data <- reactive({
    price_data_temp <- subset(get(input$price_type), type %in% input$price_category)
    
    if (input$price_outlier) {
      price_data_temp <- 
        subset(price_data_temp, 
             price <= quantile(sell_price$price, 0.75, na.rm = TRUE) + 1.5 * IQR(sell_price$price) &
               price >= quantile(sell_price$price, 0.25, na.rm = TRUE) - 1.5 * IQR(sell_price$price))
      
    }
    
    return(price_data_temp)
  })
  
  observe({
    if (login_check$logged == TRUE) {
      source('renderOutput_trade.R', encoding = 'utf-8', local = TRUE)
    }
  })
  
  
  
  # train ===============================================================
  train_data <- reactive({
    get(paste(input$train_date_format, 'train', input$train_data_type, sep = '_'))
  })
  
  observe({
    if (login_check$logged == TRUE) {
      source('renderOutput_train.R', encoding = 'utf-8', local = TRUE)
    }
  })
  
})



















