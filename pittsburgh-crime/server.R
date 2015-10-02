library(foreign)
library(maptools)
library(sp)
library(Hmisc)
library(ggvis)
source('functions.R')


##### Reading in Data Files

#pitt_beat0 <- read.csv('data/StatisticalDataFile/PghCarBeat.csv')
pitt_beat1 <- read.csv('data/StatisticalDataFile/PghCarBeat_by_year.csv')
pittshp0 <- readShapeSpatial('data/GIS/Pittsburgh/Maps/beat.shp')
#pittshp1 <- readShapeSpatial('data/GIS/Pittsburgh/Maps/city.shp')
crime0 <- read.csv('data/StatisticalDataFile/crimes.csv', stringsAsFactors = FALSE)
label_points = coordinates(pittshp0)

###### Subsetting Data: Not being used wrote back to a CSV file
# Summing data by year
#col_names <- c("BEAT", "YEAR", "VCI", "P1V", "P1P", "AGGASS", "MURDMANS", "RAPE", 'DRUGS', "WEAPONS", 'BURGLARY', "MVTHEFT", 'FAMVIOL', 'ROBBERY')
#require(plyr)
#pitt_beat1 <- ddply(pitt_beat0, c("BEAT", "YEAR"), function(x) colSums(x[c("VCI", "P1V", "P1P", "AGGASS", "MURDMANS", "RAPE", 'DRUGS', "WEAPONS", 'BURGLARY', "MVTHEFT", 'FAMVIOL', 'ROBBERY')]))

###### Shiny Server Section
shinyServer(function(input, output) {
  output$map1 <- renderPlot({
    
    sel_crime <- crime0[ crime0$crime_name == input$crime, 'crime'] # getting Column name from dropdown selction
    
    # Getting Base and Current Data for plot
    pitt_beat_base <- pitt_beat1[pitt_beat1$YEAR == 1990, c('BEAT', sel_crime)]
    pitt_beat_current <- pitt_beat1[pitt_beat1$YEAR == input$year, c('BEAT', sel_crime)]
    
    
    chg <- change(pitt_beat_base, pitt_beat_current) # getting positive or negative change values
    
    if (input$fade == "On"){
      chg[,2] <- sapply(chg[,2], inc_dec_fade) # Assigning  Colors to neg or pos values and fading the color by percent.
    }
    else if (input$fade == "Off"){
      chg[,2] <- sapply(chg[,2], inc_dec) # Assigning  Colors to neg or pos values
    }
    
    pittshp0@data = merge(pittshp0@data, chg, by = "BEAT", sort = F) # and colors to shp data in the correct order
    
    #plotting shp file with colors, Add legend, Beat text, and title
    par(mar=rep(.7,4))
    plot(pittshp0, col=pittshp0@data[,4], border = "grey90") #bty = "n", lty = 0) 
    layout(1)
    title(main=paste0('Crime Comparison by Police Beats between 1990 and ', input$year), font.main=4) 
    legend("bottomleft",legend=c("Crime Increase","Crime Decrease", "No Change"), fill=c('#832424FF', "#3A3A98FF", 'grey85'), bty = "n") 
    beat_txt <- as.character(pittshp0@data$BEAT, sort = F)
    beat_txt[beat_txt=="43"] <- "     43" #Addjusting for text off map
    text(labels = beat_txt, x = label_points[,1], y = label_points[,2], cex = .8, col= "gold")
  })
   
#displaying ggvis plot on right side of shiny 
  vis <- reactive({
    sel_crime <- crime0[ crime0$crime_name == input$crime, 'crime']
    cur_year_data <- pitt_beat1[pitt_beat1$YEAR <= input$year, c("BEAT", "YEAR", "VCI", "P1V", "P1P", "AGGASS", "MURDMANS", "RAPE", 'DRUGS', "WEAPONS", 'BURGLARY', "MVTHEFT", 'FAMVIOL', 'ROBBERY')]
    
    cur_year_data %>% ggvis(~YEAR, ~get(sel_crime)) %>%
      add_axis("y", title = input$crime, title_offset = 40) %>%
      add_axis("x", ticks=5, format="04d", grid=F, offset=10, subdivide = 1) %>%
      layer_points(size := 0) %>%
      group_by(BEAT) %>%
      add_tooltip(function(data){paste0("Beat: ", data$BEAT)}, "hover") %>%
      layer_paths(stroke.hover := "red", strokeWidth.hover := 4, strokeWidth := 1, opacity := 0.5)
      
  })
  vis %>%  bind_shiny("map2") #, "map2_ui")
    
})
