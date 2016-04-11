
library(shiny)
library(shinydashboard)

source('dataSource.R')

ui <- dashboardPage(
  skin = 'black', 
  
  dashboardHeader(title = 'Basic dashboard'), 
  
  dashboardSidebar(
    sidebarSearchForm(textId = 'searchText', buttonId = 'searchButton', 
                      label = 'search....'), 
    # sidebarMenuOutput('menu')
    sidebarMenu(
      menuItem('Dashboard', tabName = 'dashboard', icon = icon('dashboard')),
      menuItem('Widgets', tabName = 'widgets', icon = icon('th'))
      # menuItem('Source code', tabName = 'source', icon = icon('file-code-o'),
      #          href = 'https://github.com/rstudio/shinydashboard/')
    )
  ),
  
  dashboardBody(
    # tabItems(
    #   tabItem(tabName = 'test', 
    #           h2('it is a test'))
    # )
    tabItems(

      tabItem(tabName = 'dashboard',
              fluidRow(
                column(width = 12, 
                       box(plotOutput('plot1'), width = NULL, solidHeader = TRUE),
                       
                       box(title = 'Controls', width = NULL, solidHeader = TRUE, 
                           sliderInput('slider', 'Number of observations: ', 1, 100, 50)))
              )),

      tabItem(tabName = 'widgets',
              h2('Widgets tab content'))

    )
  )
)

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)

  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  # output$menu <- renderMenu({
  #   sidebarMenu(
  #     menuItem('Menu Item', tabName = 'test', icon = icon('calendar'))
  #   )
  # })
}

shinyApp(ui, server)