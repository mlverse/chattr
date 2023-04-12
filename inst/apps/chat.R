library(rclipboard)

ui <- fluidPage(
  rclipboardSetup(),
  fixedPanel(
    width = "100%", left = -1,
    fluidRow(
      column(width = 1, div()),
      column(
        width = 9,
        textAreaInput("prompt", "", width = "70%", value = "test", resize = "horizontal")
      ),
      column(width = 2, br(), actionButton("add", "Submit"))
    ),
    style = "opacity: 1; z-index: 10; background-color: #0a9;"
  ),
  absolutePanel(
    top = 100, width = "95%",
    tabsetPanel(
      type = "tabs",
      id = "tabs"
    )
  )
)

server <- function(input, output, session) {
  # Add clipboard buttons
  # output$clip <- renderUI({
  output$clip <- renderUI({
    rclipButton(
      inputId = "clipbtn",
      label = "Copy",
      clipText = input$copytext,
      icon = icon("clipboard")
    )
  })
  # })

  observeEvent(input$add, {
    insertUI(
      selector = "#tabs",
      where = "afterEnd",
      ui = {

        fluidRow(
          style = "
          border-color: #ddd;
          border-style: solid;
          background-color: #fff;
          border-width: 1px;
          padding-left: 10px;
          padding-right: 10px;
          margin: 10px;
          ",
          markdown("
    # Markdown Example

    This is a markdown paragraph, and will be contained within a `<p>` tag
    in the UI.

    ```{r}
    1 + 1
    ```
    ")
        )
      }
    )
  }

  )
}

shinyApp(ui, server)
