
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
      
      operate_data <- reactive({
        view_data <- tryCatch({
          operate_log %>% 
            filter(opreate_time >= input$operate_date_range[1] & 
                     opreate_time <= input$operate_date_range[2] & 
                     opreate_type == 1) %>% 
            group_by(file_name, category_name) %>% 
            summarise(user_view_n = length(unique(account_id)), 
                      view_n = n()) %>% 
            ungroup()
        }, error = function(e)return(data.frame(file_name = NA,
                                                category_name = NA, 
                                                user_view_n = NA, 
                                                view_n = NA)))
        
        download_data <- tryCatch({
          operate_log %>% 
            filter(opreate_time >= input$operate_date_range[1] & 
                     opreate_time <= input$operate_date_range[2] & 
                     opreate_type == 3) %>% 
            group_by(file_name, category_name) %>% 
            summarise(user_download_n = length(unique(account_id)), 
                      download_n = n()) %>% 
            ungroup()
        }, error = function(e)return(data.frame(file_name = NA, 
                                                category_name = NA, 
                                                user_download_n = NA, 
                                                download_n = NA)))
        
        result <- full_join(view_data, download_data, by = c('file_name', 'category_name'))
        result[, 3:6][is.na(result[, 3:6])] <- 0
        result <- result %>% 
          arrange(desc(view_n), desc(download_n), desc(user_view_n), desc(user_download_n)) %>% 
          rename(文件名 = file_name, 
                 类别 = category_name, 
                 浏览用户数 = user_view_n, 
                 浏览人次 = view_n, 
                 下载用户数 = user_download_n, 
                 下载人次 = download_n)
        return(result)
      })
    }
  })
})













