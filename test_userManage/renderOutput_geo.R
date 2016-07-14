
# 登录地图输出
output$app_start <- renderLeaflet({
  
  app_start_data() %>% 
    leaflet() %>% 
    addTiles(urlTemplate = 'http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png') %>% 
    addCircleMarkers(lng = app_start_data()$lon,
                     lat = app_start_data()$lat, 
                     # radius = app_start_temp$n, 
                     fillOpacity = 0.4,  #when user scale get larger use stroke = FALSE & fillOpacity = 0.35
                     popup = sprintf('%s: %s', 
                                     app_start_data()$user_id, 
                                     app_start_data()$time_stamp), 
                     clusterOptions = markerClusterOptions()) %>% 
    setView(lng = mean(city_location$lng[city_location$city == input$app_start_city]),
            lat = mean(city_location$lat[city_location$city == input$app_start_city]),
            zoom = 12)
})

# try https://github.com/rstudio/DT)
output$app_start_top10 <- renderTable({
  app_start_top10()
})