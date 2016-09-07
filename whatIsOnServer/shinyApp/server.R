
# user_passwd <- data.frame(user = c('sunlj', 'zhoumn', 'zhangp', 'chenmq', 'yyzx'), 
#               passwd = c('sunlj', 'zhoumn', 'zhangp', 'chenmq', 'yyzx123'), 
#               stringsAsFactors = FALSE)
logged <- FALSE

shinyServer(function(input, output, session) {
  
  login_check <- reactiveValues(logged = logged)
  
  source('login.R', encoding = 'utf-8', local = TRUE)
  # 载入数据刷新过程
  source('dataRefresh.R', encoding = 'utf-8', local = TRUE)
  # 载入数据框转时间序列过程
  source('dataToXts.R', encoding = 'utf-8', local = TRUE)
  
  # 用户登录后渲染首页UI
  # 登录日志入库
  observe({
    if (login_check$logged == TRUE) {
      source('renderUI_login.R', encoding = 'utf-8', local = TRUE)
      source('shinyServerLog.R', encoding = 'utf-8', local = TRUE)
    }
  })
  
  hourly_login_plot_data <- reactive({
    if (!is.null(input$hourly_login_plot_select) && 
        !is.null(input$hourly_login_plot_compare)) {
      
      dat <- paste0('hourly_', input$hourly_login_plot_select, ', ', 
                    'hourly_', input$hourly_login_plot_select, '_', 
                    input$hourly_login_plot_compare) %>% 
        sprintf("cbind(%s)", .) %>% 
        parse(text = .) %>% 
        eval()
      
      result <- switch(input$hourly_login_plot_select,
             'new' = list(dat = dat, 
                          main_title = '新增用户数', 
                          label = c('今日', 
                                    switch(input$hourly_login_plot_compare,
                                      '1day' = '昨日', 
                                      '7days' = '7日平均', 
                                      '30days' = '30日平均'
                                    ))), 
             'active' = list(dat = dat, 
                             main_title = '活跃用户数', 
                             label = c('今日', 
                                       switch(input$hourly_login_plot_compare,
                                              '1day' = '昨日', 
                                              '7days' = '7日平均', 
                                              '30days' = '30日平均'
                                       ))), 
             'log_in' = list(dat = dat, 
                             main_title = '登录次数', 
                             label = c('今日', 
                                       switch(input$hourly_login_plot_compare,
                                              '1day' = '昨日', 
                                              '7days' = '7日平均', 
                                              '30days' = '30日平均'
                                       )))
      )
    }
  })
  
  # 登录数据筛选
  login_data <- reactive({
    if (!is.null(input$login_date_format) && !is.null(input$login_data_type)) {
      get(paste(input$login_date_format, input$login_data_type, sep = '_'))
    }
    
  })
  
  # 日登陆频次数据筛选
  login_freq_data <- reactive({
    if (!is.null(input$login_data_type_freq) && !is.null(input$login_freq_type)) {
      paste(input$login_data_type_freq, input$login_freq_type, sep = '_', collapse = ',') %>%
        sprintf('cbind(%s)', .) %>%
        parse(text = .) %>%
        eval()
    }
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
          regist_time <= as.POSIXct(input$demographic_dateRange_1[2] + 1)
      ) 
    } else {
      temp <- subset(
        demographic, university == input$demographic_university_select & 
          regist_time >= as.POSIXct(input$demographic_dateRange_1[1]) & 
          regist_time <= as.POSIXct(input$demographic_dateRange_1[2] + 1)
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
    temp <- as.numeric(na.omit(temp$age))
    
    if (length(temp) == 0) {
      return(NULL)
    } else if (length(temp) == 1) {
      # Error in density.default(1) : 
      # need at least 2 points to select a bandwidth automatically
      temp <- c(temp, temp)
    }
    return(density(temp))
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
             regist_time <= as.POSIXct(input$demographic_dateRange_2[2] + 1)) %>% 
      mutate(university = stringr::str_trim(university)) %>% 
      group_by(university) %>% 
      summarise(n = n()) %>% 
      ungroup() %>% 
      mutate(r = rank(n, ties.method = 'random')) %>% 
      top_n(10, r) %>% 
      arrange(r) %>% 
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
    if (is.null(input$specific_user_geo) || input$specific_user_geo == 'noSpecific') {
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
    } else if (input$specific_user_geo != 'noSpecific') {
      return(
        subset(app_start_dateRange_data(),
               user_id == input$specific_user_geo)
      )
    }
  })
  
  app_start_topArea_data <- reactive({
    
    if (nrow(app_start_data()) == 0) {
      return(data.frame('地区' = '无', 
                        '登陆次数' = '无', 
                        stringsAsFactors = FALSE, 
                        row.names = NULL))
    } else {
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
      result <- result[1:ifelse(10 <= length(result), 10, length(result))]
      return(data.frame('地区' = names(result), 
                        '登录次数' = unname(result), 
                        stringsAsFactors = FALSE, 
                        row.names = NULL))
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
})
















