
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

dbDisconnect(con)

rm(con, res)


# =============================================================================

daily_schedule$date_time <- as.Date(daily_schedule$date_time)
hourly_schedule$date_time <- strptime(hourly_schedule$date_time, 
                                   format = '%Y-%m-%d-%H') %>% as.POSIXct()
weekly_schedule$first_weekday <- as.Date(weekly_schedule$first_weekday)
monthly_schedule$first_monthday <- strptime(paste0(monthly_schedule$year_month_id, '-01'), 
                                         format = '%Y-%m-%d') %>% as.Date()

# =============================================================================

dt <- data.frame(date_time = seq(from = min(daily_schedule$date_time),
                                 to = Sys.Date() - 1, 
                                 by = 'day'))

daily_schedule <- left_join(dt, daily_schedule, by = 'date_time') %>% 
    select(date_time, new_course, new_user, active_user, new_file, operation)
daily_schedule[is.na(daily_schedule)] <- 0


# =============================================================================

temp_hr <- as.POSIXlt(Sys.time())
temp_hr$hour <- temp_hr$hour - 1
hr <- data.frame(date_time = seq(from = min(hourly_schedule$date_time), 
                                 to = as.POSIXct(format(temp_hr, '%Y-%m-%d %H:00:00')), 
                                 by = 'hour'))
rm(temp_hr)


hourly_schedule <- left_join(hr, hourly_schedule, by = 'date_time') %>% 
    select(date_time, new_course, new_user, active_user, new_file, operation)
hourly_schedule[is.na(hourly_schedule)] <- 0

# =============================================================================

wk <- data.frame(first_weekday = seq(from = min(weekly_schedule$first_weekday),
                                     to = max((Sys.Date() - 7), min(weekly_schedule$first_weekday)),
                                     by = 'week')) %>% 
    mutate(year_week = paste0(format(first_weekday, '%Y'), '-', format(first_weekday, '%V')))

weekly_schedule <- left_join(wk, weekly_schedule, c('first_weekday', 'year_week')) %>% 
    select(date_time = first_weekday, year_week, new_course, new_user, active_user, new_file, operation)
weekly_schedule[is.na(weekly_schedule)] <- 0

# =============================================================================

# temp_mt_to <- Sys.Date() - as.POSIXlt(Sys.Date())$mday - 1
mt <- data.frame(first_monthday = seq(from = min(monthly_schedule$first_monthday), 
                                      to = Sys.Date(), 
                                      by = 'month')) %>% 
    mutate(year_month_id = paste0(format(first_monthday, '%Y'), '-', format(first_monthday, '%m')))


monthly_schedule <- left_join(mt, monthly_schedule, c('first_monthday', 'year_month_id')) %>% 
    select(date_time = first_monthday, year_month_id, new_course, new_user, active_user, new_file, operation)
monthly_schedule[is.na(monthly_schedule)] <- 0


rm(dt, hr, wk, mt)

# to get file_name from remote database
eval(parse(file = 'config.cnf'))

con <- dbConnect(MySQL(), host = host_app, port = port_app, 
                 username = username_app, password = password_app, 
                 dbname = dbname_app)

res <- dbSendQuery(con, 
                   "SELECT temp.file_name, 
                   temp.category_name, 
                   a.account_id, 
                   a.opreate_type, 
                   a.opreate_time 
                   FROM   yz_app_schedule2_db.course_file_opreate_log AS a 
                   LEFT JOIN (SELECT a.id, 
                              a.file_name, 
                              d.category_name 
                              FROM   yz_app_schedule2_db.course_file_detail AS a 
                              LEFT JOIN yz_app_course_resource_db.course_resource AS b 
                              ON a.sourse_file_id = b.id 
                              LEFT JOIN yz_app_course_resource_db.course_info AS c 
                              ON b.course_id = c.id 
                              LEFT JOIN yz_app_course_resource_db.course_category AS d 
                              ON c.category_code = d.category_code) AS temp 
                   ON a.file_id = temp.id 
                   WHERE  a.del_status = 0; ")
operate_log <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
  dbNextResult(con)
}
operate_log$opreate_time <- as.Date(operate_log$opreate_time)
dbClearResult(res)
dbDisconnect(con)
rm(con, res, host_app, port_app, username_app, password_app, dbname_app)





