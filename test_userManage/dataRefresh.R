
con <- dbConnect(MySQL(), host = host, port = port, 
                 username = username, password = password, 
                 dbname = dbname)
# dbSendQuery(con, 'set names gbk')

# 刷新point_data
point_data <- pointRefresh(Sys.time(), point_data, con)
# 刷新hourly_login
hourly_login <- hourlyDataRefresh(Sys.time(), hourly_login, con)
hourly_calendar <- hourlyDataRefresh(Sys.time(), hourly_calendar, con)
hourly_cooperation <- hourlyDataRefresh(Sys.time(), hourly_cooperation, con)
hourly_hr <- hourlyDataRefresh(Sys.time(), hourly_hr, con)
hourly_quick_chat <- hourlyDataRefresh(Sys.time(), hourly_quick_chat, con)
hourly_schedule <- hourlyDataRefresh(Sys.time(), hourly_schedule, con)
hourly_trade <- hourlyDataRefresh(Sys.time(), hourly_trade, con)
hourly_train <- hourlyDataRefresh(Sys.time(), hourly_train, con)


dbDisconnect(con)
rm(con)
