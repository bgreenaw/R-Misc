# ui.R

amish <- read.csv('data/amish.csv')


shinyUI(fluidPage(
  titlePanel("Amish Settlements in the US"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId="map_type", label = "Map Type:", choices=list("By GeoPoint"=1, "By County"=2), selected=1),
      
      sliderInput(inputId="year", label="Year Founded:", min = min(amish$YearFounded), 
                  max = max(amish$YearFounded),
                  value=min(amish$YearFounded), step = 1, 
                  format='####',
                  animate=animationOptions(interval=200, loop=FALSE)
      )
    ),
    
    mainPanel(plotOutput("map"))
  )
))
