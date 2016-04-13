
library(shiny)
library(shinydashboard)
library(ggplot2)

source('dataSource.R')

ui <- dashboardPage(
  skin = 'black', 
  
  dashboardHeader(title = 'data analysis'), 
  
  dashboardSidebar(

    sidebarMenu(
      menuItem('Point', tabName = 'point', icon = icon('th')), 
      menuItem('Login', tabName = 'login', icon = icon('dashboard')),
      menuItem('Quick_chat', tabName = 'quick_chat', icon = icon('th'))
    )
  ),
  
  dashboardBody(
      
    tabItems(
      tabItem(
          tabName = 'point', 
          fluidRow(
              valueBoxOutput('total_user'), 
              valueBoxOutput('new_user_today'), 
              valueBoxOutput('active_user_today')
          )  
      ), 

      tabItem(
          tabName = 'login',
           
          fluidRow(
            box(plotOutput('plot1'), width = 7, solidHeader = TRUE)  
          )
      ),

      tabItem(
          tabName = 'quick_chat',
          h2('quick_chat')
      )
    )
  )
)

server <- function(input, output) {
    output$total_user <- renderValueBox({
        valueBox(point_data$value[point_data$item == 'total_user'], 'total user')
    })
    
    output$new_user_today <- renderValueBox({
        valueBox(daily_login$new[daily_login$date_time == (Sys.Date() - 1)], 'new user')
    })
    
    output$active_user_today <- renderValueBox({
        valueBox(daily_login$active[daily_login$date_time == (Sys.Date() - 1)], 'active user')
    })
    
    output$plot1 <- renderPlot({
        ggplot(daily_login, aes(date_time, new)) + geom_bar(stat = 'identity')
    })
}

shinyApp(ui, server)