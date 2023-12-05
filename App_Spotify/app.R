
library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(dplyr)

ui <- fluidPage(

)


server <- function(input, output) {

  spotify_2000_2023 <- read.csv("C:/Users/Fabi Hidalgo/Desktop/CETAV/PROGRAMACIÓN II/Shiny_app_Spotify/datos/spotify_2000_2023.csv", sep=";")

}

shinyApp(ui = ui, server = server)
