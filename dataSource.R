
library(RMySQL)
library(dplyr)

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

# res <- dbSendQuery(con, 'select * from daily.quick_chat;')
# daily_quick_chat <- dbFetch(res, n = -1)
# while (dbMoreResults(con)) {
#     dbNextResult(con)
# }
# dbClearResult(res)
# 
# res <- dbSendQuery(con, 'select * from hourly.quick_chat;')
# hourly_quick_chat <- dbFetch(res, n = -1)
# while (dbMoreResults(con)) {
#     dbNextResult(con)
# }
# dbClearResult(res)

dbDisconnect(con)

rm(con, res, host, port, username, password, dbname)


# =============================================================================

daily_login$date_time <- as.Date(daily_login$date_time)
hourly_login$date_time <- strptime(hourly_login$date_time, 
                                   format = '%Y-%m-%d-%H') %>% as.POSIXct()
weekly_login$first_weekday <- as.Date(weekly_login$first_weekday)
monthly_login$first_monthday <- strptime(paste0(monthly_login$year_month_id, '-01'), 
                                         format = '%Y-%m-%d') %>% as.Date()
# =============================================================================

dt <- data.frame(date_time = seq(from = min(daily_login$date_time),
                                 to = Sys.Date() - 1, 
                                 by = 'day'))

daily_login <- left_join(dt, daily_login, by = 'date_time') %>%
    select(date_time, new = NEW, active, login, retention, contains('freq'))
daily_login[is.na(daily_login)] <- 0

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

# =============================================================================

wk <- data.frame(first_weekday = seq(from = min(weekly_login$first_weekday),
                                     to = Sys.Date() - 7,
                                     by = 'week')) %>% 
    mutate(year_week = paste0(format(first_weekday, '%Y'), '-', format(first_weekday, '%V')))
weekly_login <- left_join(wk, weekly_login, c('first_weekday', 'year_week')) %>% 
    select(date_time = first_weekday, year_week, new = NEW, active, login, retention)
weekly_login[is.na(weekly_login)] <- 0

# =============================================================================

# temp_mt_to <- Sys.Date() - as.POSIXlt(Sys.Date())$mday - 1
mt <- data.frame(first_monthday = seq(from = min(monthly_login$first_monthday), 
                                      to = Sys.Date(), 
                                      by = 'month')) %>% 
    mutate(year_month_id = paste0(format(first_monthday, '%Y'), '-', format(first_monthday, '%m')))
monthly_login <- left_join(mt, monthly_login, c('first_monthday', 'year_month_id')) %>% 
    select(date_time = first_monthday, year_month_id, new = NEW, active, login, retention)
monthly_login[is.na(monthly_login)] <- 0

rm(dt, hr, wk, mt)




















