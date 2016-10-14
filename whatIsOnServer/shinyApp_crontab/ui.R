

shinyUI(fluidPage(theme = shinytheme('lumen'), 
  
  initStore('store', 'shinyApp_download'), 
  
  div(class = "login",
      uiOutput("uiLogin"),
      textOutput("pass")
  ),
  
  uiOutput('sidebarPanel'),
  
  mainPanel(
    uiOutput('mainPanel')
  )
  
))