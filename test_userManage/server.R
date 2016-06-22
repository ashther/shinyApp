
user_passwd <- data.frame(user = c('sunlj', 'zhoumn', 'zhangp', 'chenmq'), 
                          passwd = c('sunlj', 'zhoumn', 'zhangp', 'chenmq'), 
                          stringsAsFactors = FALSE)
logged <- FALSE

shinyServer(function(input, output, session) {
    
    login_check <- reactiveValues(logged = logged)
    
    source('login.R', encoding = 'utf-8', local = TRUE)
    # 载入数据刷新过程
    source('dataRefresh.R', encoding = 'utf-8', local = TRUE)
    # 载入数据框转时间序列过程
    source('dataToXts.R', encoding = 'utf-8', local = TRUE)
    
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
    
    # 用户登录后渲染首页UI
    observe({
        if (login_check$logged == TRUE) {
            source('renderUI_login.R', encoding = 'utf-8', local = TRUE)
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
    
    map_data <- reactive({
        subset(user_location, create_time >= input$map_date_range[1] & 
                              create_time <= input$map_date_range[2])
    })
    
    # 用户登陆后渲染首页输出图表
    observe({
        if (login_check$logged == TRUE) { 
            source('renderOutput_login.R', encoding = 'utf-8', local = TRUE)
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



















