test_that("RGB to Hex works", {
  expect_equal(
    app_theme_rgb_to_hex("rgb(0, 0, 0)"),
    "#000000"
  )
})
