
hourly_new <- xts(hourly_login$new, order.by = hourly_login$date_time)
names(hourly_new) <- 'new'
hourly_active <- xts(hourly_login$active, order.by = hourly_login$date_time)
names(hourly_active) <- 'active'
hourly_log_in <- xts(hourly_login$login, order.by = hourly_login$date_time)
names(hourly_log_in) <- 'login'

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








