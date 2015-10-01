library(shiny)
library(RColorBrewer)
#library(classInt)  
library(maps)
library(scales)
library(UScensus2000blkgrp)



source('functions.R')

setwd('~/Documents/R/Census Map/')
states <- read.csv('data/states.csv', stringsAsFactors = F)
load_data()

shinyServer(function(input, output) {
  
  output$map <- renderPlot({
   
    
    state_selected = states[states$name == input$state, 'blkgrp']
    race_pct <- getPctRace(get(state_selected))
    pct_color <- set_color(race_pct)
    state <- tolower(input$state)
    
    
    race <- demo <- switch(input$demo, 
                           "Percent White" = 10,
                           "Percent Black" = 8,
                           "Percent Asian" = 7,
                           "Percent Hispanic" = 9,
                           "Percent Native American" = 11,
                           'Percent Multiracial' = 12)
    
    plot_state(get(state_selected), state, pct_color[,race])
    
  })
  
  #output$legend <- renderPlot({
  #  legend("topright",legend=c("Black","Hispanic or Other", "White", "Asian"),fill=brewer.pal(n=4, 'Set2'))
  #})
})
