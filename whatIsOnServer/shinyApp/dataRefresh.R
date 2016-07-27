
con <- dbConnect(MySQL(), host = host, port = port, 
                 username = username, password = password, 
                 dbname = dbname)
# dbSendQuery(con, 'set names gbk')

# 刷新point_data
point_data <- pointRefresh(Sys.time(), point_data, con)
# 刷新hourly_login
hourly_login <- hourlyDataRefresh(Sys.time(), hourly_login, con)
# 刷新app_start
app_start <- appStartRefresh(Sys.time(), app_start, con)

dbDisconnect(con)
rm(con)

