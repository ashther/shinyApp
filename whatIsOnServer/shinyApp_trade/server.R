
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
  
  observe({
    if (login_check$logged == TRUE) {
      source('renderUI_trade.R', encoding = 'utf-8', local = TRUE)
    }
  })
  
  # # 当省份选择变动时，更新对应的城市选项
  # observe({
  #   city_update <- city_with_quote[city_location$province == input$province]
  #   
  #   updateSelectInput(session, 
  #                     'city', 
  #                     choices = city_update %>%
  #                       paste0(., '=', .) %>%
  #                       paste(collapse = ',') %>%
  #                       sprintf('list(%s)', .) %>%
  #                       parse(text = .) %>%
  #                       eval())
  # })
  
  # map_data <- reactive({
  #   subset(user_location, create_time >= input$map_date_range[1] & 
  #            create_time <= input$map_date_range[2])
  # })
  
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
      source('shinyServerLog.R', encoding = 'utf-8', local = TRUE)
    }
  })
})
  

















