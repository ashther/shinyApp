

shinyUI(fluidPage(
  
  initStore('store', 'shinyApp_download'), 
  
  div(class = "login",
      uiOutput("uiLogin"),
      textOutput("pass")
  ),
  
  uiOutput('ui')
))