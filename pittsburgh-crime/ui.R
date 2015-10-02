# ui.R

require(ggvis)

crime0 <- read.csv('data/StatisticalDataFile/crimes.csv', stringsAsFactors=F)

shinyUI(fluidPage(
  titlePanel("Pittsburgh Crime from 1990 - 2001"),
  wellPanel(
    fluidRow(
      column(3,
        selectInput(inputId="crime", label = "Crime:", choices=crime0$crime_name)
      ),
      column(3,
        radioButtons(inputId="fade", label = "Fade Beats by % change",choices = c('On', 'Off'),selected = "On" )
      ),
      column(3,
        sliderInput(inputId="year", label="Year:", min = 1991, 
                    max = 2001,
                    value=1991, step = 1, 
                    format='####',
                    animate=animationOptions(interval=1500, loop=FALSE))
      )
    )),
    fluidRow(
      column(6,
             plotOutput("map1")
             
      ),
      column(6,
             ggvisOutput("map2") #, uiOutput("map2_ui")
      )
    )
  )
)
