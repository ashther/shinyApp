
# 登录地图输出
output$app_start <- renderLeaflet({
  
  result <- app_start_data() %>% 
    leaflet() %>% 
    addTiles(urlTemplate = 'http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png') %>% 
    setView(lng = mean(city_location$lng[city_location$city == input$app_start_city]),
            lat = mean(city_location$lat[city_location$city == input$app_start_city]),
            zoom = 12)
  
  if (input$user_name == 'sunlj') {
    result <- result %>% 
      addCircleMarkers(lng = app_start_data()$lon,
                       lat = app_start_data()$lat, 
                       # radius = app_start_temp$n, 
                       fillOpacity = 0.4,  #when user scale get larger use stroke = FALSE & fillOpacity = 0.35
                       popup = sprintf('%s: %s',
                                       app_start_data()$user_id,
                                       app_start_data()$timestamp), 
                       clusterOptions = markerClusterOptions())
  } else {
    result <- result %>% 
      addCircleMarkers(lng = app_start_data()$lon,
                       lat = app_start_data()$lat, 
                       fillOpacity = 0.4,
                       clusterOptions = markerClusterOptions())
  }
  
  return(result)
})



output$specific_user_geo_ui <- renderUI({
  if (input$user_name == 'sunlj') {
    return(
      selectizeInput(
        'specific_user_geo', 
        'sepcificUserGeo', 
        choices = c('noSpecific', unique(app_start$user_id)), 
        selected = 'noSpecific'
      )
    )
  }
})

# try https://github.com/rstudio/DT)
output$topArea <- renderTable({
  app_start_topArea_data()
})

















