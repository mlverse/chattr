ui <- fluidPage(
  fixedPanel(
    width = "100%", left = -1,
    fluidRow(
      column(width = 1, div()),
      column(width = 9, textAreaInput("prompt", "", width = "90%", value = "test", resize = "none")),
      column(width = 2, br(), actionButton("add", "Submit"))
    ),
    style = "opacity: 1; z-index: 10; background-color: #099;"
  ),
  absolutePanel(
    top = 100, width = "100%",
    tabsetPanel(
      type = "tabs",
      id = "tabs"
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$add, {
    insertUI(
      selector = "#tabs",
      where = "afterEnd",
      ui = {
        wellPanel(renderText(input$prompt))
      }
    )
  })
}

shinyApp(ui, server)
