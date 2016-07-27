
hourly_hr_new_user <- xts(hourly_hr$new_user, order.by = hourly_hr$date_time)
names(hourly_hr_new_user) <- 'new_user'
hourly_hr_new_company <- xts(hourly_hr$new_company, order.by = hourly_hr$date_time)
names(hourly_hr_new_company) <- 'new_company'
hourly_hr_new_recruitment <- xts(hourly_hr$new_recruitment, order.by = hourly_hr$date_time)
names(hourly_hr_new_recruitment) <- 'new_recruitment'
hourly_hr_update_recruitment <- xts(hourly_hr$update_recruitment, order.by = hourly_hr$date_time)
names(hourly_hr_update_recruitment) <- 'update_recruitment'
hourly_hr_jobseekers_operation <- xts(hourly_hr$jobseekers_operation, order.by = hourly_hr$date_time)
names(hourly_hr_jobseekers_operation) <- 'jobseekers_operation'
hourly_hr_hr_operation <- xts(hourly_hr$hr_operation, order.by = hourly_hr$date_time)
names(hourly_hr_hr_operation) <- 'hr_operation'

daily_hr_new_user <- xts(daily_hr$new_user, order.by = daily_hr$date_time)
names(daily_hr_new_user) <- 'new_user'
daily_hr_new_company <- xts(daily_hr$new_company, order.by = daily_hr$date_time)
names(daily_hr_new_company) <- 'new_company'
daily_hr_new_recruitment <- xts(daily_hr$new_recruitment, order.by = daily_hr$date_time)
names(daily_hr_new_recruitment) <- 'new_recruitment'
daily_hr_update_recruitment <- xts(daily_hr$update_recruitment, order.by = daily_hr$date_time)
names(daily_hr_update_recruitment) <- 'update_recruitment'
daily_hr_jobseekers_operation <- xts(daily_hr$jobseekers_operation, order.by = daily_hr$date_time)
names(daily_hr_jobseekers_operation) <- 'jobseekers_operation'
daily_hr_hr_operation <- xts(daily_hr$hr_operation, order.by = daily_hr$date_time)
names(daily_hr_hr_operation) <- 'hr_operation'

weekly_hr_new_user <- xts(weekly_hr$new_user, order.by = weekly_hr$date_time)
names(weekly_hr_new_user) <- 'new_user'
weekly_hr_new_company <- xts(weekly_hr$new_company, order.by = weekly_hr$date_time)
names(weekly_hr_new_company) <- 'new_company'
weekly_hr_new_recruitment <- xts(weekly_hr$new_recruitment, order.by = weekly_hr$date_time)
names(weekly_hr_new_recruitment) <- 'new_recruitment'
weekly_hr_update_recruitment <- xts(weekly_hr$update_recruitment, order.by = weekly_hr$date_time)
names(weekly_hr_update_recruitment) <- 'update_recruitment'
weekly_hr_jobseekers_operation <- xts(weekly_hr$jobseekers_operation, order.by = weekly_hr$date_time)
names(weekly_hr_jobseekers_operation) <- 'jobseekers_operation'
weekly_hr_hr_operation <- xts(weekly_hr$hr_operation, order.by = weekly_hr$date_time)
names(weekly_hr_hr_operation) <- 'hr_operation'

monthly_hr_new_user <- xts(monthly_hr$new_user, order.by = monthly_hr$date_time)
names(monthly_hr_new_user) <- 'new_user'
monthly_hr_new_company <- xts(monthly_hr$new_company, order.by = monthly_hr$date_time)
names(monthly_hr_new_company) <- 'new_company'
monthly_hr_new_recruitment <- xts(monthly_hr$new_recruitment, order.by = monthly_hr$date_time)
names(monthly_hr_new_recruitment) <- 'new_recruitment'
monthly_hr_update_recruitment <- xts(monthly_hr$update_recruitment, order.by = monthly_hr$date_time)
names(monthly_hr_update_recruitment) <- 'update_recruitment'
monthly_hr_jobseekers_operation <- xts(monthly_hr$jobseekers_operation, order.by = monthly_hr$date_time)
names(monthly_hr_jobseekers_operation) <- 'jobseekers_operation'
monthly_hr_hr_operation <- xts(monthly_hr$hr_operation, order.by = monthly_hr$date_time)
names(monthly_hr_hr_operation) <- 'hr_operation'









