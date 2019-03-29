#required libraries
library(shiny)

#initializes an empty UI and an empty serve
ui <- fluidPage()
server <- function(input, output, session) {}
shinyApp(ui = ui, server = server)