
hourly_trade_new_sell_info <- xts(hourly_trade$new_sell_info, order.by = hourly_trade$date_time)
names(hourly_trade_new_sell_info) <- 'new_sell_info'
hourly_trade_new_buy_info <- xts(hourly_trade$new_buy_info, order.by = hourly_trade$date_time)
names(hourly_trade_new_buy_info) <- 'new_buy_info'
hourly_trade_active_seller <- xts(hourly_trade$active_seller, order.by = hourly_trade$date_time)
names(hourly_trade_active_seller) <- 'active_seller'
hourly_trade_active_buyer <- xts(hourly_trade$active_buyer, order.by = hourly_trade$date_time)
names(hourly_trade_active_buyer) <- 'active_buyer'
hourly_trade_active_trader <- xts(hourly_trade$active_trader, order.by = hourly_trade$date_time)
names(hourly_trade_active_trader) <- 'active_trader'

daily_trade_new_sell_info <- xts(daily_trade$new_sell_info, order.by = daily_trade$date_time)
names(daily_trade_new_sell_info) <- 'new_sell_info'
daily_trade_new_buy_info <- xts(daily_trade$new_buy_info, order.by = daily_trade$date_time)
names(daily_trade_new_buy_info) <- 'new_buy_info'
daily_trade_active_seller <- xts(daily_trade$active_seller, order.by = daily_trade$date_time)
names(daily_trade_active_seller) <- 'active_seller'
daily_trade_active_buyer <- xts(daily_trade$active_buyer, order.by = daily_trade$date_time)
names(daily_trade_active_buyer) <- 'active_buyer'
daily_trade_active_trader <- xts(daily_trade$active_trader, order.by = daily_trade$date_time)
names(daily_trade_active_trader) <- 'active_trader'

weekly_trade_new_sell_info <- xts(weekly_trade$new_sell_info, order.by = weekly_trade$date_time)
names(weekly_trade_new_sell_info) <- 'new_sell_info'
weekly_trade_new_buy_info <- xts(weekly_trade$new_buy_info, order.by = weekly_trade$date_time)
names(weekly_trade_new_buy_info) <- 'new_buy_info'
weekly_trade_active_seller <- xts(weekly_trade$active_seller, order.by = weekly_trade$date_time)
names(weekly_trade_active_seller) <- 'active_seller'
weekly_trade_active_buyer <- xts(weekly_trade$active_buyer, order.by = weekly_trade$date_time)
names(weekly_trade_active_buyer) <- 'active_buyer'
weekly_trade_active_trader <- xts(weekly_trade$active_trader, order.by = weekly_trade$date_time)
names(weekly_trade_active_trader) <- 'active_trader'

monthly_trade_new_sell_info <- xts(monthly_trade$new_sell_info, order.by = monthly_trade$date_time)
names(monthly_trade_new_sell_info) <- 'new_sell_info'
monthly_trade_new_buy_info <- xts(monthly_trade$new_buy_info, order.by = monthly_trade$date_time)
names(monthly_trade_new_buy_info) <- 'new_buy_info'
monthly_trade_active_seller <- xts(monthly_trade$active_seller, order.by = monthly_trade$date_time)
names(monthly_trade_active_seller) <- 'active_seller'
monthly_trade_active_buyer <- xts(monthly_trade$active_buyer, order.by = monthly_trade$date_time)
names(monthly_trade_active_buyer) <- 'active_buyer'
monthly_trade_active_trader <- xts(monthly_trade$active_trader, order.by = monthly_trade$date_time)
names(monthly_trade_active_trader) <- 'active_trader'








