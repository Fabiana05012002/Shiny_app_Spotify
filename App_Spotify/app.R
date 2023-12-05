library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(dplyr)

ui <- dashboardPage(
  skin = "green",
  
  dashboardHeader(title = "Análisis de Spotify", 
                  titleWidth = 210),
  
  dashboardSidebar(
    width = 210,
    selectInput("año", "Año", 
                choices = NULL, selected = NULL),
    
    selectInput("genero", "Género", 
                choices = NULL, selected = NULL),
    
    
    fluidRow(
      column(1, offset = 2,
             downloadButton("downloadData", "Descargar datos")
      )
    )
  ),
  
  dashboardBody(
    fluidRow(
      column(
        plotlyOutput("scatterplot"),
        width = 5
      ),
      column(
        dataTableOutput("table"), 
        width = 7
      )
    )
  )
)

server <- function(input, output, session) {
  
  spotify_2000_2023 <- read.csv("C:/Users/Fabi Hidalgo/Desktop/CETAV/programacion I/mi_primer_repo/datos/spotify_2000_2023.csv", sep=";")
  
  updateSelectInput(session, "año", 
                    choices = unique(spotify_2000_2023$year))
  
  observe({
    updateSelectInput(session, "genero", 
                      choices = unique(spotify_2000_2023$top.genre))
  })
  
  filtered_data <- reactive({
    
    filter_data <- spotify_2000_2023
    if (input$año != "All") {
      filter_data <- filter_data[filter_data$year == as.numeric(input$año), ]
    }
    
    if (input$genero != "All") {
      
      filter_data <- filter_data[filter_data$top.genre == input$genero, ]
    }
    
    filter_data
  })
  
  output$scatterplot <- renderPlotly({
    
    plot_ly(data = filtered_data(), x = ~popularity, y = ~bpm, type = "scatter", color = "orange", mode = "markers") |>
      layout(title = "Popularidad vs BPM")
    
  })
  
  output$table <- renderDataTable({
    
    filtered_data()
    
  }, options = list(scrollX = TRUE))  
  
  output$downloadData <- downloadHandler(
    
    filename = function() {
      
      paste("filtered_data_", Sys.Date(), ".csv", sep = "")
    },
    
    content = function(file) {
      
      write.csv(filtered_data(), file, row.names = FALSE)
    }
  )
  
}

shinyApp(ui, server)
