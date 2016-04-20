
pointRefresh <- function(now, point_data, con) {
    
    if (difftime(now, max(point_data$time_stamp), units = 'hours') < 1) {
        return(point_data)
    }
    
    point_data <- dbSendQuery(con, 'select * from stat.point_data;') %>% 
        dbFetch(n = -1)
    
    return(point_data)
}

hourlyRefresh <- function(now, hourly_login, con) {
    if (difftime(now, max(hourly_login$date_time), units = 'hours') < 1.1) {
        return(hourly_login)
    }
    
    hourly_login_new <- dbSendQuery(
        con, 
        paste0(
            'select * from hourly.login where date_time > ', 
            sprintf('\'%s\'', format(max(hourly_login$date_time), '%Y-%m-%d-%H')), 
            ';'
        )
    ) %>% 
        dbFetch(n = -1)
    
    hourly_login_new$date_time <- strptime(hourly_login_new$date_time,
                                           format = '%Y-%m-%d-%H') %>% as.POSIXct()
    temp_hr <- as.POSIXlt(now)
    temp_hr$hour <- temp_hr$hour - 1
    hr <- data.frame(date_time = seq(from = max(hourly_login$date_time), 
                                     to = as.POSIXct(format(temp_hr, '%Y-%m-%d %H:00:00')), 
                                     by = 'hour'))
    
    hourly_login_new <- left_join(hr, hourly_login_new, by = 'date_time') %>% 
        select(date_time, new, active, login)
    hourly_login_new[is.na(hourly_login_new)] <- 0
    
    return(rbind(hourly_login, hourly_login_new[-1, ]))
}

weeklyRefresh <- function(now, weekly_login, con) {
    
}