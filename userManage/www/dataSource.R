
dataGet <- function(sql) {
    eval(parse(file = 'userManage/www/config.cnf'))
    
    con <- dbConnect(MySQL(), host = host, port = port, 
                     username = username, password = password, 
                     dbname = dbname)
    dbSendQuery(con, 'set names gbk')
    
    res <- dbSendQuery(con, sql)
    result <- dbFetch(res, n = -1)
    while (dbMoreResults(con)) {
        dbNextResult(con)
    }
    dbClearResult(res)
    dbDisconnect(con)
    
    return(result)
}