con <- dbConnect(MySQL(), host = host, port = port, 
                 username = username, password = password, 
                 dbname = dbname)

log_data <- reactive({
  return(c(input$user_name, 
           session$clientData$url_hostname, 
           session$clientData$url_pathname, 
           session$clientData$url_port, 
           session$clientData$url_search))
})

dbSendQuery(
  con,
  paste0(
    "insert into shiny_data.shiny_server_log (username, hostname, pathname, port, search) values ",
    sprintf("('%s', '%s', '%s', '%s', '%s')", 
            log_data()[1], log_data()[2], log_data()[3], log_data()[4], log_data()[5])
  )
)

dbDisconnect(con)
rm(con)