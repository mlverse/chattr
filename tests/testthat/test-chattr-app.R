test_that("chattr app initial values are consistent", {
  library(shinytest2)
  skip_on_cran()
  test_model_backend()
  shiny_app <- shinyApp(app_ui(), app_server)
  app <- AppDriver$new(shiny_app)
  app$expect_values()
})
