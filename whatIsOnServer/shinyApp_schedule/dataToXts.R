
hourly_schedule_new_course <- xts(hourly_schedule$new_course, order.by = hourly_schedule$date_time)
names(hourly_schedule_new_course) <- 'new_course'
hourly_schedule_new_user <- xts(hourly_schedule$new_user, order.by = hourly_schedule$date_time)
names(hourly_schedule_new_user) <- 'new_user'
hourly_schedule_active_user <- xts(hourly_schedule$active_user, order.by = hourly_schedule$date_time)
names(hourly_schedule_active_user) <- 'active_user'
hourly_schedule_new_file <- xts(hourly_schedule$new_file, order.by = hourly_schedule$date_time)
names(hourly_schedule_new_file) <- 'new_file'
hourly_schedule_oepration <- xts(hourly_schedule$operation, order.by = hourly_schedule$date_time)
names(hourly_schedule_oepration) <- 'operation'

daily_schedule_new_course <- xts(daily_schedule$new_course, order.by = daily_schedule$date_time)
names(daily_schedule_new_course) <- 'new_course'
daily_schedule_new_user <- xts(daily_schedule$new_user, order.by = daily_schedule$date_time)
names(daily_schedule_new_user) <- 'new_user'
daily_schedule_active_user <- xts(daily_schedule$active_user, order.by = daily_schedule$date_time)
names(daily_schedule_active_user) <- 'active_user'
daily_schedule_new_file <- xts(daily_schedule$new_file, order.by = daily_schedule$date_time)
names(daily_schedule_new_file) <- 'new_file'
daily_schedule_operation <- xts(daily_schedule$operation, order.by = daily_schedule$date_time)
names(daily_schedule_operation) <- 'operation'

weekly_schedule_new_course <- xts(weekly_schedule$new_course, order.by = weekly_schedule$date_time)
names(weekly_schedule_new_course) <- 'new_course'
weekly_schedule_new_user <- xts(weekly_schedule$new_user, order.by = weekly_schedule$date_time)
names(weekly_schedule_new_user) <- 'new_user'
weekly_schedule_active_user <- xts(weekly_schedule$active_user, order.by = weekly_schedule$date_time)
names(weekly_schedule_active_user) <- 'active_user'
weekly_schedule_new_file <- xts(weekly_schedule$new_file, order.by = weekly_schedule$date_time)
names(weekly_schedule_new_file) <- 'new_file'
weekly_schedule_oepration <- xts(weekly_schedule$operation, order.by = weekly_schedule$date_time)
names(weekly_schedule_oepration) <- 'operation'

monthly_schedule_new_course <- xts(monthly_schedule$new_course, order.by = monthly_schedule$date_time)
names(monthly_schedule_new_course) <- 'new_course'
monthly_schedule_new_user <- xts(monthly_schedule$new_user, order.by = monthly_schedule$date_time)
names(monthly_schedule_new_user) <- 'new_user'
monthly_schedule_active_user <- xts(monthly_schedule$active_user, order.by = monthly_schedule$date_time)
names(monthly_schedule_active_user) <- 'active_user'
monthly_schedule_new_file <- xts(monthly_schedule$new_file, order.by = monthly_schedule$date_time)
names(monthly_schedule_new_file) <- 'new_file'
monthly_schedule_oepration <- xts(monthly_schedule$operation, order.by = monthly_schedule$date_time)
names(monthly_schedule_oepration) <- 'operation'








