# app.R

library(shiny)
library(shinythemes)

setwd("clauses")
clauses = list.files()
clauseTexts = list()
for (c in clauses) {
  con = file(c, open = "r", blocking = T)
  clauseTexts[[c]] = paste(paste("<h3>", readLines(con, n = 1), "</h3>"), paste(readLines(con), collapse = "</br>"))
  close(con)
}
setwd("..")

ui <- fluidPage(
  theme = shinytheme("paper"),
  # selectInput(inputId = "s", "Files", choice = clauses),
  # numericInput(inputId = "n", "Sample size", value = 25),
  wellPanel(),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput(inputId = "cb", "Clauses", clauses)
    ),
    mainPanel(
      htmlOutput(outputId = "t")
    )
  )
  # plotOutput(outputId = "hist")
)

server <- function(input, output, session) {
  output$t <- renderText(
    paste(clauseTexts[input$cb], collapse = "</br>")
  )
  # output$hist <- renderPlot({
  #   hist(rnorm(input$n))
  # })
}

shinyApp(ui = ui, server = server)
