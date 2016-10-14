
library(RMySQL)
library(dplyr)
library(magrittr)
library(digest)
library(plotly)
library(shinyStore)
library(shinythemes)
logged <- FALSE

schedule_arg_path <- "/home/r/recommend/schedule/parameters.cnf"
stone_arg_path <- "/home/r/recommend/stone/parameters.cnf"
crontab_bak_path <- "/home/r/temp/crontab.bak"

# =============================== function ===============================

simplePlot <- function(df, x, y) {
  plot_ly(df, 
          x = as.formula(paste0('~', x)), 
          y = as.formula(paste0('~', y)), 
          type = 'bar', 
          hoverinfo = 'text', 
          text = paste0(df[[y]], '<br>', df[[x]])) %>% 
    layout(xaxis = list(title = '', 
                        showticklabels = FALSE, 
                        zeroline = FALSE), 
           yaxis = list(title = y, 
                        range = c(0.8 * min(df[[y]]), 
                                  1.2 * max(df[[y]]))))
}

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

argParse <- function(file_path) {
  result <- readLines(file_path) %>% 
    grep('^$', ., value = TRUE, invert = TRUE) %>% 
    sapply(strsplit, split = ' <- ') %>% 
    do.call(rbind, .) %>% 
    as.data.frame(stringsAsFactors = FALSE, row.names = FALSE) %>% 
    set_colnames(c('arg', 'value'))
  
  return(result)
}

# df is dataframe with arg, value
argWrite <- function(df, file_path) {
  con <- file(file_path)
  paste(df$arg, df$value, sep = ' <- ') %>% 
    writeLines(con)
  close(con)
  return(0)
}

cronGet <- function() {
  system("sudo -S crontab -u r -l", input = '123456', intern = TRUE)
}

cronParse <- function(crontab, pattern) {
  if (length(crontab) == 0) {
    return(list(id_crontab = NULL, time = NULL, command = NULL))
  }
  
  id_crontab <- which(grepl(pattern, crontab))
  sep_position <- '*\\s*\\s*\\s*\\s*\\s' %>% 
    gregexpr(crontab[id_crontab]) %>% 
    unlist(use.names = FALSE) %>% 
    extract(5)
  time <- substr(crontab[id_crontab], 1, sep_position - 1) %>% 
    strsplit(' ') %>% 
    unlist(use.names = FALSE)
  command <- substr(crontab[id_crontab], sep_position + 1, nchar(crontab[id_crontab]))

  return(list(id_crontab = id_crontab, 
              time = time, 
              command = command))
}

# df is list with id_crontab, time, command
cronWrite <- function(df, crontab, file_path) {
  crontab[df$id_crontab] <- paste(df$time, collapse = ' ') %>% 
    paste(df$command, sep = ' ')
  con <- file(file_path)
  writeLines(crontab, con)
  close(con)
  
  result <- system(sprintf("sudo -S crontab -u r %s", 
                           file_path), 
                   input = '123456', 
                   ignore.stdout = TRUE, 
                   ignore.stderr = TRUE)
  return(result)
}

# status: 0 = success, 1 = failed, -1 = start
myMessage <- function(status) {
  renderText({
    if (status == 0) {
      sprintf("<font color=\'#FF0000\'><b> 已修改，修改时间：%s </b></font>", Sys.time())
    } else {
      sprintf("<font color=\'#FF0000\'><b> 修改失败 %s </b></font>", Sys.time())
    }
  })
}

# =============================== fetch data ===============================

con <- dbConnect(MySQL(), host = '10.21.3.101', port = 3306, 
                 username = 'r', password = '123456', 
                 dbname = 'shiny_data')

user_passwd <- simpleQuery(con, "select username as user, password as passwd, module
                     from shiny_data.shiny_user;")
rec_log <- simpleQuery(
  con, 
  "SELECT table_name,
       recommend_n,
       user_n,
       item_n,
       start_time,
       update_time
  FROM system_push_inspection.rec_log
  WHERE start_time >= DATE_SUB(NOW(), INTERVAL 30 DAY)"
)
dbDisconnect(con)
rec_log <- mutate(rec_log, start_date = as.Date(start_time, '%Y-%m-%d'))
rec_log_plot <- rec_log %>% 
  group_by(table_name, start_date) %>% 
  summarise(recommend_n = mean(recommend_n, na.rm = TRUE), 
            user_n = mean(user_n, na.rm = TRUE), 
            item_n = mean(item_n, na.rm = TRUE), 
            update_time = mean(as.numeric(update_time), na.rm = TRUE))

# =============================== fetch log ===============================

log_schedule <- system("tail /home/r/recommend/schedule/schedule.log", intern = TRUE)
log_stone <- system("tail /home/r/recommend/stone/stone.log", intern = TRUE)


