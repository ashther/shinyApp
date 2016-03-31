
shinyUI(fluidPage(
    titlePanel("My Shiny App"),
    sidebarLayout(
        sidebarPanel(
            strong(p('Installation', style = 'font-size:160%')),  
            p('Shiny is available on CRAN, so you can install it n the usual way from your R console:'), 
            code('install.packages("shiny")'), 
            br(), 
            br(), 
            br(),
            img(src = 'bigorb.png', height = 90.63, width = 100, align = 'middle'), 
            p('shiny is a product of ', span('RStudio', style = 'color:blue'))
        ),
        mainPanel(
            strong(p('Introducing Shiny', style = 'font-size:200%')), 
            p('Shiny is a new package from RStudio that makes it ', 
              em('incredibly easy'), 'to build interactive web applications with R.'), 
            br(), 
            br(), 
            p('For an introduction and live examples, visit the ', 
              a(href = 'www.rstudio.com', 'Shiny homepage.')), 
            br(), 
            br(),
            br(), 
            strong(p('Features', style = 'font-size:160%')), 
            
            tags$div(
                tags$ul(
                    tags$li('Build useful web applications with only a few lines of code - no JavaScript required.'), 
                    tags$li('Shiny applications are automatically \'live\' in the same way that ', 
                            strong('spreadsheets'), 
                            'are live. Outputs change instantly as users modify inputs, without requiring a reload the browser.')
                )
            ), 
            
            helpText('this is a help text.')
        )
    )
))