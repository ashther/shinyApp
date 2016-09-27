
output$versionCode <- renderPlotly({
  temp <- count(channel_data(), version) %>% 
    arrange(n)
  plot_ly(temp, 
          x = ~n, # plotly 4.5 
          y = ~version, # plotly 4.5
          type = 'bar', 
          orientation = 'h') %>% 
    layout(title = '统计期内各版本用户数', 
           xaxis = list(title = '用户数'), 
           yaxis = list(title = '版本号', type = 'category'), 
           margin = list(l = 200))
})

output$channelplot <- renderPlotly({
  temp <- count(channel_data(), channel) %>% 
    arrange(n)
  plot_ly(temp,
          x = ~n, # plotly 4.5
          y = ~channel, # plotly 4.5
          type = 'bar', 
          orientation = 'h') %>%
    layout(title = '统计期内各渠道来源用户数',
           xaxis = list(title = '用户数'), 
           yaxis = list(title = '渠道'), 
           margin = list(l = 200))
})

output$channel_version_heatmap <- renderPlotly({
  # plotly 4.5
  temp <- as.data.frame(count(channel_data(), channel, version))
  vals <- unique(scales::rescale(temp$n))
  o <- order(vals, decreasing = FALSE)
  cols <- scales::col_numeric("Blues", domain = NULL)(vals)
  colz <- setNames(data.frame(vals[o], cols[o]), NULL)
  
  plot_ly(temp, 
          x = ~channel, 
          y = ~version, 
          z = ~n, 
          type = 'heatmap', 
          colorscale = colz) %>% 
    layout(title = '统计期内各渠道及版本用户数情况', 
           xaxis = list(title = '渠道'), 
           yaxis = list(title = '版本号'))
})