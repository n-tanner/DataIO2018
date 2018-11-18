# Main script for DATAI/O 2018
# author: Nick Tanner
source("savePNG.R")

library(readr)
USFarmersMarkets <- read_csv("USFarmersMarkets.csv")
View(USFarmersMarkets)

# attach(USFarmersMarkets)
# plot(x, y, data = USFarmersMarkets)
# detach(USFarmersMarkets)

#
library(ggplot2)
library(ggmap)
USmainland = subset(USFarmersMarkets, !is.element(USFarmersMarkets$State, 
                                                  c("Puerto Rico", "Alaska",
                                                    "Virgin Islands", "Hawaii")))
locData = data.frame(USmainland$x, USmainland$y)
# used for plotting the state of ohio
ohio = subset(map_data("state"), region == 'ohio') #ohio map data

OhioData = subset(USFarmersMarkets, USFarmersMarkets$State == "Ohio")
ohLocData = data.frame(OhioData$x, OhioData$y)
colnames(ohLocData) = c("long", "lat")

#plot the farmers markets in ohio
ggplot(ohio, aes(long, lat, group = group)) + 
  geom_polygon(fill = "white", colour = "black") +
  geom_point(data = ohLocData, mapping = aes(x = long, y = lat), inherit.aes = F,
             size = 0.7) + coord_quickmap() + theme_nothing()

savePNG("TESTOHIO3.png")


# save plots of all states (mainland)

mainlandStates = unique(USmainland$State)
#mainlandStates = subest(mainlandStates, c(""))

for(state in mainlandStates){
  statemapdata =  subset(map_data("state"), region == tolower(state)) 
  stateData = subset(USFarmersMarkets, USFarmersMarkets$State == state)
  stateLocData = data.frame(stateData$x, stateData$y)
  colnames(stateLocData) = c("long", "lat")
  
  png(capture.output(cat(state, ".png", sep = "")))
  
  temp = ggplot(statemapdata, aes(long, lat, group = group)) + 
    geom_polygon(fill = "white", colour = "black") +
    geom_point(data = stateLocData, mapping = aes(x = long, y = lat), inherit.aes = F,
               size = 0.7) + coord_quickmap() + theme_nothing()
  print(temp)
  
  dev.off()
}

#problem states
# points appearing way out of the boundaries of the state
library(plotly)
problemstates = c("California", "Iowa", "Rhode island", "Florida")
state = "Florida"

statemapdata =  subset(map_data("state"), region == tolower(state)) 
stateData = subset(USFarmersMarkets, USFarmersMarkets$State == state)
stateLocData = data.frame(stateData$x, stateData$y)
colnames(stateLocData) = c("long", "lat")

#png(capture.output(cat(state, ".png", sep = "")))

ggplot(statemapdata, aes(long, lat, group = group)) + 
  geom_polygon(fill = "white", colour = "black") +
  geom_point(data = stateLocData, mapping = aes(x = long, y = lat), inherit.aes = F,
             size = 0.7) + coord_quickmap() + theme_nothing() +
  
  geom_text(mapping = aes(x = x, y = y,label = stateData$FMID), 
            data = stateData, inherit.aes = F)

#ggplotly()
#print(temp)

#dev.off()
