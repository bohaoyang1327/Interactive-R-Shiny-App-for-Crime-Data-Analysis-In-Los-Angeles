library(shiny)
library(leaflet)
library(readxl)
library(tidyverse)
library(sf)
library(DT)
library(plotly)

# Load and pre-process the crime data
crime_data <- read_excel("crime2024.xlsx") |>
  mutate(
    `DATE OCC` = as.Date(`DATE OCC`, format = "%m/%d/%Y %I:%M:%S %p")
  )

# Load LA boundary GeoJSON
la_boundary <- st_read("City_Boundary.geojson")


# User Interface
ui <- fluidPage(
  # Title
  div(
    style = "text-align: center; font-weight: bold; font-size: 24px; margin-bottom: 20px;",
    "2024 JAN to APR Crime Data in the city of Los Angeles"
  ),
  # Tab bar with Map, Bar Chart, and Table options
  tabsetPanel(
    tabPanel("Map",
             fluidRow(
               column(
                 width = 6,
                 dateRangeInput(
                   "dateRange",
                   "Select Date Range:",
                   start = min(crime_data$`DATE OCC`),
                   end = max(crime_data$`DATE OCC`),
                   min = min(crime_data$`DATE OCC`),
                   max = max(crime_data$`DATE OCC`),
                   format = "yyyy-mm-dd",
                   width = "100%"
                 )
               )
             ),
             fluidRow(
               column(
                 width = 12,
                 div(
                   style = "margin-top: 30px; color: gray;",
                   p("Click on the colored circle marker to view the area name and the total number of crimes 
                     in that area within the selected period. The color of the circle markers transitions from yellow to red 
                     is based on the total number of crimes where red represents the most and yellow represents the least. 
                     You can zoom in or out on the map for more detailed map exploration.")
                 )
               )
             ),
             fluidRow(
               column(
                 width = 12,
                 leafletOutput("crimeMap", height = "600px")
               )
             )
    ),
    tabPanel("Bar Chart",
             fluidRow(
               column(
                 width = 6,
                 uiOutput("topNSelector")
               )
             ),
             fluidRow(
               column(
                 width = 12,
                 div(
                   style = "margin-top: 30px; color: gray;",
                   p("Hover over the bars to view the total number of crimes in specific area within 
                     the selected period in Map section.")
                 )
               )
             ),
             fluidRow(
               column(
                 width = 12,
                 plotlyOutput("crimeBarChart", height = "500px")
               )
             )
    ),
    tabPanel("Table",
             fluidRow(
               column(
                 width = 6,
                 selectInput(
                   "areaFilter",
                   "Select Area:",
                   choices = c("All", sort(unique(crime_data$`AREA NAME`))),
                   selected = "All"
                 )
               )
             ),
             fluidRow(
               column(
                 width = 12,
                 dataTableOutput("crimeTable")
               )
             )
    )
  )
)


# Server Logic
server <- function(input, output, session) {
  # Filter data based on the selected date
  filteredData <- reactive({
    crime_data |>
      filter(`DATE OCC` >= input$dateRange[1], `DATE OCC` <= input$dateRange[2])
  })
  
  # Top N selector setup
  output$topNSelector <- renderUI({
    unique_areas <- filteredData() |>
      distinct(`AREA NAME`) |>
      nrow()
    selectInput(
      "topN",
      "Select top n areas:",
      choices = seq(1, unique_areas),
      selected = min(3, unique_areas) # Default to 3 or total number of areas, whichever is smaller
    )
  })
  
  # Map section generating
  output$crimeMap <- renderLeaflet({
    data <- filteredData() |>
      group_by(`AREA NAME`) |>
      summarize(
        Total_Crimes = n(),
        LAT = mean(LAT, na.rm = TRUE),
        LON = mean(LON, na.rm = TRUE)
      )
    # Define a yellow-to-red color palette for crime counts
    crime_palette <- colorNumeric(
      palette = c("yellow", "red"),
      domain = data$Total_Crimes
    )
    leaflet(options = leafletOptions(zoomControl = FALSE)) |> # Exclude the zoom-in zoom-out tab
      addTiles() |>
      # Mark the area space of the city of Los Angeles
      addPolygons(
        data = la_boundary,
        color = "blue",
        weight = 2,
        fillColor = "blue",
        fillOpacity = 0.1,
        group = "LA Boundary"
      ) |>
      # Mark the central place of each crime area with red dot 
      addCircleMarkers(
        data = data,
        lat = ~LAT,
        lng = ~LON,
        radius = 10,
        color = ~crime_palette(Total_Crimes), # Apply the defined yellow-to-red color palette
        fillOpacity = 0.8,
        popup = ~paste0(
          "<b>Area:</b> ", `AREA NAME`, "<br>",
          "<b>Total Crimes:</b> ", Total_Crimes
        ),
        group = "Crimes"
      )
  })
  
  # Bar chart section generating
  output$crimeBarChart <- renderPlotly({
    req(input$topN)  # Ensure user input for N is available
    data <- filteredData() |>
      group_by(`AREA NAME`) |>
      summarize(Total_Crimes = n()) |>
      arrange(desc(Total_Crimes)) |>
      head(as.numeric(input$topN))
    plot1 <- ggplot(data, aes(x = reorder(`AREA NAME`, Total_Crimes), y = Total_Crimes)) +
      geom_bar(stat = "identity", fill = "cadetblue") +
      coord_flip() +
      labs(x = "Area Name", y = "Total Number of Crimes", title = paste("Top", input$topN, "Areas with Most Crimes")) +
      theme_minimal()
    # Show total number of crimes when hovering over
    ggplotly(plot1, tooltip = "y") |>
      config(displayModeBar = FALSE)  # Disable the toolbar 
  })
  
  # Table section generating
  output$crimeTable <- renderDataTable({
    data <- filteredData()
    # Filter data based on selected area
    if (input$areaFilter != "All") {
      data <- data |> filter(`AREA NAME` == input$areaFilter)
    }
    # Process how the data and columns are displayed for better readability
    data |>
      mutate(
        `TIME OCC` = paste0(substr(`TIME OCC`, 1, 2), ":", substr(`TIME OCC`, 3, 4)),
        `Crime Severity` = case_when(
          `Part 1-2` == 1 ~ "Serious",
          `Part 1-2` == 2 ~ "Less Serious",
          TRUE ~ NA_character_
        )
      ) |>
      select(
        `Date Occurred` = `DATE OCC`,
        `Time Occurred (in 24 hour military time)` = `TIME OCC`,
        `Crime Brief Description` = `Crm Cd Desc`,
        `Type of Location Occurred` = `Premis Desc`,
        `Crime Severity`
      )
  })
}

shinyApp(ui = ui, server = server)
