library (UScensus2000)
library(UScensus2010)
library(UScensus2010county)

getPctRace <- function(state){
  block_pop_by_race <- data.frame(state[c('asian', 'black', 'hispanic', 'white', 'ameri.es', 'mult.race')])
  block_percent <- data.frame(block_pop_by_race/state$pop2000)
  block_percent[block_percent =='NaN'] <- 0
  block_percent[block_percent ==NA] <- 0
  return(block_percent)
}

plot_state <- function(blkgrp, state_name, race_color){
  map('state',region=state_name)
  plot(blkgrp, col=race_color, border="transparent", add=TRUE)
}

set_color <- function(race_pct){
  colorBucket <- brewer.pal(n=6, 'Set2')
  
  for(i in 1:6){
    race_pct[,i+6] <- scales::alpha(colorBucket[i],race_pct[,i])
  }
  
  return(race_pct)
}


load_data <- function(){
  data(alabama.blkgrp)
  data(alaska.blkgrp)
  data(arizona.blkgrp)
  data(arkansas.blkgrp)
  data(california.blkgrp)
  data(colorado.blkgrp)
  data(connecticut.blkgrp)
  data(delaware.blkgrp)
  data(district_of_columbia.blkgrp)
  data(florida.blkgrp)
  data(georgia.blkgrp)
  data(hawaii.blkgrp)
  data(idaho.blkgrp)
  data(illinois.blkgrp)
  data(indiana.blkgrp)
  data(iowa.blkgrp)
  data(kansas.blkgrp)
  data(kentucky.blkgrp)
  data(louisiana.blkgrp)
  data(maine.blkgrp)
  data(maryland.blkgrp)
  data(massachusetts.blkgrp)
  data(michigan.blkgrp)
  data(minnesota.blkgrp)
  data(mississippi.blkgrp)
  data(missouri.blkgrp)
  data(montana.blkgrp)
  data(nebraska.blkgrp)
  data(nevada.blkgrp)
  data(new_hampshire.blkgrp)
  data(new_jersey.blkgrp)
  data(new_mexico.blkgrp)
  data(new_york.blkgrp)
  data(north_carolina.blkgrp)
  data(north_dakota.blkgrp)
  data(ohio.blkgrp)
  data(oklahoma.blkgrp)
  data(oregon.blkgrp)
  data(pennsylvania.blkgrp)
  data(rhode_island.blkgrp)
  data(south_carolina.blkgrp)
  data(south_dakota.blkgrp)
  data(tennessee.blkgrp)
  data(texas.blkgrp)
  data(utah.blkgrp)
  data(vermont.blkgrp)
  data(virginia.blkgrp)
  data(washington.blkgrp)
  data(west_virginia.blkgrp)
  data(wisconsin.blkgrp)
  data(wyoming.blkgrp)
}
data()