
library(RMySQL)
library(dplyr)
library(tidyr)

host <- '10.21.3.101'
port <- 3306
username <- 'r'
password <- '123456'
dbname <- 'daily'

pointRefresh <- function(now, point_data, con) {
    
    if (difftime(now, max(point_data$time_stamp), units = 'hours') < 1) {
        return(point_data)
    }
    
    point_data <- dbSendQuery(con, 'select * from stat.point_data;') %>% 
        dbFetch(n = -1)
    
    return(point_data)
}

# hourlyRefresh <- function(now, hourly_login, con) {
#     if (difftime(now, max(hourly_login$date_time), units = 'hours') < 1.1) {
#         return(hourly_login)
#     }
#     
#     hourly_login_new <- dbSendQuery(
#         con, 
#         paste0(
#             'select * from hourly.login where date_time > ', 
#             sprintf('\'%s\'', format(max(hourly_login$date_time), '%Y-%m-%d-%H')), 
#             ';'
#         )
#     ) %>% 
#         dbFetch(n = -1)
#     
#     hourly_login_new$date_time <- strptime(hourly_login_new$date_time,
#                                            format = '%Y-%m-%d-%H') %>% as.POSIXct()
#     temp_hr <- as.POSIXlt(now)
#     temp_hr$hour <- temp_hr$hour - 1
#     hr <- data.frame(date_time = seq(from = max(hourly_login$date_time), 
#                                      to = as.POSIXct(format(temp_hr, '%Y-%m-%d %H:00:00')), 
#                                      by = 'hour'))
#     
#     hourly_login_new <- left_join(hr, hourly_login_new, by = 'date_time') %>% 
#         select(date_time, new, active, login)
#     hourly_login_new[is.na(hourly_login_new)] <- 0
#     
#     return(rbind(hourly_login, hourly_login_new[-1, ]))
# }

hourlyDataRefresh <- function(now, hourly_data, con) {
    if (difftime(now, max(hourly_data$date_time), units = 'hours') < 1.1) {
        return(hourly_data)
    }
    
    hourly_data_new <- dbSendQuery(
        con, 
        paste0(
            'select ', 
            paste(colnames(hourly_data), collapse = ','), 
            ' from ', 
            sub('_', '.', deparse(substitute(hourly_data))), 
            ' where date_time > ', 
            sprintf('\'%s\'', format(max(hourly_data$date_time), '%Y-%m-%d-%H')), 
            ';'
        )
    ) %>% 
        dbFetch(n = -1)
    
    hourly_data_new$date_time <- strptime(hourly_data_new$date_time,
                                           format = '%Y-%m-%d-%H') %>% as.POSIXct()
    temp_hr <- as.POSIXlt(now)
    temp_hr$hour <- temp_hr$hour - 1
    hr <- data.frame(date_time = seq(from = max(hourly_data$date_time), 
                                     to = as.POSIXct(format(temp_hr, '%Y-%m-%d %H:00:00')), 
                                     by = 'hour'))
    
    hourly_data_new <- left_join(hr, hourly_data_new, by = 'date_time')
    hourly_data_new[is.na(hourly_data_new)] <- 0
    
    return(rbind(hourly_data, hourly_data_new[-1, ]))
}




city_location <- read.csv('city_location.csv', stringsAsFactors = FALSE, 
                          row.names = NULL, fileEncoding = 'utf-8')
city_with_quote <- paste0('\'', city_location$city, '\'')
province_with_quote <- paste0('\'', unique(city_location$province), '\'')

con <- dbConnect(MySQL(), host = host, port = port, 
                 username = username, password = password, 
                 dbname = dbname)
dbSendQuery(con, 'set names gbk')

res <- dbSendQuery(con, 'select * from stat.point_data;')
point_data <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from daily.login;')
daily_login <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from hourly.login;')
hourly_login <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from weekly.login')
weekly_login <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from monthly.login;')
monthly_login <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, paste0('SELECT create_time, longitude, latitude ', 
                               'FROM yz_app_trade_db.sell_commodity ', 
                               'WHERE del_status = 0 ', 
                               'AND account_id >= 20000 ', 
                               'AND commodity_status = 1;'))
user_location <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

demographic_test_string <- paste0("SELECT a.id, ", 
                                  "b.sex                              AS gender, ", 
                                  "b.highest_education                AS degree, ", 
                                  "Round(Timestampdiff(day, d.birth_date, Now()) / 365, 2) AS age, ", 
                                  "c.position_1name                                        AS university, ", 
                                  "c.status_category, ", 
                                  "a.regist_time ", 
                                  "FROM   yz_sys_db.ps_account AS a ", 
                                  "LEFT JOIN (SELECT ps.account_id, ", 
                                             "ps.sex, ", 
                                             "Ifnull(pub.d_values, ps.highest_education) AS highest_education ", 
                                             "FROM   yz_app_person_db.ps_attribute_variety AS ps ", 
                                             "LEFT JOIN yz_public_db.pub_dictionary AS pub ", 
                                             "ON ps.highest_education = pub.d_key ", 
                                             "AND pub.del_status = 0 ", 
                                             "AND pub.type = 'pub.学历' ", 
                                             "WHERE  ps.del_status = 0) AS b ", 
                                  "ON a.id = b.account_id ", 
                                  "LEFT JOIN (SELECT account_id, ", 
                                             "position_1name, ", 
                                             "status_category ", 
                                             "FROM   (SELECT account_id, ", 
                                                     "position_1name, ", 
                                                     "status_time, ", 
                                                     "status_category ", 
                                                     "FROM   yz_app_person_db.ps_vitae_main ", 
                                                     "WHERE  del_status = 0 ", 
                                                     "ORDER  BY status_time DESC) AS ps_vitae_main_temp ", 
                                             "GROUP  BY account_id) AS c ", 
                                  "ON a.id = c.account_id ", 
                                  "LEFT JOIN yz_app_person_db.ps_attribute_inva AS d ", 
                                  "ON a.id = d.account_id ", 
                                  "AND d.del_status = 0 ", 
                                  "WHERE  a.id >= 20000 ", 
                                  "AND a.del_status = 0; ")
res <- dbSendQuery(con, demographic_test_string)
demographic <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)
demographic$gender <- iconv(demographic$gender, 'gbk', 'utf-8')
demographic$degree <- iconv(demographic$degree, 'gbk', 'utf-8')
demographic$university <- iconv(demographic$university, 'gbk', 'utf-8')
demographic$regist_time <- as.POSIXct(demographic$regist_time)

res <- dbSendQuery(con, 'select * from daily.quick_chat;')
daily_quick_chat <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from hourly.quick_chat;')
hourly_quick_chat <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from weekly.quick_chat')
weekly_quick_chat <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from monthly.quick_chat;')
monthly_quick_chat <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from daily.calendar;')
daily_calendar <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from hourly.calendar;')
hourly_calendar <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from weekly.calendar')
weekly_calendar <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from monthly.calendar;')
monthly_calendar <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from daily.cooperation;')
daily_cooperation <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from hourly.cooperation;')
hourly_cooperation <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from weekly.cooperation')
weekly_cooperation <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from monthly.cooperation;')
monthly_cooperation <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from daily.hr;')
daily_hr <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from hourly.hr;')
hourly_hr <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from weekly.hr')
weekly_hr <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from monthly.hr;')
monthly_hr <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from daily.schedule;')
daily_schedule <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from hourly.schedule;')
hourly_schedule <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from weekly.schedule')
weekly_schedule <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from monthly.schedule;')
monthly_schedule <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from daily.trade;')
daily_trade <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from hourly.trade;')
hourly_trade <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from weekly.trade')
weekly_trade <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from monthly.trade;')
monthly_trade <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from daily.train;')
daily_train <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from hourly.train;')
hourly_train <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from weekly.train')
weekly_train <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from monthly.train;')
monthly_train <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)

# res <- dbSendQuery(con, paste0('SELECT commodity_category AS type, price ',
#                                'FROM yz_app_trade_db.sell_commodity ',
#                                'WHERE del_status = 0 ',
#                                'AND account_id >= 20000 ',
#                                'AND commodity_status = 1;'))
res <- dbSendQuery(con, paste0('SELECT b.category_name as type, a.price ',
                               'FROM yz_app_trade_db.sell_commodity AS a ',
                               'INNER JOIN yz_app_trade_db.commodity_category AS b ',
                               'ON a.commodity_category = b.category_code ',
                               'WHERE a.del_status = 0 ',
                               'AND a.account_id >= 20000 ',
                               'AND a.commodity_status = 1 ',
                               'AND b.del_status = 0;'))
sell_price <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)
sell_price$type <- iconv(sell_price$type, 'gbk', 'utf8')

# res <- dbSendQuery(con, paste0('SELECT commodity_category AS type, price ',
#                                'FROM yz_app_trade_db.purchase_commodity ',
#                                'WHERE del_status = 0 ',
#                                'AND account_id >= 20000 ',
#                                'AND commodity_status = 1;'))
res <- dbSendQuery(con, paste0('SELECT b.category_name as type, a.price ',
                               'FROM yz_app_trade_db.purchase_commodity AS a ',
                               'INNER JOIN yz_app_trade_db.commodity_category AS b ',
                               'ON a.commodity_category = b.category_code ',
                               'WHERE a.del_status = 0 ',
                               'AND a.account_id >= 20000 ',
                               'AND a.commodity_status = 1 ',
                               'AND b.del_status = 0;'))
buy_price <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)
buy_price$type <- iconv(buy_price$type, 'gbk', 'utf8')

dbDisconnect(con)

rm(con, res)


# =============================================================================

daily_login$date_time <- as.Date(daily_login$date_time)
hourly_login$date_time <- strptime(hourly_login$date_time, 
                                   format = '%Y-%m-%d-%H') %>% as.POSIXct()
weekly_login$first_weekday <- as.Date(weekly_login$first_weekday)
monthly_login$first_monthday <- strptime(paste0(monthly_login$year_month_id, '-01'), 
                                         format = '%Y-%m-%d') %>% as.Date()

daily_quick_chat$date_time <- as.Date(daily_quick_chat$date_time)
hourly_quick_chat$date_time <- strptime(hourly_quick_chat$date_time, 
                                        format = '%Y-%m-%d-%H') %>% as.POSIXct()
weekly_quick_chat$first_weekday <- as.Date(weekly_quick_chat$first_weekday)
monthly_quick_chat$first_monthday <- strptime(paste0(monthly_quick_chat$year_month_id, '-01'), 
                                              format = '%Y-%m-%d') %>% as.Date()

daily_calendar$date_time <- as.Date(daily_calendar$date_time)
hourly_calendar$date_time <- strptime(hourly_calendar$date_time, 
                                   format = '%Y-%m-%d-%H') %>% as.POSIXct()
weekly_calendar$first_weekday <- as.Date(weekly_calendar$first_weekday)
monthly_calendar$first_monthday <- strptime(paste0(monthly_calendar$year_month_id, '-01'), 
                                         format = '%Y-%m-%d') %>% as.Date()

daily_cooperation$date_time <- as.Date(daily_cooperation$date_time)
hourly_cooperation$date_time <- strptime(hourly_cooperation$date_time, 
                                   format = '%Y-%m-%d-%H') %>% as.POSIXct()
weekly_cooperation$first_weekday <- as.Date(weekly_cooperation$first_weekday)
monthly_cooperation$first_monthday <- strptime(paste0(monthly_cooperation$year_month_id, '-01'), 
                                         format = '%Y-%m-%d') %>% as.Date()

daily_hr$date_time <- as.Date(daily_hr$date_time)
hourly_hr$date_time <- strptime(hourly_hr$date_time, 
                                   format = '%Y-%m-%d-%H') %>% as.POSIXct()
weekly_hr$first_weekday <- as.Date(weekly_hr$first_weekday)
monthly_hr$first_monthday <- strptime(paste0(monthly_hr$year_month_id, '-01'), 
                                         format = '%Y-%m-%d') %>% as.Date()

daily_schedule$date_time <- as.Date(daily_schedule$date_time)
hourly_schedule$date_time <- strptime(hourly_schedule$date_time, 
                                   format = '%Y-%m-%d-%H') %>% as.POSIXct()
weekly_schedule$first_weekday <- as.Date(weekly_schedule$first_weekday)
monthly_schedule$first_monthday <- strptime(paste0(monthly_schedule$year_month_id, '-01'), 
                                         format = '%Y-%m-%d') %>% as.Date()

daily_trade$date_time <- as.Date(daily_trade$date_time)
hourly_trade$date_time <- strptime(hourly_trade$date_time, 
                                   format = '%Y-%m-%d-%H') %>% as.POSIXct()
weekly_trade$first_weekday <- as.Date(weekly_trade$first_weekday)
monthly_trade$first_monthday <- strptime(paste0(monthly_trade$year_month_id, '-01'), 
                                         format = '%Y-%m-%d') %>% as.Date()

daily_train$date_time <- as.Date(daily_train$date_time)
hourly_train$date_time <- strptime(hourly_train$date_time, 
                                   format = '%Y-%m-%d-%H') %>% as.POSIXct()
weekly_train$first_weekday <- as.Date(weekly_train$first_weekday)
monthly_train$first_monthday <- strptime(paste0(monthly_train$year_month_id, '-01'), 
                                         format = '%Y-%m-%d') %>% as.Date()
# =============================================================================

dt <- data.frame(date_time = seq(from = min(daily_login$date_time),
                                 to = Sys.Date() - 1, 
                                 by = 'day'))

daily_login <- left_join(dt, daily_login, by = 'date_time') %>%
    mutate(retention = round(retention / NEW, 3)) %>%
    select(date_time, new = NEW, active, login, retention, contains('freq'))
daily_login[is.na(daily_login)] <- 0

daily_quick_chat <- left_join(dt, daily_quick_chat, by = 'date_time') %>% 
    select(date_time, active_circle, message, active_user)
daily_quick_chat[is.na(daily_quick_chat)] <- 0

daily_calendar <- left_join(dt, daily_calendar, by = 'date_time') %>% 
    select(date_time, new_activity, new_user)
daily_calendar[is.na(daily_calendar)] <- 0

daily_cooperation <- left_join(dt, daily_cooperation, by = 'date_time') %>% 
    select(date_time, new_company,new_project, active_user, new_view, new_collect, new_apply)
daily_cooperation[is.na(daily_cooperation)] <- 0

daily_hr <- left_join(dt, daily_hr, by = 'date_time') %>% 
    select(date_time, new_user, new_company, new_recruitment, update_recruitment, 
           jobseekers_operation, hr_operation)
daily_hr[is.na(daily_hr)] <- 0

daily_schedule <- left_join(dt, daily_schedule, by = 'date_time') %>% 
    select(date_time, new_course, new_user, active_user, new_file, operation)
daily_schedule[is.na(daily_schedule)] <- 0

daily_trade <- left_join(dt, daily_trade, by = 'date_time') %>% 
    select(date_time, new_sell_info, new_buy_info, active_seller, active_buyer, 
           active_trader)
daily_trade[is.na(daily_trade)] <- 0

daily_train <- left_join(dt, daily_train, by = 'date_time') %>% 
    select(date_time, new_company, new_course, active_user, new_view, new_collect, 
           new_apply, new_contact)
daily_train[is.na(daily_train)] <- 0

# =============================================================================

temp_hr <- as.POSIXlt(Sys.time())
temp_hr$hour <- temp_hr$hour - 1
hr <- data.frame(date_time = seq(from = min(hourly_login$date_time), 
                                 to = as.POSIXct(format(temp_hr, '%Y-%m-%d %H:00:00')), 
                                 by = 'hour'))
rm(temp_hr)

hourly_login <- left_join(hr, hourly_login, by = 'date_time') %>% 
    select(date_time, new, active, login)
hourly_login[is.na(hourly_login)] <- 0

hourly_quick_chat <- left_join(hr, hourly_quick_chat, by = 'date_time') %>% 
    select(date_time, active_circle, message, active_user)
hourly_quick_chat[is.na(hourly_quick_chat)] <- 0

hourly_calendar <- left_join(hr, hourly_calendar, by = 'date_time') %>% 
    select(date_time, new_activity, new_user)
hourly_calendar[is.na(hourly_calendar)] <- 0

hourly_cooperation <- left_join(hr, hourly_cooperation, by = 'date_time') %>% 
    select(date_time, new_company,new_project, active_user, new_view, new_collect, new_apply)
hourly_cooperation[is.na(hourly_cooperation)] <- 0

hourly_hr <- left_join(hr, hourly_hr, by = 'date_time') %>% 
    select(date_time, new_user, new_company, new_recruitment, update_recruitment, 
           jobseekers_operation, hr_operation)
hourly_hr[is.na(hourly_hr)] <- 0

hourly_schedule <- left_join(hr, hourly_schedule, by = 'date_time') %>% 
    select(date_time, new_course, new_user, active_user, new_file, operation)
hourly_schedule[is.na(hourly_schedule)] <- 0

hourly_trade <- left_join(hr, hourly_trade, by = 'date_time') %>% 
    select(date_time, new_sell_info, new_buy_info, active_seller, active_buyer, 
           active_trader)
hourly_trade[is.na(hourly_trade)] <- 0

hourly_train <- left_join(hr, hourly_train, by = 'date_time') %>% 
    select(date_time, new_company, new_course, active_user, new_view, new_collect, 
           new_apply, new_contact)
hourly_train[is.na(hourly_train)] <- 0

# =============================================================================

wk <- data.frame(first_weekday = seq(from = min(weekly_login$first_weekday),
                                     to = max((Sys.Date() - 7), min(weekly_login$first_weekday)),
                                     by = 'week')) %>% 
    mutate(year_week = paste0(format(first_weekday, '%Y'), '-', format(first_weekday, '%V')))
weekly_login <- left_join(wk, weekly_login, c('first_weekday', 'year_week')) %>% 
    mutate(retention = round(retention / NEW, 3)) %>%
    select(date_time = first_weekday, year_week, new = NEW, active, login, retention)
weekly_login[is.na(weekly_login)] <- 0

weekly_quick_chat <- left_join(wk, weekly_quick_chat, c('first_weekday', 'year_week')) %>% 
    select(date_time = first_weekday, year_week, active_circle, message, active_user)
weekly_quick_chat[is.na(weekly_quick_chat)] <- 0

weekly_calendar <- left_join(wk, weekly_calendar, c('first_weekday', 'year_week')) %>% 
    select(date_time = first_weekday, year_week, new_activity, new_user)
weekly_calendar[is.na(weekly_calendar)] <- 0

weekly_cooperation <- left_join(wk, weekly_cooperation, c('first_weekday', 'year_week')) %>% 
    select(date_time = first_weekday, year_week, new_company,new_project, active_user, new_view, new_collect, new_apply)
weekly_cooperation[is.na(weekly_cooperation)] <- 0

weekly_hr <- left_join(wk, weekly_hr, c('first_weekday', 'year_week')) %>% 
    select(date_time = first_weekday, year_week, new_user, new_company, new_recruitment, update_recruitment, 
           jobseekers_operation, hr_operation)
weekly_hr[is.na(weekly_hr)] <- 0

weekly_schedule <- left_join(wk, weekly_schedule, c('first_weekday', 'year_week')) %>% 
    select(date_time = first_weekday, year_week, new_course, new_user, active_user, new_file, operation)
weekly_schedule[is.na(weekly_schedule)] <- 0

weekly_trade <- left_join(wk, weekly_trade, c('first_weekday', 'year_week')) %>% 
    select(date_time = first_weekday, year_week, new_sell_info, new_buy_info, active_seller, active_buyer, 
           active_trader)
weekly_trade[is.na(weekly_trade)] <- 0

weekly_train <- left_join(wk, weekly_train, c('first_weekday', 'year_week')) %>% 
    select(date_time = first_weekday, year_week, new_company, new_course, active_user, new_view, new_collect, 
           new_apply, new_contact)
weekly_train[is.na(weekly_train)] <- 0

# =============================================================================

# temp_mt_to <- Sys.Date() - as.POSIXlt(Sys.Date())$mday - 1
mt <- data.frame(first_monthday = seq(from = min(monthly_login$first_monthday), 
                                      to = Sys.Date(), 
                                      by = 'month')) %>% 
    mutate(year_month_id = paste0(format(first_monthday, '%Y'), '-', format(first_monthday, '%m')))
monthly_login <- left_join(mt, monthly_login, c('first_monthday', 'year_month_id')) %>% 
    mutate(retention = round(retention / NEW, 3)) %>%
    select(date_time = first_monthday, year_month_id, new = NEW, active, login, retention)
monthly_login[is.na(monthly_login)] <- 0

monthly_quick_chat <- left_join(mt, monthly_quick_chat, c('first_monthday', 'year_month_id')) %>% 
    select(date_time = first_monthday, active_circle, message, active_user)
monthly_quick_chat[is.na(monthly_quick_chat)] <- 0

monthly_calendar <- left_join(mt, monthly_calendar, c('first_monthday', 'year_month_id')) %>% 
    select(date_time = first_monthday, year_month_id, new_activity, new_user)
monthly_calendar[is.na(monthly_calendar)] <- 0

monthly_cooperation <- left_join(mt, monthly_cooperation, c('first_monthday', 'year_month_id')) %>% 
    select(date_time = first_monthday, year_month_id, new_company,new_project, active_user, new_view, new_collect, new_apply)
monthly_cooperation[is.na(monthly_cooperation)] <- 0

monthly_hr <- left_join(mt, monthly_hr, c('first_monthday', 'year_month_id')) %>% 
    select(date_time = first_monthday, year_month_id, new_user, new_company, new_recruitment, update_recruitment, 
           jobseekers_operation, hr_operation)
monthly_hr[is.na(monthly_hr)] <- 0

monthly_schedule <- left_join(mt, monthly_schedule, c('first_monthday', 'year_month_id')) %>% 
    select(date_time = first_monthday, year_month_id, new_course, new_user, active_user, new_file, operation)
monthly_schedule[is.na(monthly_schedule)] <- 0

monthly_trade <- left_join(mt, monthly_trade, c('first_monthday', 'year_month_id')) %>% 
    select(date_time = first_monthday, year_month_id, new_sell_info, new_buy_info, active_seller, active_buyer, 
           active_trader)
monthly_trade[is.na(monthly_trade)] <- 0

monthly_train <- left_join(mt, monthly_train, c('first_monthday', 'year_month_id')) %>% 
    select(date_time = first_monthday, year_month_id, new_company, new_course, active_user, new_view, new_collect, 
           new_apply, new_contact)
monthly_train[is.na(monthly_train)] <- 0


rm(dt, hr, wk, mt)
#==============================================================================
user_location <- na.omit(user_location)
user_location$create_time <- as.Date(user_location$create_time)

# =============================================================================
sell_price$price <- as.numeric(sell_price$price)
buy_price$price <- as.numeric(buy_price$price)







