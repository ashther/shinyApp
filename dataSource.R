
library(RMySQL)
library(dplyr)
library(ggplot2)

host <- '10.21.3.101'
port <- 3306
username <- 'r'
password <- '123456'
dbname <- 'daily'


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

dbDisconnect(con)

rm(con, res, host, port, username, password, dbname)

daily_login$date_time <- as.Date(daily_login$date_time)
daily_login$time_stamp <- as.POSIXct(daily_login$time_stamp)

daily_quick_chat$date_time <- as.Date(daily_quick_chat$date_time)
daily_quick_chat$time_stamp <- as.POSIXct(daily_quick_chat$time_stamp)

hourly_login$date_time <- strptime(hourly_login$date_time, 
                                   format = '%Y-%m-%d-%H') %>% as.POSIXct()
hourly_login$time_stamp <- as.POSIXct(hourly_login$time_stamp)

hourly_quick_chat$date_time <- strptime(hourly_quick_chat$date_time, 
                                        format = '%Y-%m-%d-%H') %>% as.POSIXct()
hourly_quick_chat$time_stamp <- as.POSIXct(hourly_quick_chat$time_stamp)

dt <- data.frame(date_time = seq(from = min(daily_login$date_time),
                                 to = Sys.Date() - 1, by = 1))

daily_login <- left_join(dt, daily_login, by = 'date_time') %>%
    select(date_time, new, active, login, retention)
daily_login[is.na(daily_login)] <- 0

daily_quick_chat <- left_join(dt, daily_quick_chat, by = 'date_time') %>%
    select(date_time, active_circle, message, active_user)
daily_quick_chat[is.na(daily_quick_chat)] <- 0

temp_hr <- as.POSIXlt(Sys.time())
temp_hr$hour <- temp_hr$hour - 1
hr <- data.frame(date_time = seq(from = min(hourly_login$date_time), 
                                 to = as.POSIXct(format(temp_hr, '%Y-%m-%d %H:00:00')), 
                                 by = 'hour'))

hourly_login <- left_join(hr, hourly_login, by = 'date_time') %>% 
    select(date_time, new, active, login)
hourly_login[is.na(hourly_login)] <- 0

hourly_quick_chat <- left_join(hr, hourly_quick_chat, by = 'date_time') %>% 
    select(date_time, active_circle, message, active_user)
hourly_quick_chat[is.na(hourly_quick_chat)] <- 0

























