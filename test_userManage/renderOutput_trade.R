
output$sell_info <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'sell_info'], 
             '出售商品数', 
             icon('mobile'), 
             'maroon')
})

output$seller <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'seller'], 
             '累计卖家数', 
             icon('users'), 
             'maroon')
})

output$purchase_info <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'purchase_info'], 
             '求购信息数', 
             icon('laptop'), 
             'maroon')
})

output$purchaser <- renderValueBox({
    valueBox(point_data$value[point_data$item == 'purchaser'], 
             '累计买家数', 
             icon('users'), 
             'maroon')
})

output$sell_median <- renderValueBox({
    valueBox(median(sell_price$price), 
             '出售价格价中位数（元）', 
             icon('rmb'), 
             'maroon')
})

output$sell_buy_total <- renderValueBox({
    sell_ratio <- round(sum(sell_price$price) / sum(sell_price$price, buy_price$price), 4) * 100
    buy_ratio <- 100 - sell_ratio
    
    valueBox(round(sum(sell_price$price, buy_price$price)/1e4, 2), 
             paste0('自贸区总规模（万元），出售商品占', 
                    sprintf('%s', sell_ratio), 
                    '%，求购商品占', 
                    sprintf('%s', buy_ratio), 
                    '%'),
             icon('rmb'), 
             'maroon')
})

output$buy_median <- renderValueBox({
    valueBox(median(buy_price$price), 
             '求购价格中位数（元）', 
             icon('rmb'), 
             'maroon')
})

output$trade_plot <- renderDygraph({
    dygraph(trade_data(), 
            main = sprintf('%s变化趋势',
                           switch(input$trade_data_type,
                                  'new_sell_info' = '新增出售商品数',
                                  'new_buy_info' = '新增求购信息数', 
                                  'active_seller' = '活跃卖家数', 
                                  'active_buyer' = '活跃买家数', 
                                  'active_trader' = '活跃用户数'))) %>% 
        dySeries(label = sprintf('%s',
                                 switch(input$trade_data_type,
                                        'new_sell_info' = '新增出售商品数',
                                        'new_buy_info' = '新增求购信息数', 
                                        'active_seller' = '活跃卖家数', 
                                        'active_buyer' = '活跃买家数', 
                                        'active_trader' = '活跃用户数'))) %>%
        dyOptions(fillGraph = TRUE, fillAlpha = 0.2, colors = 'maroon') %>% 
        dyLegend(show = 'follow', hideOnMouseOut = TRUE) %>% 
        dyRangeSelector(dateWindow = input$calendar_date_range)
})

output$trade_price <- renderPlotly({

    (ggplot(price_data(), aes(x = price, fill = type)) +
       geom_density(stat = 'density', alpha = 0.3) +
         # geom_histogram(alpha = 0.5, binwidth = input$price_binwidth, position = 'identity') +
         xlab('价格（元）') +
         ylab('商品信息数') +
     ggtitle(sprintf('%s分布', switch(input$price_type,
                                    'sell_price' = '出售价格',
                                    'buy_price' = '求购价格')))) %>%
        ggplotly()
})
# output$trade_price <- renderPlot({
# 
#     ggplot(price_data(), aes(x = price, fill = type)) +
#         geom_histogram(alpha = 0.5, binwidth = input$price_binwidth) +
#         xlab('price(yuan)') +
#         ggtitle(sprintf('%s', switch(input$price_type,
#                                      'sell_price' = 'sell price',
#                                      'buy_price' = 'purchase price')))
# })