
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

res <- dbSendQuery(con, 'select username as user, password as passwd, module
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

dbDisconnect(con)

rm(con, res)


# =============================================================================


daily_cooperation$date_time <- as.Date(daily_cooperation$date_time)
hourly_cooperation$date_time <- strptime(hourly_cooperation$date_time, 
                                   format = '%Y-%m-%d-%H') %>% as.POSIXct()
weekly_cooperation$first_weekday <- as.Date(weekly_cooperation$first_weekday)
monthly_cooperation$first_monthday <- strptime(paste0(monthly_cooperation$year_month_id, '-01'), 
                                         format = '%Y-%m-%d') %>% as.Date()

# =============================================================================

dt <- data.frame(date_time = seq(from = min(daily_cooperation$date_time),
                                 to = Sys.Date() - 1, 
                                 by = 'day'))

daily_cooperation <- left_join(dt, daily_cooperation, by = 'date_time') %>% 
    select(date_time, new_company,new_project, active_user, new_view, new_collect, new_apply)
daily_cooperation[is.na(daily_cooperation)] <- 0

# =============================================================================

temp_hr <- as.POSIXlt(Sys.time())
temp_hr$hour <- temp_hr$hour - 1
hr <- data.frame(date_time = seq(from = min(hourly_cooperation$date_time), 
                                 to = as.POSIXct(format(temp_hr, '%Y-%m-%d %H:00:00')), 
                                 by = 'hour'))
rm(temp_hr)

hourly_cooperation <- left_join(hr, hourly_cooperation, by = 'date_time') %>% 
    select(date_time, new_company,new_project, active_user, new_view, new_collect, new_apply)
hourly_cooperation[is.na(hourly_cooperation)] <- 0

# =============================================================================

wk <- data.frame(first_weekday = seq(from = min(weekly_cooperation$first_weekday),
                                     to = max((Sys.Date() - 7), min(weekly_cooperation$first_weekday)),
                                     by = 'week')) %>% 
    mutate(year_week = paste0(format(first_weekday, '%Y'), '-', format(first_weekday, '%V')))


weekly_cooperation <- left_join(wk, weekly_cooperation, c('first_weekday', 'year_week')) %>% 
    select(date_time = first_weekday, year_week, new_company,new_project, active_user, new_view, new_collect, new_apply)
weekly_cooperation[is.na(weekly_cooperation)] <- 0


# =============================================================================

# temp_mt_to <- Sys.Date() - as.POSIXlt(Sys.Date())$mday - 1
mt <- data.frame(first_monthday = seq(from = min(monthly_cooperation$first_monthday), 
                                      to = Sys.Date(), 
                                      by = 'month')) %>% 
    mutate(year_month_id = paste0(format(first_monthday, '%Y'), '-', format(first_monthday, '%m')))

monthly_cooperation <- left_join(mt, monthly_cooperation, c('first_monthday', 'year_month_id')) %>% 
    select(date_time = first_monthday, year_month_id, new_company,new_project, active_user, new_view, new_collect, new_apply)
monthly_cooperation[is.na(monthly_cooperation)] <- 0

rm(dt, hr, wk, mt)






