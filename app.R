#App is complete. Final steps would be to put it on the internet.
#Options:
  #Host on shinyapps.io (free)
  #Host on a Shiny Server

#required libraries
library(shiny)
library(ggplot2)
library(dplyr)

#reading in dataset
bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

#initializes an empty UI and an empty server:

#R strings inside fluidPage() to render text
ui <- fluidPage(
  titlePanel("BC Liquor Store prices"),
  sidebarLayout(
    #our inputs go here
    sidebarPanel(sliderInput("priceInput", "Price", min = 0, max = 100,
                             value = c(25, 40), pre = "$"),
                 radioButtons("typeInput", "Product type",
                              choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                              selected = "WINE"),
                 #selectInput("countryInput", "Country",
                             #choices = c("CANADA", "FRANCE", "ITALY"))
                 #to create UI elements dynamically (ex. v will replace manual input of select input)
                 uiOutput("countryOutput")
                 ),
    #our results will go here
    #placeholder in UI for plot named coolplot
    mainPanel(plotOutput("coolplot"),
              br(),
              br(),
              br(),
              tableOutput("results")
              )
  )
)

server <- function(input, output, session) {
  #prints in console
  print(str(bcl))
  
  #will create a UI element
  output$countryOutput <- renderUI({
    selectInput("countryInput", "Country",
                    sort(unique(bcl$Country)),
                    selected = "CANADA")
  })
  
  #reactive variable (to reduce code duplication)
  filtered <- reactive({
    #since country input is dynamically and takes some time to create,
    #filtered will be created when it is not null. This will take care of errors when app runs.
    if (is.null(input$countryInput)) {
      return(NULL)
    }
    #actual value we want for filtered
    bcl %>%
      filter(Price >= input$priceInput[1],
                   Price <= input$priceInput[2],
                   Type == input$typeInput,
                   Country == input$countryInput
            )
  })
  
  #creating a plot inside renderPlot() & assigning it to coolplot in output list
  output$coolplot <- renderPlot({
    #while app is setting up, null is default to avoid errors
    if (is.null(filtered())) {
      return()
    }
    ggplot(filtered(), aes(Alcohol_Content)) +
    geom_histogram()
  })
  
  #creating a table inside renderTable()
  output$results <- renderTable({
    filtered()
  })
  
  #all inputs are reactive, so they must be wrapped in a render function
  observe({print(input$priceInput)})
}

shinyApp(ui = ui, server = server)