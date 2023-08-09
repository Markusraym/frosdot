# app.R


# Necessary?
library(shiny)
library(shinythemes)


# Importing locally stored files
setwd("clauses")
clauses = list.files()
clauseTexts = list()
for (c in clauses) {
  con = file(c, open = "r", blocking = T)
  clauseTexts[[c]] = paste(paste("<h3>", readLines(con, n = 1), "</h3>"), paste(readLines(con), collapse = "</br>"))
  close(con)
}
setwd("..")


# The shiny web interface (front-end)
ui <- fluidPage(

  theme = shinytheme("paper"),

  # Small bit of design
  wellPanel(),

  sidebarLayout(

    # Sidebar contains user input
    sidebarPanel(
      checkboxGroupInput(inputId = "cb", "Clauses", clauses),
      uiOutput(outputId = "form")
    ),

    # Main panel previews clause data
    mainPanel(
      htmlOutput(outputId = "t")
    )
  )
)


# Server code (back-end)
server <- function(input, output, session) {

  # Gather user-checked clauses reactively
  inputFields <- reactive({
      full <- paste0(clauseTexts[input$cb])
      unique(unlist(regmatches(full, gregexpr("\\{.*?\\}", full))))
  })

  # Clause data for previewing
  output$t <- renderText(
    paste(clauseTexts[input$cb], collapse = "</br>")
  )

  # Textbox inputs react to clause selections
  output$form <- renderUI({
    # This is scrappy, but avoiding a bug with shiny
    o = list()
    for (i in inputFields()) {
      o[[i]] = textInput(i, i)
    }
    o
  })
}

# Run the app
shinyApp(ui = ui, server = server)

