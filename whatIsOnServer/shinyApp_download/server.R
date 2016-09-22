library(ggplot2)
library(RMySQL)
library(dplyr)
library(shinyStore)
source('www/dataSource.R')

logged <- FALSE

shinyServer(function(input, output, session) {
  
  login_data <- reactiveValues(logged = logged)
  
  # output$test <- renderPrint({
  #   cat(
  #     'time_stamp: ', input$store$time_stamp, '\n',
  #     'sys.time: ', as.character(Sys.time()), '\n',
  #     'username: ', input$store$user_name, '\n',
  #     'password: ', input$store$passwd, '\n',
  #     'test_value: ', is.null(input$store$test_value)
  #   )
  # })
  
  source('www/login.R', encoding = 'utf-8', local = TRUE)
  
  observe({
    if (login_data$logged == TRUE) {
      source('shinyServerLog.R', encoding = 'utf-8', local = TRUE)
    } 
  })
  
  observe({
    if (login_data$logged == TRUE) {
      
      output$company_university_ui <- renderUI({
        choices <- unique(users$`单位/学校`)
        choices[is.na(choices)] <- '缺失'
        choices <- c('不限', choices)
        
        selectizeInput(
          inputId = 'company_university', 
          label = '单位/学校', 
          choices = choices, 
          selected = '不限'
        )
      })
      
      output$regist_time_ui <- renderUI({
        dateRangeInput(
          inputId = 'regist_time', 
          label = '注册时间', 
          min = '2016-04-28', 
          max = Sys.Date(), 
          start = '2016-04-28', 
          end = Sys.Date(), 
          language = 'zh-CN'
        )
      })
      
      output$last_login_time_ui <- renderUI({
        dateRangeInput(
          inputId = 'last_login_time', 
          label = '最后登录时间', 
          min = '2016-04-28', 
          max = Sys.Date(), 
          start = '2016-04-28', 
          end = Sys.Date(), 
          language = 'zh-CN'
        )
      })
      
      output$phone_field_ui <- renderUI({
        choices <- unique(paste(users$`省份`, users$`城市`, sep = '-'))
        choices[is.na(choices)] <- '缺失'
        choices <- c('不限', choices)
        
        selectizeInput(
          inputId = 'phone_field', 
          label = '用户手机号归属地', 
          choices = choices, 
          selected = '不限'
        )
      })
      
      output$channel_ui <- renderUI({
        choices <- unique(users$`渠道`)
        choices[is.na(choices)] <- '缺失'
        choices <- c('不限', choices)
        
        selectizeInput(
          inputId = 'channel', 
          label = '渠道', 
          choices = choices, 
          selected = '不限'
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
              dataGet(max(users$注册时间), host, port, username, 
                      password, dbname, mobile_info),
              select(users, -`最后登录时间`)
            ) %>% 
              lastLoginGet()
          }, error = function(e)return(users))
          setProgress(1)
        })
        
        return(result)
      })
      
      user_regist_data <- reactive({
        
        result <- user_regist_temp() %>% 
          filter(`注册时间` >= input$regist_time[1] & 
                   `注册时间` <= input$regist_time[2] & 
                   ((`最后登录时间` >= input$last_login_time[1] & 
                       `最后登录时间` <= input$last_login_time[2]) |
                      is.na(`最后登录时间`)))
        
        if (input$company_university != '不限') {
          if (input$company_university != '缺失') {
            result <- result %>% 
              filter(`单位/学校` == input$company_university)
          } else {
            result <- result %>% 
              filter(is.na(`单位/学校`))
          }
        }
        
        if (input$channel != '不限') {
          if (input$channel != '缺失') {
            result <- result %>% 
              filter(`渠道` == input$channel)
          } else {
            result <- result %>% 
              filter(is.na(`渠道`))
          }
        }
        
        if (input$phone_field != '不限') {
          
          
          if (input$phone_field != '缺失') {
            temp <- unlist(strsplit(input$phone_field, '-'))
            result <- result %>% 
              filter(`省份` == temp[1] & `城市` == temp[2])
          } else {
            result <- result %>% 
              filter(is.na(`省份`))
          }
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



















