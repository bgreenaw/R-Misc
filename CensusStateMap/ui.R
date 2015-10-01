#ui.R

states <- read.csv('data/states.csv', stringsAsFactors = F)

shinyUI(fluidPage(
  titlePanel("Percentage of Race in US States"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId="state", label = "Choose a State:", choices=states[,2], selected=states[1,2]),
      selectInput(inputId="demo", label = "Choose a Race:", choices=c('Percent Asian', 'Percent Black', 'Percent Hispanic', 'Percent White', 'Percent Native American', 'Percent Multiracial'), selected='Asian')
      
      ),
    
    mainPanel(plotOutput("map"))
  )
))