
output$versionCode <- renderPlotly({
  temp <- count(channel_data(), version) %>% 
    arrange(n)
  plot_ly(temp, 
          x = n, 
          y = version, 
          type = 'bar', 
          orientation = 'h') %>% 
    layout(title = '统计期内各版本用户数', 
           xaxis = list(title = '用户数'), 
           yaxis = list(title = '版本号'), 
           magrin = list(l = 200))
})

output$channelplot <- renderPlotly({
  temp <- count(channel_data(), channel) %>% 
    arrange(n)
  plot_ly(temp,
          x = n,
          y = channel,
          type = 'bar', 
          orientation = 'h') %>%
    layout(title = '统计期内各渠道来源用户数',
           xaxis = list(title = '用户数'), 
           yaxis = list(title = '渠道'), 
           marin = list(l = 200))
})

output$channel_version_heatmap <- renderPlotly({
  # temp <- count(channel_data(), channel, version)
  # vals <- unique(scales::rescale(temp$n))
  # o <- order(vals, decreasing = FALSE)
  # cols <- scales::col_numeric("Blues", domain = NULL)(vals)
  # colz <- setNames(data.frame(vals[o], cols[o]), NULL)
  # plot_ly(as.data.frame(temp), 
  #         x = channel, 
  #         y = version,
  #         z = n, 
  #         type = 'heatmap', 
  #         colorscale = colz) %>% 
  #   layout(title = '统计期内各渠道及版本用户数情况', 
  #          xaxis = list(title = '渠道', 
  #                       size = 10), 
  #          yaxis = list(title = '版本号'))
  temp <- channel_data() %>% 
    count(channel, version) %>% 
    spread(key = version, value = n, fill = 0)
  
  plot_ly(x = temp$channel, 
          y = colnames(temp)[-1], 
          z = t(as.matrix(temp[, -1])), 
          colorscale = 'pairs', 
          colorbar = list(title = '用户数'), 
          type = 'heatmap') %>% 
    layout(title = '统计期内各渠道及版本用户数情况', 
           xaxis = list(title = '渠道'), 
           yaxis = list(title = '版本号'))
})