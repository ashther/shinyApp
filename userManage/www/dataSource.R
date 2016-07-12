
dataGet <- function(sql) {
    eval(parse(file = '/srv/shiny-server/download/www/config.cnf'))
    
    con <- dbConnect(MySQL(), host = host, port = port, 
                     username = username, password = password, 
                     dbname = dbname)
    # dbSendQuery(con, 'set names gbk')
    
    res <- dbSendQuery(con, sql)
    result <- dbFetch(res, n = -1)
    while (dbMoreResults(con)) {
        dbNextResult(con)
    }
    dbClearResult(res)
    dbDisconnect(con)
    
    if ('id' %in% colnames(result)) {
        result$id <- as.integer(result$id)
    }

    # result <- sapply(result, function(x){iconv(x, from = 'utf-8', to = 'gbk')})
    
    return(result)
}

con <- dbConnect(MySQL(), host = '10.21.3.101', port = 3306, 
                 username = 'r', password = '123456', 
                 dbname = 'shiny_data')

res <- dbSendQuery(con, 'SELECT field, province as 省份, city as 城市 FROM shiny_data.mobile_info;')
mobile_info <- dbFetch(res, n = -1)
while (dbMoreResults(con)) {
  dbNextResult(con)
}
dbClearResult(res)
dbDisconnect(con)
rm(con, res)

