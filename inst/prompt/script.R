writeLines(
  c(
    "Use the 'Tidy Modeling with R' (https://www.tmwr.org/) book as main reference",
    "Use the 'R for Data Science' (https://r4ds.had.co.nz/) book as main reference",
    "Use tidyverse packages: readr, ggplot2, dplyr, tidyr",
    "For models, use tidymodels packages: recipes, parsnip, yardstick, workflows, broom",
    "Avoid explanations unless requested by user, expecting code only"
  ),
  here::here("inst", "prompt", "base.txt")
)
