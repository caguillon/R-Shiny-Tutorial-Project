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
                 selectInput("countryInput", "Country",
                             choices = c("CANADA", "FRANCE", "ITALY"))
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
  
  #creating a plot inside renderPlot() & assigning it to coolplot in output list
  output$coolplot <- renderPlot({
    filtered <-
      bcl %>%
      filter(Price >= input$priceInput[1],
                   Price <= input$priceInput[2],
                   Type == input$typeInput,
                   Country == input$countryInput
            )
    ggplot(filtered, aes(Alcohol_Content)) +
    geom_histogram()
  })
  
  #creating a table inside renderTable()
  output$results <- renderTable({
    filtered <-
      bcl %>%
      filter(Price >= input$priceInput[1],
                   Price <= input$priceInput[2],
                   Type == input$typeInput,
                   Country == input$countryInput
            )
    filtered
  })
  
}

shinyApp(ui = ui, server = server)