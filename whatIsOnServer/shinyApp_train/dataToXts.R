
hourly_train_new_company <- xts(hourly_train$new_company, order.by = hourly_train$date_time)
names(hourly_train_new_company) <- 'new_company'
hourly_train_new_course <- xts(hourly_train$new_course, order.by = hourly_train$date_time)
names(hourly_train_new_course) <- 'new_course'
hourly_train_active_user <- xts(hourly_train$active_user, order.by = hourly_train$date_time)
names(hourly_train_active_user) <- 'active_user'
hourly_train_new_view <- xts(hourly_train$new_view, order.by = hourly_train$date_time)
names(hourly_train_new_view) <- 'new_view'
hourly_train_new_collect <- xts(hourly_train$new_collect, order.by = hourly_train$date_time)
names(hourly_train_new_collect) <- 'new_collect'
hourly_train_new_apply <- xts(hourly_train$new_apply, order.by = hourly_train$date_time)
names(hourly_train_new_apply) <- 'new_apply'
hourly_train_new_contact <- xts(hourly_train$new_contact, order.by = hourly_train$date_time)
names(hourly_train_new_contact) <- 'new_contact'

daily_train_new_company <- xts(daily_train$new_company, order.by = daily_train$date_time)
names(daily_train_new_company) <- 'new_company'
daily_train_new_course <- xts(daily_train$new_course, order.by = daily_train$date_time)
names(daily_train_new_course) <- 'new_course'
daily_train_active_user <- xts(daily_train$active_user, order.by = daily_train$date_time)
names(daily_train_active_user) <- 'active_user'
daily_train_new_view <- xts(daily_train$new_view, order.by = daily_train$date_time)
names(daily_train_new_view) <- 'new_view'
daily_train_new_collect <- xts(daily_train$new_collect, order.by = daily_train$date_time)
names(daily_train_new_collect) <- 'new_collect'
daily_train_new_apply <- xts(daily_train$new_apply, order.by = daily_train$date_time)
names(daily_train_new_apply) <- 'new_apply'
daily_train_new_contact <- xts(daily_train$new_contact, order.by = daily_train$date_time)
names(daily_train_new_contact) <- 'new_contact'

weekly_train_new_company <- xts(weekly_train$new_company, order.by = weekly_train$date_time)
names(weekly_train_new_company) <- 'new_company'
weekly_train_new_course <- xts(weekly_train$new_course, order.by = weekly_train$date_time)
names(weekly_train_new_course) <- 'new_course'
weekly_train_active_user <- xts(weekly_train$active_user, order.by = weekly_train$date_time)
names(weekly_train_active_user) <- 'active_user'
weekly_train_new_view <- xts(weekly_train$new_view, order.by = weekly_train$date_time)
names(weekly_train_new_view) <- 'new_view'
weekly_train_new_collect <- xts(weekly_train$new_collect, order.by = weekly_train$date_time)
names(weekly_train_new_collect) <- 'new_collect'
weekly_train_new_apply <- xts(weekly_train$new_apply, order.by = weekly_train$date_time)
names(weekly_train_new_apply) <- 'new_apply'
weekly_train_new_contact <- xts(weekly_train$new_contact, order.by = weekly_train$date_time)
names(weekly_train_new_contact) <- 'new_contact'

monthly_train_new_company <- xts(monthly_train$new_company, order.by = monthly_train$date_time)
names(monthly_train_new_company) <- 'new_company'
monthly_train_new_course <- xts(monthly_train$new_course, order.by = monthly_train$date_time)
names(monthly_train_new_course) <- 'new_course'
monthly_train_active_user <- xts(monthly_train$active_user, order.by = monthly_train$date_time)
names(monthly_train_active_user) <- 'active_user'
monthly_train_new_view <- xts(monthly_train$new_view, order.by = monthly_train$date_time)
names(monthly_train_new_view) <- 'new_view'
monthly_train_new_collect <- xts(monthly_train$new_collect, order.by = monthly_train$date_time)
names(monthly_train_new_collect) <- 'new_collect'
monthly_train_new_apply <- xts(monthly_train$new_apply, order.by = monthly_train$date_time)
names(monthly_train_new_apply) <- 'new_apply'
monthly_train_new_contact <- xts(monthly_train$new_contact, order.by = monthly_train$date_time)
names(monthly_train_new_contact) <- 'new_contact'













