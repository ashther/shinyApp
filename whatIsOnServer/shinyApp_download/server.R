
source('www/dataSource.R', local = TRUE)
# user_passwd <- data.frame(user = c('sunlj', 'zhoumn', 'zhangp', 'chenmq'), 
#                           passwd = c('sunlj', 'zhoumn', 'zhangp', 'chenmq'), 
#                           stringsAsFactors = FALSE)
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
            output$field_ui <- renderUI({
                checkboxGroupInput(
                    inputId = 'field', 
                    label = '可选字段', 
                    choices = list('用户名' = 'b.full_name as \'用户名\'', 
                                   '单位/学校' = 'GROUP_CONCAT(c.position_1name) AS \'单位/学校\'', 
                                   '手机号' = 'a.username AS \'手机号\'', 
                                   '最后登录时间' = 'a.last_login_time AS \'最后登录时间\''), 
                    selected = c('b.full_name as \'用户名\'', 
                                 'GROUP_CONCAT(c.position_1name) AS \'单位/学校\'', 
                                 'a.username AS \'手机号\'', 
                                 'a.last_login_time AS \'最后登录时间\'')
                )
            })
            
            output$phone_field_ui <- renderUI({
              checkboxInput(
                inputId = 'phone_field', 
                label = '用户手机归属地（需要用户手机号）', 
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
            
            output$head_n_ui <- renderUI({
                numericInput('head_n', '选择预览行数', 5, 
                             min = 1, max = 20, step = 1, width = '15%')
            })
            
            user_regist_data <- eventReactive(input$select_button, {
                result <- c('a.id', input$field, 'a.regist_time AS \'注册时间\'') %>%
                  paste(collapse = ',') %>% 
                  paste('select', ., 'FROM yz_sys_db.ps_account AS a
LEFT JOIN yz_app_person_db.ps_attribute_variety AS b ON a.id = b.account_id
                          AND b.del_status = 0
                          LEFT JOIN
                          (SELECT account_id,
                          position_1name
                          FROM
                          (SELECT account_id,
                          position_1name,
                          status_time
                          FROM yz_app_person_db.ps_vitae_main
                          WHERE del_status = 0
                          ORDER BY status_time DESC) AS ps_vitae_main_temp
                          GROUP BY account_id) AS c ON a.id = c.account_id
                          WHERE a.id >= 20000
			  and a.del_status = 0
			  and a.username not like \'913%\'
                          AND b.full_name IS NOT NULL 
                          AND a.regist_time BETWEEN',
                        sprintf('\'%s\'', input$date[1]), 
                        'AND DATE_ADD(', 
                        sprintf('\'%s\'', input$date[2]), 
                        ', INTERVAL 1 DAY) GROUP BY a.id;', 
                        sep = ' '
                  ) %>% 
                  dataGet()
                
                if (input$phone_field) {
                  tryCatch({
                    result$field <- floor(as.numeric(result$`手机号`)/10000)
                    result <- left_join(result, mobile_info, 'field') %>% 
                      select(-field)
                  }, error = function(e)e)
                }
                
                return(result)
            })
            
            output$nrow <- renderText({
                sprintf('共有%s行数据', nrow(user_regist_data()))
            })
            
            output$user_regist_table <- renderTable({
                tail(user_regist_data(), input$head_n)
            })
        }
    })
    
})



















