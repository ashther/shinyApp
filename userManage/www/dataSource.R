
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
