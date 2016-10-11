
library(RMySQL)
library(digest)
library(plotly)
library(shinyStore)
logged <- FALSE

simpleQuery <- function(con, sql_str) {
  require(RMySQL)
  res <- dbSendQuery(con, sql_str)
  result <- dbFetch(res, n = -1)
  while (dbMoreResults(con)) {
    dbNextResult(con)
  }
  dbClearResult(res)
  return(result)
}

con <- dbConnect(MySQL(), host = '10.21.3.101', port = 3306, 
                 username = 'r', password = '123456', 
                 dbname = 'shiny_data')
user_passwd <- simpleQuery(con, "select username as user, password as passwd, module
                     from shiny_data.shiny_user;")

on.exit(dbDisconnect(con))