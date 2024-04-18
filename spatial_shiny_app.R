# Load necessary libraries
library(shiny)
library(here)
library(tidyverse)
library(readxl)
library(geojsonio)
library(sf)
library(magrittr)
library(broom)

# Define the server logic
server <- function(input, output) {
  # Reactive expression to generate data based on the selected year
  data <- reactive({
    # Filter data for the selected year
    dcd_em_selected_year <- dcd_em %>% filter(Year == input$year)
    
    # Join the map data with the selected year data
    district_map_selected_year <- left_join(district_map, dcd_em_selected_year, by = join_by(NAME_EN == District))
    
    # Convert population to numeric
    district_map_selected_year$`Total Population` <- as.numeric(district_map_selected_year$`Total Population`)
    
    return(district_map_selected_year)
  })
  
  # Render the plot
  output$plot <- renderPlot({
    ggplot(data()) + 
      geom_sf(aes(fill = `Total Population`)) + 
      scale_fill_gradient(low = "white", high = "black") +
      theme_minimal(base_size = 20)
  })
}

# Define the UI
ui <- fluidPage(
  # Add a select input for the year
  selectInput("year", "Select a year:", choices = unique(dcd_em$Year)),
  # Output the plot
  plotOutput("plot", height = "800px", width = "1500px")
)

# Run the app
shinyApp(ui = ui, server = server)

