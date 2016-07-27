
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

city_location <- read.csv('city_location.csv', stringsAsFactors = FALSE, 
                          row.names = NULL, fileEncoding = 'utf-8')
city_with_quote <- paste0('\'', city_location$city, '\'')
province_with_quote <- paste0('\'', unique(city_location$province), '\'')

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
# sell_price$type <- iconv(sell_price$type, 'gbk', 'utf8')

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
# buy_price$type <- iconv(buy_price$type, 'gbk', 'utf8')

dbDisconnect(con)

rm(con, res)


# =============================================================================

daily_trade$date_time <- as.Date(daily_trade$date_time)
hourly_trade$date_time <- strptime(hourly_trade$date_time, 
                                   format = '%Y-%m-%d-%H') %>% as.POSIXct()
weekly_trade$first_weekday <- as.Date(weekly_trade$first_weekday)
monthly_trade$first_monthday <- strptime(paste0(monthly_trade$year_month_id, '-01'), 
                                         format = '%Y-%m-%d') %>% as.Date()

# =============================================================================

dt <- data.frame(date_time = seq(from = min(daily_trade$date_time),
                                 to = Sys.Date() - 1, 
                                 by = 'day'))

daily_trade <- left_join(dt, daily_trade, by = 'date_time') %>% 
    select(date_time, new_sell_info, new_buy_info, active_seller, active_buyer, 
           active_trader)
daily_trade[is.na(daily_trade)] <- 0

# =============================================================================

temp_hr <- as.POSIXlt(Sys.time())
temp_hr$hour <- temp_hr$hour - 1
hr <- data.frame(date_time = seq(from = min(hourly_trade$date_time), 
                                 to = as.POSIXct(format(temp_hr, '%Y-%m-%d %H:00:00')), 
                                 by = 'hour'))
rm(temp_hr)

hourly_trade <- left_join(hr, hourly_trade, by = 'date_time') %>% 
    select(date_time, new_sell_info, new_buy_info, active_seller, active_buyer, 
           active_trader)
hourly_trade[is.na(hourly_trade)] <- 0

# =============================================================================

wk <- data.frame(first_weekday = seq(from = min(weekly_trade$first_weekday),
                                     to = max((Sys.Date() - 7), min(weekly_trade$first_weekday)),
                                     by = 'week')) %>% 
    mutate(year_week = paste0(format(first_weekday, '%Y'), '-', format(first_weekday, '%V')))

weekly_trade <- left_join(wk, weekly_trade, c('first_weekday', 'year_week')) %>% 
    select(date_time = first_weekday, year_week, new_sell_info, new_buy_info, active_seller, active_buyer, 
           active_trader)
weekly_trade[is.na(weekly_trade)] <- 0

# =============================================================================

# temp_mt_to <- Sys.Date() - as.POSIXlt(Sys.Date())$mday - 1
mt <- data.frame(first_monthday = seq(from = min(monthly_trade$first_monthday), 
                                      to = Sys.Date(), 
                                      by = 'month')) %>% 
    mutate(year_month_id = paste0(format(first_monthday, '%Y'), '-', format(first_monthday, '%m')))


monthly_trade <- left_join(mt, monthly_trade, c('first_monthday', 'year_month_id')) %>% 
    select(date_time = first_monthday, year_month_id, new_sell_info, new_buy_info, active_seller, active_buyer, 
           active_trader)
monthly_trade[is.na(monthly_trade)] <- 0


rm(dt, hr, wk, mt)
#==============================================================================
user_location <- na.omit(user_location)
user_location$create_time <- as.Date(user_location$create_time)

# =============================================================================
sell_price$price <- as.numeric(sell_price$price)
buy_price$price <- as.numeric(buy_price$price)







