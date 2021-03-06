
output$uiLogin <- renderUI({
  
  if (!is.null(input$store$time_stamp)) {
    if (difftime(Sys.time(), input$store$time_stamp, units = 'secs') <= 60) {
      if (nrow(user_passwd[
        user_passwd$user == input$store$user_name &
        user_passwd$passwd == digest::digest(input$store$passwd, algo = 'xxhash64', seed = 622) &
        (user_passwd$module == 'slj' | user_passwd$module == 'all'),
        ]) > 0) {
        
        login_check$logged <- TRUE
        
      }
    }
  }
  
    if (login_check$logged == FALSE) {
        wellPanel(
            textInput('user_name', '用户名：'),
            passwordInput('passwd', '密码：'),
            br(),
            actionButton('login_button', '登录')
        )
    }
})

output$pass <- renderText({
    if (login_check$logged == FALSE) {
        if (!is.null(input$login_button)) {
            if (input$login_button > 0) {
                if (nrow(user_passwd[
                    user_passwd$user == input$user_name &
                    user_passwd$passwd == digest(input$passwd, algo = 'xxhash64', seed = 622) & 
                    (user_passwd$module == 'slj' | user_passwd$module == 'all'),
                    ]) > 0) {
                    login_check$logged <- TRUE
                    updateStore(session, 'user_name', isolate(input$user_name))
                    updateStore(session, 'passwd', isolate(input$passwd))
                    updateStore(session, 'time_stamp', as.character(Sys.time()))
                    
                } else {
                    '用户名或者密码错误'
                }
            }
        }
    }
})

