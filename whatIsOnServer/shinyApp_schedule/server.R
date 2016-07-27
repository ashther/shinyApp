
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
      source('renderUI_schedule.R', encoding = 'utf-8', local = TRUE)
    }
  })
  
  schedule_data <- reactive({
    get(paste(input$schedule_date_format, 'schedule', input$schedule_data_type, sep = '_'))
  })
  
  observe({
    if (login_check$logged == TRUE) {
      source('renderOutput_schedule.R', encoding = 'utf-8', local = TRUE)
      source('shinyServerLog.R', encoding = 'utf-8', local = TRUE)
    }
  })
})













