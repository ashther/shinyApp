
output$demographic_age_plot <- renderPlotly({
  (ggplot(demographic_age_data(), aes(x = age)) +
     geom_density(stat = 'density', fill = "blue", alpha = 0.2) +
     xlab('年龄') +
     ggtitle(
       sprintf('图1：%s年龄分布（核密度曲线',
               ifelse(input$demographic_university_select == '不限',
                      '全体用户',
                      iconv(input$demographic_university_select,'utf-8', 'gbk')))
     )) %>%
    ggplotly()
})

output$demographic_gender_plot <- renderPlotly({
  plot_ly(demographic_gender_data(), 
          labels = gender, 
          values = n, 
          type = 'pie') %>% 
    layout(title = '图2：性别占比')
})

output$demographic_degree_plot <- renderPlotly({
  plot_ly(demographic_degree_data(), 
          labels = degree, 
          values = n, 
          type = 'pie') %>% 
    layout(title = '图3：学历占比')
})

output$test <- renderPrint({
  sprintf('图1：%s年龄分布（核密度曲线）',
          ifelse(input$demographic_university_select == '不限',
                 '全体用户',
                 input$demographic_university_select))
}) # print_to_test