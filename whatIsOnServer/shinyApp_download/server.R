
source('www/dataSource.R', local = TRUE)

logged <- FALSE

shinyServer(function(input, output, session) {
  
  login_data <- reactiveValues(logged = logged)
  
  source('www/login.R', encoding = 'utf-8', local = TRUE)
  
  observe({
    if (login_data$logged == TRUE) {
      source('shinyServerLog.R', encoding = 'utf-8', local = TRUE)
    } 
  })
  
  observe({
    if (login_data$logged == TRUE) {
      
      output$company_university_ui <- renderUI({
        checkboxInput(
          inputId = 'company_university', 
          label = '单位/学校', 
          value = TRUE
        )
      })
      
      output$regist_time_ui <- renderUI({
        checkboxInput(
          inputId = 'regist_time', 
          label = '注册时间', 
          value = TRUE
        )
      })
      
      output$last_login_time_ui <- renderUI({
        checkboxInput(
          inputId = 'last_login_time', 
          label = '最后登录时间', 
          value = TRUE
        )
      })
      
      output$phone_field_ui <- renderUI({
        checkboxInput(
          inputId = 'phone_field', 
          label = '用户手机归属地（需要用户手机号）', 
          value = TRUE
        )
      })
      
      output$channel_ui <- renderUI({
        checkboxInput(
          inputId = 'channel', 
          label = '渠道', 
          value = TRUE
        )
      })
      
      output$date_ui <- renderUI({
        dateRangeInput(
          inputId = 'date', 
          label = '选择注册时间', 
          min = '2016-04-28', 
          max = Sys.Date(), 
          start = '2016-04-28', 
          end = Sys.Date(), 
          language = 'zh-CN'
        )
      })
      
      output$button_ui <- renderUI({
        actionButton(inputId = 'select_button', 
                     label = '查询')
      })
      
      output$download_ui <- renderUI({
        downloadButton('download', '下载')
      })
      
      output$download <- downloadHandler(
        filename = function() {
          paste0(format(Sys.time(), '%Y%m%d_%H%M%S'), '.csv')
        }, 
        content = function(file) {
          temp <- user_regist_data()
          colnames(temp) <- iconv(colnames(temp), 'utf-8', 'gbk') 
          write.csv(sapply(temp, function(x){iconv(x, 'utf-8', 'gbk')}), file)
        }
      )
      
      user_regist_temp <- eventReactive(input$select_button, {
        withProgress(message = '查询中...', value = 0, {
          setProgress(0.2)
          setProgress(0.5)
          result <- tryCatch({
            rbind(
              dataGet(max(users$注册时间), host, port, username, password, dbname, mobile_info),
              users
            )
          }, error = function(e)return(users)) %>% 
            filter(`注册时间` >= input$date[1] & `注册时间` <= input$date[2])
          setProgress(1)
        })
        
        return(result)
      })
      
      user_regist_data <- reactive({
        
        result <- user_regist_temp()
        
        if (!input$company_university) {
          tryCatch({
            result <- select(result, -`单位/学校`)
          }, error = function(e)e)
        }
        
        if (!input$regist_time) {
          tryCatch({
            result <- select(result, -`注册时间`)
          }, error = function(e)e)
        }
        
        if (!input$last_login_time) {
          tryCatch({
            result <- select(result, -`最后登录时间`)
          }, error = function(e)e)
        }
        
        if (!input$phone_field) {
          tryCatch({
            result <- select(result, -`省份`, -`城市`)
          }, error = function(e)e)
        }
        
        if (!input$channel) {
          tryCatch({
            result <- select(result, -`渠道`)
          }, error = function(e)e)
        }
        
        return(result)
      })
      
      output$user_regist_table <- renderDataTable(
        user_regist_data(), 
        options = list(
          pageLength = 10
        )
      )
      
      output$helptext_ui <- renderUI({
        HTML(paste("<br/>注：", 
                   "1. '单位/学校'字段为用户填写个人状态的最后一项", 
                   "2. '省份'和'城市'字段为用户手机号段归属地", 
                   "3. '渠道'字段为用户最后一次登录时所使用思扣的安装渠道， 
						此外由于数据入库机制的原因，可能存在不活跃用户渠道数据
						 缺失的情况<br/>", 
                   sep = '<br/>'))
      })
    }
  })
  
})



















