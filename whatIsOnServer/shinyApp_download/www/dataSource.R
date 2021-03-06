dataSource_filename <- paste0('dataSource_', format(Sys.Date(), '%Y%m%d'), '.rda')

if (!file.exists(dataSource_filename)) {
  
  eval(parse(file = '/srv/shiny-server/download/www/config.cnf'))
  
  con <- dbConnect(MySQL(), host = '10.21.3.101', port = 3306, 
                   username = 'r', password = '123456', 
                   dbname = 'shiny_data')
  
  res <- dbSendQuery(con, 
                     "SELECT field, 
                     province AS '省份', 
                     city     AS '城市' 
                     FROM   shiny_data.mobile_info;")
  mobile_info <- dbFetch(res, n = -1)
  while (dbMoreResults(con)) {
    dbNextResult(con)
  }
  dbClearResult(res)
  
  res <- dbSendQuery(con, 
                     "SELECT username AS user, 
                     password AS passwd, module 
                     FROM   shiny_data.shiny_user;")
  user_passwd <- dbFetch(res, n = -1)
  while (dbMoreResults(con)) {
    dbNextResult(con)
  }
  dbClearResult(res)
  
  dbDisconnect(con)
  rm(con, res)
  
  dataGet <- function(maxTimeStamp, host, port, username, password, dbname, mobile_info) {
    con_app <- dbConnect(MySQL(), host = host, port = port, 
                         username = username, password = password, 
                         dbname = dbname)
    
    res <- dbSendQuery(con_app, 
                       paste0(
                         "SELECT a.id, 
                         b.full_name AS '用户名', 
                         a.username  AS '手机号' , 
                         a.regist_time AS '注册时间'
                         FROM   yz_sys_db.ps_account AS a 
                         LEFT JOIN yz_app_person_db.ps_attribute AS b 
                         ON a.id = b.account_id 
                         AND b.del_status = 0 
                         WHERE  a.id >= 20000 
                         AND a.del_status = 0 
                         AND a.username NOT LIKE '913%' 
                         AND a.regist_time > ",
                         sprintf("'%s' ", maxTimeStamp), 
                         "AND b.full_name IS NOT NULL 
                         ORDER  BY a.id DESC;"
                       ))
    users <- dbFetch(res, n = -1)
    while (dbMoreResults(con_app)) {
      dbNextResult(con_app)
    }
    dbClearResult(res)
    dbDisconnect(con_app)
    rm(con_app)
    
    con <- dbConnect(MySQL(), host = '10.21.3.101', port = 3306, 
                     username = 'r', password = '123456', 
                     dbname = 'shiny_data')
    
    res <- dbSendQuery(con, 
                       paste0(
                         "SELECT a.id, 
                         b.position_1name AS '单位/学校', 
                         c.app_channel_id AS '渠道' 
                         FROM   yz_sys_db.ps_account AS a 
                         LEFT JOIN (SELECT account_id, 
                         position_1name 
                         FROM   (SELECT account_id, 
                         position_1name 
                         FROM   yz_app_person_db.ps_vitae_main 
                         WHERE  del_status = 0 
                         ORDER  BY status_time DESC) AS ps_vitae_main_temp 
                         GROUP  BY account_id) AS b 
                         ON a.id = b.account_id 
                         LEFT JOIN (SELECT user_id, 
                         CASE app_channel_id 
                         WHEN 'A001' THEN '360' 
                         WHEN 'A002' THEN '百度' 
                         WHEN 'A003' THEN '腾讯' 
                         WHEN 'A004' THEN '豌豆荚' 
                         WHEN 'A005' THEN '小米' 
                         WHEN 'A006' THEN 'oppo' 
                         WHEN 'A007' THEN '魅族' 
                         WHEN 'A008' THEN '华为' 
                         WHEN 'A009' THEN '其他' 
                         WHEN 'A010' THEN '搜狗'
                         WHEN 'A011' THEN '联想'
                         WHEN 'A012' THEN 'vivo'
                         WHEN 'A013' THEN '三星'
                         WHEN 'A014' THEN 'pp助手'
                         WHEN 'appstore' THEN '苹果' 
                         ELSE app_channel_id 
                         END AS app_channel_id 
                         FROM   (SELECT user_id, 
                         app_channel_id 
                         FROM   yz_app_track_db.app_start 
                         WHERE  del_status = 0 
                         AND app_channel_id IS NOT NULL 
                         ORDER  BY create_time DESC) AS channel_temp 
                         GROUP  BY 1) AS c 
                         ON a.id = c.user_id 
                         WHERE  a.id >= 20000 
                         AND a.del_status = 0 
                         AND a.regist_time > ", 
                         sprintf("'%s';", maxTimeStamp)
                       ))
    registInfo <- dbFetch(res, n = -1)
    while (dbMoreResults(con)) {
      dbNextResult(con)
    }
    dbClearResult(res)
    
    dbDisconnect(con)
    rm(con, res)
    
    users$field <- floor(as.numeric(users$`手机号`)/10000)
    users %>% 
      left_join(registInfo, 'id') %>% 
      left_join(mobile_info, 'field') %>% 
      select(-field)
  }
  
  lastLoginGet <- function(users) {
    con <- dbConnect(MySQL(), host = '10.21.3.101', port = 3306, 
                     username = 'r', password = '123456', 
                     dbname = 'yz_sys_db')
    res <- dbSendQuery(con, 
                       "SELECT account_id, 
                     DATE_FORMAT(login_time, '%Y-%m-%d %H:%i:00') AS login_time 
                     FROM   (SELECT account_id, 
                     login_time 
                     FROM   yz_sys_db.ps_account_login_log 
                     ORDER  BY login_time DESC) AS login_temp
                     WHERE  account_id >= 20000
                     GROUP  BY account_id")
    last_login <- dbFetch(res, n = -1)
    while (dbMoreResults(con)) {
      dbNextResult(con)
    }
    dbClearResult(res)
    dbDisconnect(con)
    
    result <- left_join(users, last_login, c('id' = 'account_id')) %>% 
      select(id, `用户名`, `手机号`, `注册时间`, `最后登录时间` = login_time, 
             `单位/学校`, `渠道`, `省份`, `城市`)
    
    return(result)
  }
  
  users <- dataGet('2016-01-01', host, port, username, password, dbname, mobile_info) %>% 
    lastLoginGet()
  
  save(list = ls(), file = dataSource_filename)
} else {
  load(dataSource_filename)
}


































