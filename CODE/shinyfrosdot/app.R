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
  clauseTexts[[c]] = readLines(con)
  close(con)
}
setwd("..")


# The shiny web interface (front-end)
ui <- fluidPage(

  theme = shinytheme("paper"),

  wellPanel(htmlOutput("title")),

  sidebarLayout(

    # Sidebar contains user input
    sidebarPanel(
      downloadButton(outputId = "downloadDoc",
        label = "Export Contract"),
      checkboxGroupInput(inputId = "cb", "Clauses", clauses),
      uiOutput(outputId = "form")
      ),

    # Main panel previews clause data
    mainPanel(
      htmlOutput(outputId = "t")
    )
  )
)

previewClause = function(clause) {
  paste(clause, collapse = "</br>")
}

exportClause = function(clause) {
  paste(clause, collapse = "\n")
}


# Server code (back-end)
server <- function(input, output, session) {

  output$title <- renderText(
    "<h3>FROSDOT</h3>Free Open Source Document Templates"
  )

  # Gather user-checked clauses reactively
  inputFields <- reactive({
    full <- paste0(clauseTexts[input$cb])
    unique(unlist(regmatches(full, gregexpr("\\{.*?\\}", full))))
  })

  # Clause data for previewing
  output$t <- renderText(
    paste(lapply(clauseTexts[input$cb], previewClause), collapse = "</br>")
  )

  # Download text
  outputText = reactive({
    paste(lapply(clauseTexts[input$cb], exportClause))
  })

  output$downloadDoc = downloadHandler(
    filename = "export.txt",
    # file is required by Shiny.
    content = function(file) {
      write(paste0(outputText(),
          sep = "\n"),
        file = file)
    }
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

