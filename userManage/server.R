
library(RMySQL)
source('www/dataSource.R', local = TRUE)
user_passwd <- data.frame(user = 'slj', passwd = '123456', stringsAsFactors = FALSE)
logged <- FALSE

shinyServer(function(input, output, session) {
    
    login_data <- reactiveValues(logged = logged)
    
    source('www/login.R', encoding = 'utf-8', local = TRUE)
    
    observe({
        if (login_data$logged == TRUE) {
            output$field <- renderUI({
                checkboxGroupInput(
                    'field', 
                    '选择其他需要的字段', 
                    choices = list('用户名' = 'b.full_name as \'用户名\'', 
                                   '单位/学校' = 'GROUP_CONCAT(c.position_1name) AS \'单位/学校\'', 
                                   '手机号' = 'a.username AS \'手机号\'', 
                                   '最后登录时间' = 'a.last_login_time AS \'最后登录时间\''), 
                    selected = c('b.full_name as \'用户名\'', 
                                 'GROUP_CONCAT(c.position_1name) AS \'单位/学校\'')
                )
            })
            
            output$date <- renderUI({
                dateRangeInput(
                    'date', 
                    '选择注册时间', 
                    start = '2016-04-28', 
                    end = Sys.Date() + 1
                )
            })
            
            output$user_regist_table <- renderTable({
                
            })
        }
    })
    
})



















