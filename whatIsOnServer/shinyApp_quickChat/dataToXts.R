
hourly_quick_chat_active_circle <- xts(hourly_quick_chat$active_circle, order.by = hourly_quick_chat$date_time)
names(hourly_quick_chat_active_circle) <- 'active_circle'
hourly_quick_chat_message <- xts(hourly_quick_chat$message, order.by = hourly_quick_chat$date_time)
names(hourly_quick_chat_message) <- 'message'
hourly_quick_chat_active_user <- xts(hourly_quick_chat$active_user, order.by = hourly_quick_chat$date_time)
names(hourly_quick_chat_active_user) <- 'active_user'

daily_quick_chat_active_circle <- xts(daily_quick_chat$active_circle, order.by = daily_quick_chat$date_time)
names(daily_quick_chat_active_circle) <- 'active_circle'
daily_quick_chat_message <- xts(daily_quick_chat$message, order.by = daily_quick_chat$date_time)
names(daily_quick_chat_message) <- 'message'
daily_quick_chat_active_user <- xts(daily_quick_chat$active_user, order.by = daily_quick_chat$date_time)
names(daily_quick_chat_active_user) <- 'active_user'

weekly_quick_chat_active_circle <- xts(weekly_quick_chat$active_circle, order.by = weekly_quick_chat$date_time)
names(weekly_quick_chat_active_circle) <- 'active_circle'
weekly_quick_chat_message <- xts(weekly_quick_chat$message, order.by = weekly_quick_chat$date_time)
names(weekly_quick_chat_message) <- 'message'
weekly_quick_chat_active_user <- xts(weekly_quick_chat$active_user, order.by = weekly_quick_chat$date_time)
names(weekly_quick_chat_active_user) <- 'active_user'

monthly_quick_chat_active_circle <- xts(monthly_quick_chat$active_circle, order.by = monthly_quick_chat$date_time)
names(monthly_quick_chat_active_circle) <- 'active_circle'
monthly_quick_chat_message <- xts(monthly_quick_chat$message, order.by = monthly_quick_chat$date_time)
names(monthly_quick_chat_message) <- 'message'
monthly_quick_chat_active_user <- xts(monthly_quick_chat$active_user, order.by = monthly_quick_chat$date_time)
names(monthly_quick_chat_active_user) <- 'active_user'













