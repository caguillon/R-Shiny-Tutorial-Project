#required libraries
library(shiny)

#reading in dataset
bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

#initializes an empty UI and an empty server:

#R strings inside fluidPage() to render text
ui <- fluidPage(
  titlePanel("BC Liquor Store prices"),
  sidebarLayout(
    sidebarPanel(sliderInput("priceInput", "Price", min = 0, max = 100,
                             value = c(25, 40), pre = "$")
                 ),
    mainPanel("the results will go here")
  )
)
server <- function(input, output, session) {
  print(str(bcl))
}

shinyApp(ui = ui, server = server)