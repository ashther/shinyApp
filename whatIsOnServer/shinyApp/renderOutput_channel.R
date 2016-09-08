
output$channel <- renderPlotly({
  temp <- count(channel_data(), channel)
  
  plot_ly(temp, 
          x = channel, 
          y = n, 
          type = 'bar') %>% 
    layout(title = '统计期内各渠道来源用户数', 
           xaxis = list(title = '渠道', 
                        size = 10))
})

output$versionCode <- renderPlotly({
  temp <- count(channel_data(), version)
  plot_ly(temp, 
          x = version, 
          y = n, 
          type = 'bar') %>% 
    layout(title = '统计期内各版本用户数', 
           xaxis = list(title = '版本号', 
                        size = 10))
})

output$channel_version_heatmap <- renderPlotly({
  temp <- count(channel_data(), channel, version)
  vals <- unique(scales::rescale(temp$n))
  o <- order(vals, decreasing = FALSE)
  cols <- scales::col_numeric("Blues", domain = NULL)(vals)
  colz <- setNames(data.frame(vals[o], cols[o]), NULL)
  plot_ly(temp, 
          x = channel, 
          y = version,
          z = n, 
          type = 'heatmap', 
          colorscale = colz) %>% 
    layout(title = '统计期内各渠道及版本用户数情况', 
           xaxis = list(title = '渠道', 
                        size = 10), 
           yaxis = list(title = '版本号'))
})

