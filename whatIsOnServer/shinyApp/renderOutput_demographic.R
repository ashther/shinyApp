
output$demographic_age_plot <- renderPlotly({
  if (is.null(demographic_age_data())) {
    return(NULL)
  } else {
    plot_ly(x = demographic_age_data()$x, 
            y = demographic_age_data()$y, 
            mode = 'lines', 
            fill = 'tozeroy') %>% 
      layout(title = sprintf('图1：%s年龄分布',
                             ifelse(input$demographic_university_select == '不限',
                                    '全体用户',
                                    input$demographic_university_select)), 
             xaxis = list(title = '年龄'), 
             yaxis = list(title = '概率密度'))
  }
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
          x = n, 
          y = university, 
          type = 'bar', 
          orientation = 'h') %>% 
    layout(title = '图4：用户所属院校TOP10', 
           xaxis = list(title = '用户数'), 
           yaxis = list(title = ''), 
           margin = list(l = 150))
})

