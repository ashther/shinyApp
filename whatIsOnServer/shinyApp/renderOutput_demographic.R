
output$demographic_age_plot <- renderPlotly({
  (ggplot(demographic_age_data(), aes(x = age)) +
     geom_density(stat = 'density', fill = "blue", alpha = 0.2) +
     xlab('年龄') +
     ggtitle(
       sprintf('图1：%s年龄分布（核密度曲线）',
               ifelse(input$demographic_university_select == '不限',
                      '全体用户',
                      input$demographic_university_select))
     )) %>%
    ggplotly()
})

output$demographic_gender_plot <- renderPlotly({
  plot_ly(demographic_gender_data(), 
          labels = gender, 
          values = n, 
          type = 'pie') %>% 
    layout(title = 
             sprintf('图2：%s性别占比',
                     ifelse(input$demographic_university_select == '不限',
                            '全体用户',
                            input$demographic_university_select)))
})

output$demographic_degree_plot <- renderPlotly({
  plot_ly(demographic_degree_data(), 
          labels = degree, 
          values = n, 
          type = 'pie') %>% 
    layout(title = 
             sprintf('图3：%s受教育程度占比',
                     ifelse(input$demographic_university_select == '不限',
                            '全体用户',
                            input$demographic_university_select)))
})

output$demographic_university_top10 <- renderPlotly({
  plot_ly(demographic_university_top10(), 
          x = university, 
          y = n, 
          type = 'bar') %>% 
    layout(title = '图4：用户所属院校TOP10', 
           xaxis = list(title = '', 
                        size = 10))
})

# output$test <- renderPrint({
#   sprintf('%s, %s',input$demographic_dateRange_2[1], input$demographic_dateRange_2[2])
# }) # print_to_test