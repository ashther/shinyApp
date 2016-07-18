
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

# =============================================================================

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

# =============================================================================

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

# =============================================================================

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

# =============================================================================

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

# =============================================================================

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

# =============================================================================

hourly_trade_new_sell_info <- xts(hourly_trade$new_sell_info, order.by = hourly_trade$date_time)
names(hourly_trade_new_sell_info) <- 'new_sell_info'
hourly_trade_new_buy_info <- xts(hourly_trade$new_buy_info, order.by = hourly_trade$date_time)
names(hourly_trade_new_buy_info) <- 'new_buy_info'
hourly_trade_active_seller <- xts(hourly_trade$active_seller, order.by = hourly_trade$date_time)
names(hourly_trade_active_seller) <- 'active_seller'
hourly_trade_active_buyer <- xts(hourly_trade$active_buyer, order.by = hourly_trade$date_time)
names(hourly_trade_active_buyer) <- 'active_buyer'
hourly_trade_active_trader <- xts(hourly_trade$active_trader, order.by = hourly_trade$date_time)
names(hourly_trade_active_trader) <- 'active_trader'

daily_trade_new_sell_info <- xts(daily_trade$new_sell_info, order.by = daily_trade$date_time)
names(daily_trade_new_sell_info) <- 'new_sell_info'
daily_trade_new_buy_info <- xts(daily_trade$new_buy_info, order.by = daily_trade$date_time)
names(daily_trade_new_buy_info) <- 'new_buy_info'
daily_trade_active_seller <- xts(daily_trade$active_seller, order.by = daily_trade$date_time)
names(daily_trade_active_seller) <- 'active_seller'
daily_trade_active_buyer <- xts(daily_trade$active_buyer, order.by = daily_trade$date_time)
names(daily_trade_active_buyer) <- 'active_buyer'
daily_trade_active_trader <- xts(daily_trade$active_trader, order.by = daily_trade$date_time)
names(daily_trade_active_trader) <- 'active_trader'

weekly_trade_new_sell_info <- xts(weekly_trade$new_sell_info, order.by = weekly_trade$date_time)
names(weekly_trade_new_sell_info) <- 'new_sell_info'
weekly_trade_new_buy_info <- xts(weekly_trade$new_buy_info, order.by = weekly_trade$date_time)
names(weekly_trade_new_buy_info) <- 'new_buy_info'
weekly_trade_active_seller <- xts(weekly_trade$active_seller, order.by = weekly_trade$date_time)
names(weekly_trade_active_seller) <- 'active_seller'
weekly_trade_active_buyer <- xts(weekly_trade$active_buyer, order.by = weekly_trade$date_time)
names(weekly_trade_active_buyer) <- 'active_buyer'
weekly_trade_active_trader <- xts(weekly_trade$active_trader, order.by = weekly_trade$date_time)
names(weekly_trade_active_trader) <- 'active_trader'

monthly_trade_new_sell_info <- xts(monthly_trade$new_sell_info, order.by = monthly_trade$date_time)
names(monthly_trade_new_sell_info) <- 'new_sell_info'
monthly_trade_new_buy_info <- xts(monthly_trade$new_buy_info, order.by = monthly_trade$date_time)
names(monthly_trade_new_buy_info) <- 'new_buy_info'
monthly_trade_active_seller <- xts(monthly_trade$active_seller, order.by = monthly_trade$date_time)
names(monthly_trade_active_seller) <- 'active_seller'
monthly_trade_active_buyer <- xts(monthly_trade$active_buyer, order.by = monthly_trade$date_time)
names(monthly_trade_active_buyer) <- 'active_buyer'
monthly_trade_active_trader <- xts(monthly_trade$active_trader, order.by = monthly_trade$date_time)
names(monthly_trade_active_trader) <- 'active_trader'

# =============================================================================

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













