#required libraries
library(shiny)

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
    plot(rnorm(100))
    })
}

shinyApp(ui = ui, server = server)