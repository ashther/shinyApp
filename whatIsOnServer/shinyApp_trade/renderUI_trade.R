
output$trade_date_format_ui <- renderUI({
  selectInput('trade_date_format', 
              label = '选择统计周期', 
              choices = list('小时' = 'hourly', 
                             '日' = 'daily', 
                             '周' = 'weekly', 
                             '月' = 'monthly'), 
              selected = 'daily')
})

output$trade_data_type_ui <- renderUI({
  tags$div(title = paste0('新增出售/求购商品：统计期内被创建的出售/求购商品； ', 
                          '活跃卖家/买家：统计期内创建或修改过出售/求购商品信息的用户（去重）； ', 
                          '活跃用户数：统计期内创建或修改过商品信息的用户（去重）'), 
           selectInput('trade_data_type', 
                       label = '选择指标', 
                       choices = list('新增出售商品数' = 'new_sell_info',
                                      '新增求购信息数' = 'new_buy_info', 
                                      '活跃卖家数' = 'active_seller', 
                                      '活跃买家数' = 'active_buyer', 
                                      '活跃用户数' = 'active_trader'), 
                       selected = 'active_trader'))
})

output$trade_date_range_ui <- renderUI({
  dateRangeInput('trade_date_range', 
                 label = '选择统计区间', 
                 min = min(daily_trade$date_time), 
                 max = max(daily_trade$date_time), 
                 start = max(daily_trade$date_time) - 31, 
                 language = 'zh-CN')
})

output$help_text_ui_1 <- renderUI({
  p(helpText(paste0('注意：当统计周期为周/月时， ', 
                    '图的横坐标开始于所选周/月的第一天，表示当周/月，', 
                    '如统计周期为周时，2016-04-11表示4月11日-18日这一周， ', 
                    '而统计周期为月时，2016-04-01表示4月' )), 
    style = 'font-size:85%')
})

output$price_type_ui <- renderUI({
  selectInput('price_type', 
              '选择价格类别', 
              choices = list('出售价格' = 'sell_price', 
                             '求购价格' = 'buy_price'), 
              selected = 'sell_price')
})

output$price_category_ui <- renderUI({
  checkboxGroupInput('price_category',
                     '选择商品类别',
                     choices = list('图书/音像' = '图书/音像',
                                    '文体户外' = '文体户外',
                                    '生活用品' = '生活用品',
                                    '小家电' = '小家电',
                                    '电脑/配件' = '电脑/配件',
                                    '数码产品' = '数码产品',
                                    '手机' = '手机',
                                    '其它' = '其它'),
                     selected = '图书/音像')
})

output$price_outlier_ui <- renderUI({
  tags$div(title = paste0('一组数据的上下四分位数之间的距离为IQR， ', 
                          '通常将超过改组数据上下分位数1.5倍IQR的数据定为异常点'), 
           checkboxInput('price_outlier', 
                         '是否去除异常价格', 
                         value = TRUE))
})

# output$province_ui <- renderUI({
#   selectInput('province', 
#               '选择省级地区', 
#               choices = province_with_quote %>% 
#                 paste0(., '=', .) %>% 
#                 paste(collapse = ',') %>% 
#                 sprintf('list(%s)', .) %>% 
#                 parse(text = .) %>% 
#                 eval(), 
#               selected = '陕西省')
# })
# 
# output$city_ui <- renderUI({
#   selectInput('city', 
#               '选择市级地区', 
#               choices = list('西安市' = '西安市'), 
#               selected = '西安市')
# })
# 
# output$map_date_range_ui <- renderUI({
#   dateRangeInput('map_date_range', 
#                  label = '选择统计区间', 
#                  min = min(user_location$create_time), 
#                  max = max(user_location$create_time), 
#                  start = min(user_location$create_time), 
#                  language = 'zh-CN')
# })


























