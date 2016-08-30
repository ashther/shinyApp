
hourly_new <- xts(hourly_login$new, order.by = hourly_login$date_time)
names(hourly_new) <- 'new'
hourly_active <- xts(hourly_login$active, order.by = hourly_login$date_time)
names(hourly_active) <- 'active'
hourly_log_in <- xts(hourly_login$login, order.by = hourly_login$date_time)
names(hourly_log_in) <- 'login'

hourly_active_7days <- xts(hourly_login_7days$active_7days, 
                           order.by = hourly_login_7days$date_time)
names(hourly_active_7days) <- 'active_7days'
hourly_new_7days <- xts(hourly_login_7days$new_7days, 
                           order.by = hourly_login_7days$date_time)
names(hourly_new_7days) <- 'new_7days'
hourly_log_in_7days <- xts(hourly_login_7days$log_in_7days, 
                           order.by = hourly_login_7days$date_time)
names(hourly_log_in_7days) <- 'log_in_7days'

hourly_active_30days <- xts(hourly_login_30days$active_30days, 
                           order.by = hourly_login_30days$date_time)
names(hourly_active_30days) <- 'active_30days'
hourly_new_30days <- xts(hourly_login_30days$new_30days, 
                        order.by = hourly_login_30days$date_time)
names(hourly_new_30days) <- 'new_30days'
hourly_log_in_30days <- xts(hourly_login_30days$log_in_30days, 
                           order.by = hourly_login_30days$date_time)
names(hourly_log_in_30days) <- 'log_in_30days'

hourly_active_1day <- xts(hourly_login_1day$active_1day, 
                           order.by = hourly_login_1day$date_time)
names(hourly_active_1day) <- 'active_1day'
hourly_new_1day <- xts(hourly_login_1day$new_1day, 
                        order.by = hourly_login_1day$date_time)
names(hourly_new_1day) <- 'new_1day'
hourly_log_in_1day <- xts(hourly_login_1day$log_in_1day, 
                           order.by = hourly_login_1day$date_time)
names(hourly_log_in_1day) <- 'log_in_1day'

daily_new <- xts(daily_login$new, order.by = daily_login$date_time)
names(daily_new) <- 'new'
daily_active <- xts(daily_login$active, order.by = daily_login$date_time)
names(daily_active) <- 'active'
daily_log_in <- xts(daily_login$login, order.by = daily_login$date_time)
names(daily_log_in) <- 'login'
daily_retention <- xts(daily_login$retention, order.by = daily_login$date_time)
names(daily_retention) <- 'retention'

daily_freq_5p <- xts(daily_login$freq_5p, order.by = daily_login$date_time)
names(daily_freq_5p) <- '5+'
daily_freq_5 <- xts(daily_login$freq_5, order.by = daily_login$date_time)
names(daily_freq_5) <- '5'
daily_freq_4 <- xts(daily_login$freq_4, order.by = daily_login$date_time)
names(daily_freq_4) <- '4'
daily_freq_3 <- xts(daily_login$freq_3, order.by = daily_login$date_time)
names(daily_freq_3) <- '3'
daily_freq_2 <- xts(daily_login$freq_2, order.by = daily_login$date_time)
names(daily_freq_2) <- '2'
daily_freq_1 <- xts(daily_login$freq_1, order.by = daily_login$date_time)
names(daily_freq_1) <- '1'

weekly_new <- xts(weekly_login$new, order.by = weekly_login$date_time)
names(weekly_new) <- 'new'
weekly_active <- xts(weekly_login$active, order.by = weekly_login$date_time)
names(weekly_active) <- 'active'
weekly_log_in <- xts(weekly_login$login, order.by = weekly_login$date_time)
names(weekly_log_in) <- 'login'
weekly_retention <- xts(weekly_login$retention, order.by = weekly_login$date_time)
names(weekly_retention) <- 'retention'

monthly_new <- xts(monthly_login$new, order.by = monthly_login$date_time)
names(monthly_new) <- 'new'
monthly_active <- xts(monthly_login$active, order.by = monthly_login$date_time)
names(monthly_active) <- 'active'
monthly_log_in <- xts(monthly_login$login, order.by = monthly_login$date_time)
names(monthly_log_in) <- 'login'
monthly_retention <- xts(monthly_login$retention, order.by = monthly_login$date_time)
names(monthly_retention) <- 'retention'








