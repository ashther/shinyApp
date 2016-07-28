
library(shinydashboard)
library(dygraphs)
library(xts)
library(leaflet)
library(ggplot2)
library(plotly)

shinyUI(dashboardPage(
    skin = 'black', 
    
    dashboardHeader(
    	title = '数据分析'
    	), 
    
    dashboardSidebar(
        
    ),
    
    dashboardBody(
        
        p('目前外网数据同步更新出现问题，请稍后', 
          style = 'font-size:100%')
    )
))

test haha...