## ui.R
library(shiny)
library(shinydashboard)
library(recommenderlab)
library(data.table)
library(ShinyRatingInput)
library(shinyjs)

source('helpers.R')

shinyUI(
  fluidPage(
    navlistPanel(
      tabPanel("Recommender by Genres",dashboardPage(
        skin = "blue",
        dashboardHeader(title = "movie Recommender"),
        
        dashboardSidebar(disable = TRUE),
        
        dashboardBody(includeCSS("movies.css"),
                      fluidRow(
                        box(width = 12, title = "Step 1: Select your favoriate genres", status = "info", solidHeader = TRUE, collapsible = TRUE,
                            selectInput("genres","Select one genres:", 
                                        choices = c("Action", "Adventure", "Animation", 
                                                    "Children's", "Comedy", "Crime",
                                                    "Documentary", "Drama", "Fantasy",
                                                    "Film-Noir", "Horror", "Musical", 
                                                    "Mystery", "Romance", "Sci-Fi", 
                                                    "Thriller", "War", "Western"),
                                        selected = "Action")
                            
                        )
                      ),
                      fluidRow(
                        useShinyjs(),
                        box(
                          width = 12, status = "info", solidHeader = TRUE,
                          title = "Step 2: Discover movies you might like",
                          br(),
                          withBusyIndicatorUI(
                            actionButton("btn", "Click here to get your recommendations", class = "btn-warning")
                          ),
                          br(),
                          tableOutput("results_genres")
                        )
                      )
        )
      )),
      
      tabPanel("Recommender by Rating",dashboardPage(
        skin = "blue",
        dashboardHeader(title = "movie Recommender"),
        
        dashboardSidebar(disable = TRUE),
        
        dashboardBody(includeCSS("movies.css"),
                      fluidRow(
                        box(width = 12, title = "Step 1: Rate as many movies as possible", status = "info", solidHeader = TRUE, collapsible = TRUE,
                            div(class = "rateitems",
                                uiOutput('ratings')
                            )
                        )
                      ),
                      fluidRow(
                        useShinyjs(),
                        box(
                          width = 12, status = "info", solidHeader = TRUE,
                          title = "Step 2: Discover movies you might like",
                          br(),
                          withBusyIndicatorUI(
                            actionButton("btn", "Click here to get your recommendations", class = "btn-warning")
                          ),
                          br(),
                          tableOutput("results")
                        )
                      )
        )
      ))
    )
  )
    
) 



