library(shiny)
library(bslib)
library(maps)
library(mapproj)

source("helpers.R")
counties <- readRDS("data/counties.rds")

# Define UI ----
ui <- page_sidebar(
  title = "Spider Mites",
  sidebar = sidebar(
    card(
      helpText(
        "Create demographic maps",
        "with information from the",
        "2010 US Census."
        ),
      selectInput(
        "select",
        "Select option",
        choices = list("Percent White" = "Percent White", 
                       "Percent Black" = "Percent Black", 
                       "Percent Hispanic" = "Percent Hispanic", 
                       "Percent Asian" = "Percent Asian"),
        selected = 1
        ),
      sliderInput(
        "slider2",
        "Set value range",
        min = 0,
        max = 100,
        value = c(0, 100)
        )
      )
  ),
  textOutput("selected_var"),
  textOutput("selected_range"),
  card(plotOutput("map"))
)
# Define server logic ----
server <- function(input, output) {
  
  output$map <- renderPlot({
    data <- switch(input$select,
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    
    color <- switch(input$select,
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "darkorange",
                    "Percent Asian" = "darkviolet")
    
    legend <- switch(input$select,
                     "Percent White" = "% White",
                     "Percent Black" = "% Black",
                     "Percent Hispanic" = "% Hispanic",
                     "Percent Asian" = "% Asian")
    
    percent_map(data, color, legend, input$slider2[1], input$slider2[2])
  })
}

# Run the app ----
shinyApp(ui = ui, server = server)