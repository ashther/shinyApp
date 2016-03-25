
library(RMySQL)
library(dplyr)
library(ggplot2)

host <- '10.21.3.101'
port <- 3306
username <- 'r'
password <- '123456'
dbname <- 'daily'


con <- dbConnect(MySQL(), host = host, port = port, 
                 username = username, password = password, 
                 dbname = dbname)
dbSendQuery(con, 'set names gbk')

res <- dbSendQuery(con, 'select * from daily.login;')
daily <- dbFetch(res, n = -1)
daily$date_time <- as.Date(daily$date_time)
daily$time_stamp <- as.POSIXct(daily$time_stamp)

dbClearResult(res)
dbDisconnect(con)

dt <- data.frame(date_time = seq(from = as.Date('2016-01-01'), 
                                 to = Sys.Date() - 1, by = 1))

daily <- left_join(dt, daily, by = 'date_time') %>% 
    select(date_time, new, active, login, retention)
daily[is.na(daily)] <- 0

shinyServer(function(input, output) {
    output$daily_new <- renderPlot({
        # qplot(daily$date_time[(nrow(daily) - input$days):nrow(daily)], 
        #       daily$new[(nrow(daily) - input$days):nrow(daily)], 
        #       geom = 'bar', stat = 'identity')
        ggplot(daily[(nrow(daily) - input$days):nrow(daily), ], 
               aes(date_time, new)) + geom_bar(stat = 'identity')
    })
})