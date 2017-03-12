if(!require(leaflet)){
  install.packages("leaflet")
  library(leaflet)
}
library(leaflet)

function(input, output, session) {

  ## Interactive Map ###########################################

  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -73.81, lat = 40.71, zoom = 11)
  })

  observe({
    
    dateIn <- input$date
    #dateIn <- format(dateIn, format="%Y-%m-%d")
    
    timeIn <- input$time
    
    filt_probs <- probs[(probs$hour == timeIn) & (probs$date == dateIn),]
    
    colorData <- filt_probs[["accident_prob"]]  
    pal <- colorBin("Greens", colorData, 9, pretty = TRUE)
   
    radius <- 500
    
    leafletProxy("map", data = filt_probs) %>% 
      clearShapes() %>%
      addCircles(~LONGITUDE, ~LATITUDE, radius=radius,
                 stroke=FALSE, fillOpacity=0.9, fillColor=pal(colorData)) %>%
      addLegend("bottomright", pal=pal, values=colorData, title="Probability of Accidents", 
                layerId="colorLegend")
  })

  #### trial of pops
  
  # Show a popup of the zip code and probability of accident
  showZipcodePopup <- function(lat, lng) {
    
    dateIn <- input$date
    timeIn <- input$time
    filt_probs <- probs[(probs$hour == timeIn) & (probs$date == dateIn),]
    
    selectedZip <- filt_probs[(filt_probs$LATITUDE == lat) & (filt_probs$LONGITUDE == lng),]
    
    content <- as.character(tagList(
      
      tags$h5("Zip Code:", selectedZip$zip_code),
      tags$h5("Probability of Accident:", selectedZip$accident_prob)
      
    ))
    
    leafletProxy("map") %>% addPopups(lng, lat, content)
    
  }
  
  # When map is clicked, show a popup with city info
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()
    isolate({
      showZipcodePopup(event$lat, event$lng)
    })
  })
  
}
