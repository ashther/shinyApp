output$uiLogin <- renderUI({
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
                    user_passwd$passwd == input$passwd,
                    ]) > 0) {
                    login_data$logged <- TRUE
                } else {
                    '用户名或者密码错误'
                }
            }
        }
    }
})