#' Recommended base prompt
#' @format Character vectors
#' @description It is meant to be used within the tidychat_default() function
#' @examples
#'
#' tidychat_defaults(
#'   c("This is an example", "{tidychat_base_prompt}"),
#'   type = "chat"
#'   )
#'
"tidychat_base_prompt"


tidychat_base <- function() {
  c(
    "Use the 'Tidy Modeling with R' (https://www.tmwr.org/) book as main reference",
    "Use the 'R for Data Science' (https://r4ds.had.co.nz/) book as main reference",
    "Use tidyverse packages: readr, ggplot2, dplyr, tidyr",
    "skimr and janitor can also be used if needed",
    "For models, use tidymodels packages: recipes, parsnip, yardstick, workflows, broom",
    "Expecting only code, avoid comments unless requested by user"
  )
}
# tidychat_base_prompt <- tidychat_base()
# use_data(tidychat_base_prompt)

