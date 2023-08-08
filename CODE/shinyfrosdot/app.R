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
      checkboxGroupInput(inputId = "cb", "Clauses", clauses),
      uiOutput(outputId = "form")
    ),
    mainPanel(
      htmlOutput(outputId = "t")
    )
  )
)


server <- function(input, output, session) {

  inputFields <- reactive({
      #ifs <- list()
      #for (i in input$cb) {
      #    ifs[[i]] <- regmatches(input$cb[i], gregexpr("\\{.*?\\}", input$cb[i]))
      #}
      #ifs
      #regmatches(input$cb[3], gregexpr("\\{.*?\\}", input$cb[3]))
      full <- paste0(clauseTexts[input$cb])
      unique(unlist(regmatches(full, gregexpr("\\{.*?\\}", full))))
  })

  output$t <- renderText(
    paste(clauseTexts[input$cb], collapse = "</br>")
  )

  output$form <- renderUI({
    mapply(textInput, inputId = inputFields(), label = inputFields())
  })


}

shinyApp(ui = ui, server = server)
