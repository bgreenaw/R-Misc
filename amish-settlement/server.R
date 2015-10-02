library(dplyr)
library(maps)
library(scales)


amish <- read.csv('data/amish.csv')

#server

#adding data for County plot
amish$StCnty <- tolower(paste(amish$PrimaryState, amish$County1, sep=","))
#amish$ri <- as.numeric(cut(amish$ChurchDistricts/max(amish$ChurchDistricts),c(seq(0,1,by=.2),max(amish$ChurchDistricts))))


cols <- alpha("#FF5500", seq(0, 1, length = 5))
mp <- map("county", plot=FALSE,namesonly=TRUE)

# create pointrange from .25 to 1.5
CD = amish$ChurchDistricts
amish$pointrange = (CD-min(CD))/(max(CD)-min(CD))*(1.5-.25) + .25
# create 
amish$ri <- (CD-min(CD))/(max(CD)-min(CD))*(1.0-.15) + .15

shinyServer(function(input, output) {
  output$map <- renderPlot({
    if(input$map_type == 1){
      amishNow <- amish %.%
        filter(YearFounded <= input$year) %.%
        select(YearFounded, ChurchDistricts, city1Lon, city1Lat, pointrange)
      # The following does the same but keeps the original row # as row.name
      # amishNow = amish[amish$YearFounded<=input$year, c('YearFounded', 'ChurchDistricts', 'city1Lon', 'city1Lat', 'pointrange')]
      
      map('state', col='gray50', lwd=.5, ylim=c(20,50))
      map('world', 'canada', col='gray50', lwd=.5, add=T)
      points(amishNow[,c('city1Lon','city1Lat')], col=alpha('blue', .4), pch=19, cex=amishNow$pointrange)
    }
    else{
      amishNow = amish[amish$YearFounded<= input$year, 
                       c('YearFounded', 'ChurchDistricts', 'StCnty', 'ri')]
      
      StCnty_collapsed <- amishNow[c('StCnty', 'ri')]  
      StCnty_collapsed <- aggregate(StCnty_collapsed$ri, by=list(StCnty=StCnty_collapsed$StCnty), FUN=sum)
      
      colorpct <- StCnty_collapsed[match(mp,StCnty_collapsed$StCnty),]$x
      colorpct[is.na(colorpct)] = 0
      colorpct <- sapply(colorpct, function(x) ifelse(x > 1, 1, x))
      color_bucket = scales::alpha("#FF5500", colorpct)
      
      map("county",col = color_bucket, fill = TRUE,resolution = 0,lty = 0)
      map("state",col = "gray50",fill=FALSE,add=TRUE,lty=1,lwd=1)
       
    }
  })
})