
# This is the user-interface definition of a Shiny web application.
shinyUI(fluidPage(
    headerPanel('this is a header'), 
    
    sidebarPanel(
        selectInput('variable', 'Variable: ', 
                    list('Cylinders' = 'cyl', 
                         'Transmission' = 'am', 
                         'Gears' = 'gear')), 
        checkboxInput('outliers', 'Show outliers', FALSE), 
        
        sliderInput('test_slider_input', 'Test_Slider', 
                    min = 0, max = 100, value = c(25, 75))
    ), 
    
    mainPanel(
        h3(textOutput('caption')), 
        
        plotOutput('mpgPlot'), 
        
        tableOutput('test_slider_output')
    )
))