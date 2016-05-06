
shinyServer(function(input, output, session) {
    
    interval_min <- 1
    
    total_user_rea <- 
        reactivePoll(
            intervalMillis = interval_min * 60 * 1000, 
            session = session, 
            checkFunc = function() {
                as.numeric(Sys.time()) / (interval_min * 60)
            },
            valueFunc = function() {
                totalUserCreate(con)
            }
        )
    
    new_user_today_rea <- 
        reactivePoll(
            intervalMillis = interval_min * 60 * 1000, 
            session = session, 
            checkFunc = function() {
                as.numeric(Sys.time()) / (interval_min * 60)
            },
            valueFunc = function() {
                newUserCreate(con)
            }
        )
    
    active_user_today_rea <- 
        reactivePoll(
            intervalMillis = interval_min * 60 * 1000, 
            session = session, 
            checkFunc = function() {
                as.numeric(Sys.time()) / (interval_min * 60)
            },
            valueFunc = function() {
                activeLoginCreate(con)[1, 1]
            }
        )
    
    login_times_today_rea <- 
        reactivePoll(
            intervalMillis = interval_min * 60 * 1000, 
            session = session, 
            checkFunc = function() {
                as.numeric(Sys.time()) / (interval_min * 60)
            },
            valueFunc = function() {
                activeLoginCreate(con)[1, 2]
            }
        )
    
    hourly_new_rea <- 
        reactivePoll(
            intervalMillis = interval_min * 60 * 1000, 
            session = session, 
            checkFunc = function() {
                as.numeric(Sys.time()) / (interval_min * 60)
            },
            valueFunc = function() {
                hourlyNewCreate(con)
            }
        )
    
    hourly_active_login_rea <- 
        reactivePoll(
            intervalMillis = interval_min * 60 * 1000, 
            session = session, 
            checkFunc = function() {
                as.numeric(Sys.time()) / (interval_min * 60)
            },
            valueFunc = function() {
                hourlyActiveLoginCreate(con)
            }
        )

    # 累计用户数
    output$total_user <- renderValueBox({
        valueBox(total_user_rea(), '累计用户数', icon('users'))
    })
    
    # 当日新增用户数
    output$new_user_today <- renderValueBox({
        valueBox(new_user_today_rea(), '今日新增用户数', icon('user-plus'))
    })
    
    # 当日活跃用户数
    output$active_user_today <- renderValueBox({
        valueBox(active_user_today_rea(), '今日活跃用户数', icon('user'))
    })
    # 当日登陆次数
    output$login_times_today <- renderValueBox({
        valueBox(login_times_today_rea(), '今日登录次数', icon('power-off'))
    })
    
    # 24小时新增用户数
    output$hourly_new <- renderDygraph({
        dygraph(hourly_new_rea(),
                main = '24小时新增用户数',
                height = 100) %>%
            dySeries(label = '新增用户数') %>%
            dyOptions(fillGraph = TRUE, fillAlpha = 0.2) %>%
            dyLegend(show = 'follow', hideOnMouseOut = TRUE)
    })

    # 24小时活跃用户数
    output$hourly_active <- renderDygraph({
        dygraph(hourly_active_login_rea()$active,
                main = '24小时活跃用户数',
                height = 100) %>%
            dySeries(label = '活跃用户数') %>%
            dyOptions(fillGraph = TRUE, fillAlpha = 0.2) %>%
            dyLegend(show = 'follow', hideOnMouseOut = TRUE)
    })

    # 24小时登录次数
    output$hourly_login <- renderDygraph({
        dygraph(hourly_active_login_rea(),
                main = '24小时登录次数',
                height = 100) %>%
            dySeries(label = '登陆次数') %>%
            dyOptions(fillGraph = TRUE, fillAlpha = 0.2) %>%
            dyLegend(show = 'follow', hideOnMouseOut = TRUE)
    })
    
})



















