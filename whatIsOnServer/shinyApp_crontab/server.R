

shinyServer(function(input, output, session) {
  
  arg_schedule <- argParse(schedule_arg_path)
  arg_stone <- argParse(stone_arg_path)
  
  login_check <- reactiveValues(logged = logged)
  
  source('login.R', encoding = 'utf-8', local = TRUE)
  
  observe({
    if (login_check$logged == TRUE) {
      source('renderUI.R', local = TRUE)
      source('renderOutput.R', local = TRUE)
    }
  })
})