

hourly_cooperation_new_company <- xts(hourly_cooperation$new_company, order.by = hourly_cooperation$date_time)
names(hourly_cooperation_new_company) <- 'new_company'
hourly_cooperation_new_project <- xts(hourly_cooperation$new_project, order.by = hourly_cooperation$date_time)
names(hourly_cooperation_new_project) <- 'new_project'
hourly_cooperation_active_user <- xts(hourly_cooperation$active_user, order.by = hourly_cooperation$date_time)
names(hourly_cooperation_active_user) <- 'active_user'
hourly_cooperation_new_view <- xts(hourly_cooperation$new_view, order.by = hourly_cooperation$date_time)
names(hourly_cooperation_new_view) <- 'new_view'
hourly_cooperation_new_collect <- xts(hourly_cooperation$new_collect, order.by = hourly_cooperation$date_time)
names(hourly_cooperation_new_collect) <- 'new_collect'
hourly_cooperation_new_apply <- xts(hourly_cooperation$new_apply, order.by = hourly_cooperation$date_time)
names(hourly_cooperation_new_apply) <- 'new_apply'

daily_cooperation_new_company <- xts(daily_cooperation$new_company, order.by = daily_cooperation$date_time)
names(daily_cooperation_new_company) <- 'new_company'
daily_cooperation_new_project <- xts(daily_cooperation$new_project, order.by = daily_cooperation$date_time)
names(daily_cooperation_new_project) <- 'new_project'
daily_cooperation_active_user <- xts(daily_cooperation$active_user, order.by = daily_cooperation$date_time)
names(daily_cooperation_active_user) <- 'active_user'
daily_cooperation_new_view <- xts(daily_cooperation$new_view, order.by = daily_cooperation$date_time)
names(daily_cooperation_new_view) <- 'new_view'
daily_cooperation_new_collect <- xts(daily_cooperation$new_collect, order.by = daily_cooperation$date_time)
names(daily_cooperation_new_collect) <- 'new_collect'
daily_cooperation_new_apply <- xts(daily_cooperation$new_apply, order.by = daily_cooperation$date_time)
names(daily_cooperation_new_apply) <- 'new_apply'

weekly_cooperation_new_company <- xts(weekly_cooperation$new_company, order.by = weekly_cooperation$date_time)
names(weekly_cooperation_new_company) <- 'new_company'
weekly_cooperation_new_project <- xts(weekly_cooperation$new_project, order.by = weekly_cooperation$date_time)
names(weekly_cooperation_new_project) <- 'new_project'
weekly_cooperation_active_user <- xts(weekly_cooperation$active_user, order.by = weekly_cooperation$date_time)
names(weekly_cooperation_active_user) <- 'active_user'
weekly_cooperation_new_view <- xts(weekly_cooperation$new_view, order.by = weekly_cooperation$date_time)
names(weekly_cooperation_new_view) <- 'new_view'
weekly_cooperation_new_collect <- xts(weekly_cooperation$new_collect, order.by = weekly_cooperation$date_time)
names(weekly_cooperation_new_collect) <- 'new_collect'
weekly_cooperation_new_apply <- xts(weekly_cooperation$new_apply, order.by = weekly_cooperation$date_time)
names(weekly_cooperation_new_apply) <- 'new_apply'

monthly_cooperation_new_company <- xts(monthly_cooperation$new_company, order.by = monthly_cooperation$date_time)
names(monthly_cooperation_new_company) <- 'new_company'
monthly_cooperation_new_project <- xts(monthly_cooperation$new_project, order.by = monthly_cooperation$date_time)
names(monthly_cooperation_new_project) <- 'new_project'
monthly_cooperation_active_user <- xts(monthly_cooperation$active_user, order.by = monthly_cooperation$date_time)
names(monthly_cooperation_active_user) <- 'active_user'
monthly_cooperation_new_view <- xts(monthly_cooperation$new_view, order.by = monthly_cooperation$date_time)
names(monthly_cooperation_new_view) <- 'new_view'
monthly_cooperation_new_collect <- xts(monthly_cooperation$new_collect, order.by = monthly_cooperation$date_time)
names(monthly_cooperation_new_collect) <- 'new_collect'
monthly_cooperation_new_apply <- xts(monthly_cooperation$new_apply, order.by = monthly_cooperation$date_time)
names(monthly_cooperation_new_apply) <- 'new_apply'










