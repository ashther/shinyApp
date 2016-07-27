
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


con <- dbConnect(MySQL(), host = host, port = port, 
                 username = username, password = password, 
                 dbname = dbname)
# dbSendQuery(con, 'set names gbk')

res <- dbSendQuery(con, 'select username as user, password as passwd 
                   from shiny_data.shiny_user;')
user_passwd <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
  dbNextResult(con)
}
dbClearResult(res)

res <- dbSendQuery(con, 'select * from stat.point_data;')
point_data <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
    dbNextResult(con)
}
dbClearResult(res)


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


dbDisconnect(con)

rm(con, res)


# =============================================================================

daily_quick_chat$date_time <- as.Date(daily_quick_chat$date_time)
hourly_quick_chat$date_time <- strptime(hourly_quick_chat$date_time, 
                                        format = '%Y-%m-%d-%H') %>% as.POSIXct()
weekly_quick_chat$first_weekday <- as.Date(weekly_quick_chat$first_weekday)
monthly_quick_chat$first_monthday <- strptime(paste0(monthly_quick_chat$year_month_id, '-01'), 
                                              format = '%Y-%m-%d') %>% as.Date()

# =============================================================================

dt <- data.frame(date_time = seq(from = min(daily_quick_chat$date_time),
                                 to = Sys.Date() - 1, 
                                 by = 'day'))

daily_quick_chat <- left_join(dt, daily_quick_chat, by = 'date_time') %>% 
    select(date_time, active_circle, message, active_user)
daily_quick_chat[is.na(daily_quick_chat)] <- 0

# =============================================================================

temp_hr <- as.POSIXlt(Sys.time())
temp_hr$hour <- temp_hr$hour - 1
hr <- data.frame(date_time = seq(from = min(hourly_quick_chat$date_time), 
                                 to = as.POSIXct(format(temp_hr, '%Y-%m-%d %H:00:00')), 
                                 by = 'hour'))
rm(temp_hr)

hourly_quick_chat <- left_join(hr, hourly_quick_chat, by = 'date_time') %>% 
    select(date_time, active_circle, message, active_user)
hourly_quick_chat[is.na(hourly_quick_chat)] <- 0

# =============================================================================

wk <- data.frame(first_weekday = seq(from = min(weekly_quick_chat$first_weekday),
                                     to = max((Sys.Date() - 7), min(weekly_quick_chat$first_weekday)),
                                     by = 'week')) %>% 
    mutate(year_week = paste0(format(first_weekday, '%Y'), '-', format(first_weekday, '%V')))

weekly_quick_chat <- left_join(wk, weekly_quick_chat, c('first_weekday', 'year_week')) %>% 
    select(date_time = first_weekday, year_week, active_circle, message, active_user)
weekly_quick_chat[is.na(weekly_quick_chat)] <- 0

# =============================================================================

mt <- data.frame(first_monthday = seq(from = min(monthly_quick_chat$first_monthday), 
                                      to = Sys.Date(), 
                                      by = 'month')) %>% 
    mutate(year_month_id = paste0(format(first_monthday, '%Y'), '-', format(first_monthday, '%m')))

monthly_quick_chat <- left_join(mt, monthly_quick_chat, c('first_monthday', 'year_month_id')) %>% 
    select(date_time = first_monthday, active_circle, message, active_user)
monthly_quick_chat[is.na(monthly_quick_chat)] <- 0

rm(dt, hr, wk, mt)







