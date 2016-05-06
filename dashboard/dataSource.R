

library(RMySQL)
library(dplyr)
library(tidyr)

host <- '117.34.109.230'
port <- 33077
username <- 'thinkcoo'
password <- 'tko123456'
dbname <- 'yz_sys_db'

con <- dbConnect(MySQL(), host = host, port = port, 
                 username = username, password = password, 
                 dbname = dbname)
dbSendQuery(con, 'set names gbk')

totalUserCreate <- function(con) {
    res <- dbSendQuery(con, paste0('SELECT COUNT(*) ', 
                                   'FROM yz_sys_db.ps_account ',  
                                   'WHERE del_status = 0 ', 
                                   'AND id >= 20000;'))
    total_user <- dbFetch(res, n = -1)[1, 1]
    while (dbMoreResults(con)) {
        dbNextResult(con)
    }
    dbClearResult(res)
    return(total_user)
}

newUserCreate <- function(con) {
    res <- dbSendQuery(con, paste0('SELECT COUNT(*) ', 
                                   'FROM yz_sys_db.ps_account ', 
                                   'WHERE del_status = 0 ', 
                                   'AND id >= 20000 ', 
                                   'AND DATE(regist_time) = DATE(NOW());'))
    new_user_today <- dbFetch(res, n = -1)[1, 1]
    while (dbMoreResults(con)) {
        dbNextResult(con)
    }
    dbClearResult(res)
    return(new_user_today)
}

activeLoginCreate <- function(con) {
    res <- dbSendQuery(con, paste0('SELECT COUNT(DISTINCT account_id) AS active_user, ', 
                                   'COUNT(*) AS login_times ', 
                                   'FROM yz_sys_db.ps_account_login_log ', 
                                   'WHERE account_id >= 20000 ',  
                                   'AND DATE(login_time) = DATE(NOW());'))
    ar_login_temp <- dbFetch(res, n = -1)
    # active_user_today <- ar_login_temp[1, 1]
    # login_times_today <- ar_login_temp[1, 2]
    while (dbMoreResults(con)) {
        dbNextResult(con)
    }
    dbClearResult(res)
    return(ar_login_temp)
}

hourlyNewCreate <- function(con) {
    res <- dbSendQuery(con, paste0('SELECT DATE_FORMAT(regist_time, \'%Y-%m-%d %H:00:00\') AS t, ', 
                                   'COUNT(*) AS n ', 
                                   'FROM yz_sys_db.ps_account ', 
                                   'WHERE del_status = 0 ', 
                                   'AND id >= 20000 ', 
                                   'AND regist_time >= DATE_SUB(NOW(), INTERVAL 1 DAY) ', 
                                   'GROUP BY t;'))
    hourly_new <- dbFetch(res, n = -1)
    while (dbMoreResults(con)) {
        dbNextResult(con)
    }
    dbClearResult(res)
    
    hourly_new$t <- as.POSIXct(hourly_new$t)
    
    hr <- data.frame(t = seq(from = as.POSIXct(format(Sys.time() - 23*3600, '%Y-%m-%d %H:00:00')),
                             to = as.POSIXct(format(Sys.time(), '%Y-%m-%d %H:00:00')),
                             by = 'hour'))
    hourly_new <- left_join(hr, hourly_new, by = 't')
    hourly_new[is.na(hourly_new)] <- 0
    
    hourly_new_xts <- xts(hourly_new$n, order.by = hourly_new$t)
    names(hourly_new_xts) <- 'new'
    
    return(hourly_new_xts)
}

hourlyActiveLoginCreate <- function(con) {
    res <- dbSendQuery(con, paste0('SELECT DATE_FORMAT(login_time, \'%Y-%m-%d %H:00:00\') AS t, ', 
                                   'COUNT(DISTINCT account_id) AS active, ', 
                                   'COUNT(*) AS login_times ', 
                                   'FROM yz_sys_db.ps_account_login_log ', 
                                   'WHERE account_id >= 20000 ', 
                                   'AND login_time >= DATE_SUB(NOW(), INTERVAL 1 DAY) ', 
                                   'GROUP BY t;'))
    hourly_active_login <- dbFetch(res, n = -1)
    while (dbMoreResults(con)) {
        dbNextResult(con)
    }
    dbClearResult(res)
    
    hourly_active_login$t <- as.POSIXct(hourly_active_login$t)
    
    hr <- data.frame(t = seq(from = as.POSIXct(format(Sys.time() - 23*3600, '%Y-%m-%d %H:00:00')),
                             to = as.POSIXct(format(Sys.time(), '%Y-%m-%d %H:00:00')),
                             by = 'hour'))
    hourly_active_login <- left_join(hr, hourly_active_login, by = 't')
    hourly_active_login[is.na(hourly_active_login)] <- 0
    
    hourly_active_xts <- xts(hourly_active_login$active, order.by = hourly_active_login$t)
    names(hourly_active_xts) <- 'active'
    hourly_login_xts <- xts(hourly_active_login$login_times, order.by = hourly_active_login$t)
    names(hourly_login_xts) <- 'login'
    
    return(list(active = hourly_active_xts, login = hourly_login_xts))
}



rm(dbname, host, port, username, password)





