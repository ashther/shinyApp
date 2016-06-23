
output$demographic_age_plot <- renderPlot({
    ggplot(demographic_age_data(), aes(x = age)) +
        geom_density(stat = 'density', fill = "blue", alpha = 0.2) +
        xlab('age')
})

output$demographic_gender_plot <- renderPlot({
    ggplot(demographic_gender_data(),
           aes(x = '', y = n, fill = gender)) +
        geom_bar(stat = 'identity', width = 1) +
        coord_polar(theta = 'y') +
        scale_fill_brewer(palette = 'Blues') +
        theme_minimal()
})

output$demographic_degree_plot <- renderPlot({
    ggplot(demographic_degree_data(),
           aes(x = '', y = n, fill = degree)) +
        geom_bar(stat = 'identity', width = 1) +
        coord_polar(theta = 'y') +
        scale_fill_brewer(palette = 'Blues') +
        theme_minimal()
})