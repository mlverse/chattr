# Submit method works

    Code
      ch_submit(def, "test", preview = TRUE)
    Output
      [[1]]
      [[1]]$role
      [1] "system"
      
      [[1]]$content
      [1] "You are a helpful coding assistant"
      
      
      [[2]]
      [[2]]$role
      [1] "user"
      
      [[2]]$content
      [1] "* Use the 'Tidy Modeling with R' (https://www.tmwr.org/) book as main reference \n* Use the 'R for Data Science' (https://r4ds.had.co.nz/) book as main reference \n* Use tidyverse packages: readr, ggplot2, dplyr, tidyr \n* For models, use tidymodels packages: recipes, parsnip, yardstick, workflows, broom \n* Avoid explanations unless requested by user, expecting code only\ntest"
      
      

---

    Code
      ch_submit(def, "test", preview = TRUE)
    Output
      [[1]]
      [[1]]$role
      [1] "system"
      
      [[1]]$content
      [1] "You are a helpful coding assistant"
      
      
      [[2]]
      [[2]]$role
      [1] "user"
      
      [[2]]$content
      [1] "* Use the 'Tidy Modeling with R' (https://www.tmwr.org/) book as main reference \n* Use the 'R for Data Science' (https://r4ds.had.co.nz/) book as main reference \n* Use tidyverse packages: readr, ggplot2, dplyr, tidyr \n* For models, use tidymodels packages: recipes, parsnip, yardstick, workflows, broom \n* Avoid explanations unless requested by user, expecting code only\ntest"
      
      

