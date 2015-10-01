source('functions.R')
library(httr)
library(RTwitterAPI)
library(base64enc)
library(jsonlite)
library(leaflet)
library(qdap)


oauth_endpoints("twitter")
myapp <- oauth_app("twitter",
                   key = "XXXXXXXXXXXXXXXXXXXXXXXXX",
                   secret = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
twitter_token <- oauth1.0_token(oauth_endpoints("twitter"), myapp)

req <- GET("https://api.twitter.com/1.1/search/tweets.json?q=&geocode=41.705572,-86.235339,1mi&count=1000",
           config(token = twitter_token))
tweet_list <- fromJSON(content(req, as = "text"), flatten = T)

#Remove NA's

#Get Geo Data and Text
coords_temp = sapply(tweet_list$statuses$geo.coordinates, function(x) as.character(x))
text = tweet_list$statuses$text
tweets <- data.frame(text, stringsAsFactors = F)
tweets$lat = unlist(lapply(coords_temp, function(x) x[1]))
tweets$lon = unlist(lapply(coords_temp, function(x) x[2]))


#Sentiment Analysis
tweets$pol <- unlist(lapply(tweets$text, function(x){polarity(x[1])[2]$group$ave.polarity}))
#add sentiment grouping
tweets$sentiment <- sapply(tweets$pol, sentiment)

tweets <- na.omit(tweets)

pal <- colorFactor(c("navy", "red", "green"), domain = c("Neutral", "Negative", "Positive"))
#Plotting Markers on Map
map <- leaflet() %>%
  setView(lng = -86.235339, lat = 41.705572, zoom = 14) %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles ,
  addCircleMarkers(lng = tweets$lon, lat = tweets$lat, 
                   popup = tweets$text, 
                   color= pal(tweets$sentiment), 
                   stroke = FALSE, 
                   fillOpacity = 0.5)



map
