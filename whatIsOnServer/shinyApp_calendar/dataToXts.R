
hourly_calendar_new_activity <- xts(hourly_calendar$new_activity, order.by = hourly_calendar$date_time)
names(hourly_calendar_new_activity) <- 'new_activity'
hourly_calendar_new_user <- xts(hourly_calendar$new_user, order.by = hourly_calendar$date_time)
names(hourly_calendar_new_user) <- 'new_user'

daily_calendar_new_activity <- xts(daily_calendar$new_activity, order.by = daily_calendar$date_time)
names(daily_calendar_new_activity) <- 'new_activity'
daily_calendar_new_user <- xts(daily_calendar$new_user, order.by = daily_calendar$date_time)
names(daily_calendar_new_user) <- 'new_user'

weekly_calendar_new_activity <- xts(weekly_calendar$new_activity, order.by = weekly_calendar$date_time)
names(weekly_calendar_new_activity) <- 'new_activity'
weekly_calendar_new_user <- xts(weekly_calendar$new_user, order.by = weekly_calendar$date_time)
names(weekly_calendar_new_user) <- 'new_user'

monthly_calendar_new_activity <- xts(monthly_calendar$new_activity, order.by = monthly_calendar$date_time)
names(monthly_calendar_new_activity) <- 'new_activity'
monthly_calendar_new_user <- xts(monthly_calendar$new_user, order.by = monthly_calendar$date_time)
names(monthly_calendar_new_user) <- 'new_user'












