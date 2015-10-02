#packes to be loaded for this shiny app
library(shiny)
library(leaflet)
library(maps)
library(maptools)
library(sp)
library(rgeos)
library(scales)

#load data and find Church district ranges
amish <- read.csv('data/amish.csv')

CD = amish$ChurchDistricts
amish$pointrange = (CD-min(CD))/(max(CD)-min(CD))*(1.5-.25) + .25
# create size for church population
amish$ri <- (CD-min(CD))/(max(CD)-min(CD))*(1.0-.15) + .15

shinyApp(
  ui <- bootstrapPage(
    tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
    leafletOutput("myMap", width = "100%", height = "100%"),
    absolutePanel(top = 10, right = 10,
                  sliderInput(inputId="year", label="Year Founded: ", 
                              min = min(amish$YearFounded), 
                              max = max(amish$YearFounded),
                              value=min(amish$YearFounded), 
                              step = 10, format='####',
                              animate=animationOptions(interval=800, loop=FALSE))
                  
    )
  ),
  
  
  server <- function(input, output, session) {
    output$myMap <- renderLeaflet({
      
      amishNow <- amish %.%
        filter(YearFounded <= input$year) %.%
        select(YearFounded, ChurchDistricts, city1Lon, city1Lat, pointrange, city1, PrimaryState)
      
      leaflet() %>%
        addTiles(urlTemplate = "http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png", 
                 attribution = '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>%
        addCircleMarkers(lng = amishNow$city1Lon, lat = amishNow$city1Lat, 
                         popup = paste0('<b>Location:</b> ', amishNow$city1, ", ", amishNow$PrimaryState),
                         color= 'red',
                         opacity=.5,
                         radius=amishNow$pointrange*9,
                         stroke = FALSE, 
                         fillOpacity = 0.5)
      
    })
  })