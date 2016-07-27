
con <- dbConnect(MySQL(), host = host, port = port, 
                 username = username, password = password, 
                 dbname = dbname)
# dbSendQuery(con, 'set names gbk')

# 刷新point_data
point_data <- pointRefresh(Sys.time(), point_data, con)
# 刷新hourly_login
hourly_train <- hourlyDataRefresh(Sys.time(), hourly_train, con)

dbDisconnect(con)
rm(con)

