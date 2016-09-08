
output$uiLogin <- renderUI({
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
                } else {
                    '用户名或者密码错误'
                }
            }
        }
    }
})

