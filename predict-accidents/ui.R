if(!require(leaflet)){
  install.packages("leaflet")
  library(leaflet)
}
library(leaflet)

dates <- sort(as.vector(unique(probs$date)))
dates <- dates[dates > Sys.Date()]
dates <- dates[1:3] # show predictions of only the next 3 days 
#dates <- format(as.Date(dates), format"%B %d %Y")

navbarPage(
  #title="IBM weather's data used to train a model to predict car accidents in NYC", id="nav",
  
  title = div(img(src="dsx1.png"),"IBM"), 

  tabPanel(
    div(class="outer",

      tags$head(
        # Include our custom CSS
        includeCSS("styles.css"),
        includeScript("gomap.js")
      ),

      leafletOutput("map", width="100%", height="100%"),

      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
        draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
        width = 330, height = "auto", 

        h2("Choose date & time"),

        selectInput("date","Date",dates),
        
        # TODO: change date input to dateInput()
        #dateInput("date","Date:",value = "02-01-2016",format="mm-dd-yyyy"),
        
        sliderInput("time","Time", min = 0, max = 23, value = 9)

      ),

      tags$div(id="cite",'Data Scientists: Jorge Castañón, Shahab Sheikh, Jihyoung Kim',fontsize=20)
      
    )
  )
)
