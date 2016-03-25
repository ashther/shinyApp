
shinyUI(fluidPage(
    titlePanel('日新增用户'), 
    
    sidebarLayout(
        
        sidebarPanel(
            sliderInput('days', '时间范围：', min = 3, max = 90, value = 7)
        ), 
        
        mainPanel(
            plotOutput('daily_new')
        )
    )
))