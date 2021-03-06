output$uiLogin <- renderUI({
  
  if (!is.null(input$store$time_stamp)) {
    if (difftime(Sys.time(), input$store$time_stamp, units = 'secs') <= 60) {
      if (nrow(user_passwd[
        user_passwd$user == input$store$user_name &
        user_passwd$passwd == digest::digest(input$store$passwd, algo = 'xxhash64', seed = 622) &
        (user_passwd$module == 'download' | user_passwd$module == 'all'),
        ]) > 0) {
        
        login_data$logged <- TRUE
        
      }
    }
  }
  
  if (login_data$logged == FALSE) {
    wellPanel(
      textInput('user_name', '用户名：'),
      passwordInput('passwd', '密码：'),
      br(),
      actionButton('login', '登录')
    )
  }
})

output$pass <- renderText({
  if (login_data$logged == FALSE) {
    if (!is.null(input$login)) {
      if (input$login > 0) {
        if (nrow(user_passwd[
          user_passwd$user == input$user_name &
          user_passwd$passwd == digest::digest(input$passwd, algo = 'xxhash64', seed = 622) & 
          (user_passwd$module == 'download' | user_passwd$module == 'all'),
          ]) > 0) {
          
          login_data$logged <- TRUE
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