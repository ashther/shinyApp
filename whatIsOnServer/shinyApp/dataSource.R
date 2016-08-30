
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

appStartRefresh <- function(now, app_start, con) {
  if (difftime(now, max(app_start$timestamp), units = 'hours') < 1) {
    return(app_start)
  }
  
  temp <- dbSendQuery(
    con, 
    paste0(
      "SELECT a.id, 
       a.user_id, 
       IFNULL(a.app_version_code, '缺失') AS version, 
       IFNULL(( CASE a.app_channel_id 
                  WHEN 'A001' THEN '360' 
                  WHEN 'A002' THEN '百度' 
                  WHEN 'A003' THEN '腾讯' 
                  WHEN 'A004' THEN '豌豆荚' 
                  WHEN 'A005' THEN '小米' 
                  WHEN 'A006' THEN 'oppo' 
                  WHEN 'A007' THEN '魅族' 
                  WHEN 'A008' THEN '华为' 
                  WHEN 'A009' THEN '其他'
                  WHEN 'appstore' THEN '苹果' 
                  ELSE a.app_channel_id 
                END ), '缺失')            AS channel, 
       ( a.lon - 0.011 )                    AS lon, 
       ( a.lat - 0.004 )                    AS lat, 
       a.time_stamp, 
       b.regist_time 
FROM   yz_app_track_db.app_start AS a 
       INNER JOIN yz_sys_db.ps_account AS b 
               ON a.user_id = b.id 
WHERE  a.del_status = 0 
       AND b.del_status = 0 
       AND a.user_id >= 20000
       AND a.time_stamp > ", 
       sprintf("'%s'", max(app_start$timestamp)), 
      ";"
    )
  ) %>% 
    dbFetch(n = -1)
  
  temp$timestamp <- temp$time_stamp
  temp$time_stamp <- as.Date(temp$time_stamp)
  temp$regist_time <- as.Date(temp$regist_time)
  temp$user_id <- as.integer(temp$user_id)
  
  app_start <- rbind(app_start, temp)
  
  return(app_start)
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




# city_location <- read.csv('city_location.csv', stringsAsFactors = FALSE, 
#                           row.names = NULL, fileEncoding = 'utf-8')
# city_with_quote <- paste0('\'', city_location$city, '\'')
# province_with_quote <- paste0('\'', unique(city_location$province), '\'')

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

res <- dbSendQuery(con, "select province, city, lng, lat 
                   from shiny_data.cityInfo
                   where country in ('China', 'Canada')
                   or iso3 = 'USA';")
city_location <- dbFetch(res, n = -1)
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

# res <- dbSendQuery(con, paste0('SELECT create_time, longitude, latitude ', 
#                                'FROM yz_app_trade_db.sell_commodity ', 
#                                'WHERE del_status = 0 ', 
#                                'AND account_id >= 20000 ', 
#                                'AND commodity_status = 1;'))
# user_location <- dbFetch(res, n = -1)
# while (dbMoreResults(con)) {
#     dbNextResult(con)
# }
# dbClearResult(res)

res <- dbSendQuery(con, paste0("SELECT a.id, 
       a.user_id, 
       Ifnull(a.app_version_code, '缺失') AS version, 
       Ifnull(( CASE a.app_channel_id 
                  WHEN 'A001' THEN '360' 
                  WHEN 'A002' THEN '百度' 
                  WHEN 'A003' THEN '腾讯' 
                  WHEN 'A004' THEN '豌豆荚' 
                  WHEN 'A005' THEN '小米' 
                  WHEN 'A006' THEN 'oppo' 
                  WHEN 'A007' THEN '魅族' 
                  WHEN 'A008' THEN '华为' 
                  WHEN 'A009' THEN '其他'
                  WHEN 'appstore' THEN '苹果' 
                  ELSE a.app_channel_id 
                END ), '缺失')            AS channel, 
       ( a.lon - 0.011 )                    AS lon, 
       ( a.lat - 0.004 )                    AS lat, 
       a.time_stamp, 
       b.regist_time 
FROM   yz_app_track_db.app_start AS a 
       INNER JOIN yz_sys_db.ps_account AS b 
               ON a.user_id = b.id 
WHERE  a.del_status = 0 
       AND b.del_status = 0 
       AND a.user_id >= 20000;"))
app_start <- dbFetch(res, n = -1)
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
# demographic$gender <- iconv(demographic$gender, 'gbk', 'utf-8')
# demographic$degree <- iconv(demographic$degree, 'gbk', 'utf-8')
# demographic$university <- iconv(demographic$university, 'gbk', 'utf-8')
demographic$regist_time <- as.POSIXct(demographic$regist_time)

dbDisconnect(con)

rm(con, res)


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
    mutate(retention = round(retention / NEW, 3)) %>%
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

hourly_login_7days <- hourly_login %>% 
  filter(date_time >= as.POSIXct(format(Sys.Date() - 7, '%Y-%m-%d 00:00:00')) & 
           date_time < as.POSIXct(format(Sys.Date(), '%Y-%m-%d 00:00:00'))) %>% 
  mutate(date_time = paste(Sys.Date(), format(date_time, '%H:00:00'), ' ')) %>% 
  group_by(date_time) %>% 
  summarise(active_7days = mean(active, na.rm = FALSE), 
            new_7days = mean(new, na.rm = FALSE), 
            log_in_7days = mean(login, na.rm = FALSE))
hourly_login_7days$date_time <- as.POSIXct(hourly_login_7days$date_time)

hourly_login_30days <- hourly_login %>% 
  filter(date_time >= as.POSIXct(format(Sys.Date() - 30, '%Y-%m-%d 00:00:00')) & 
           date_time < as.POSIXct(format(Sys.Date(), '%Y-%m-%d 00:00:00'))) %>% 
  mutate(date_time = paste(Sys.Date(), format(date_time, '%H:00:00'), ' ')) %>% 
  group_by(date_time) %>% 
  summarise(active_30days = mean(active, na.rm = FALSE), 
            new_30days = mean(new, na.rm = FALSE), 
            log_in_30days = mean(login, na.rm = FALSE))
hourly_login_30days$date_time <- as.POSIXct(hourly_login_30days$date_time)

hourly_login_1day <- hourly_login %>% 
  filter(date_time >= as.POSIXct(format(Sys.Date() - 1, '%Y-%m-%d 00:00:00')) & 
           date_time < as.POSIXct(format(Sys.Date(), '%Y-%m-%d 00:00:00'))) %>% 
  mutate(date_time = paste(Sys.Date(), format(date_time, '%H:00:00'), ' ')) %>%
  rename(active_1day = active, new_1day = new, log_in_1day = login)
hourly_login_1day$date_time <- as.POSIXct(hourly_login_1day$date_time)

# =============================================================================

wk <- data.frame(first_weekday = seq(from = min(weekly_login$first_weekday),
                                     to = max((Sys.Date() - 7), min(weekly_login$first_weekday)),
                                     by = 'week')) %>% 
    mutate(year_week = paste0(format(first_weekday, '%Y'), '-', format(first_weekday, '%V')))
weekly_login <- left_join(wk, weekly_login, c('first_weekday', 'year_week')) %>% 
    mutate(retention = round(retention / NEW, 3)) %>%
    select(date_time = first_weekday, year_week, new = NEW, active, login, retention)
weekly_login[is.na(weekly_login)] <- 0

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

rm(dt, hr, wk, mt)
#==============================================================================
# user_location <- na.omit(user_location)
# user_location$create_time <- as.Date(user_location$create_time)

app_start$timestamp <- app_start$time_stamp
app_start$time_stamp <- as.Date(app_start$time_stamp)
app_start$regist_time <- as.Date(app_start$regist_time)
app_start$user_id <- as.integer(app_start$user_id)





