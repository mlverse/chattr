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
      
      

# Error handling works

    Code
      parsed
    Output
      [1] "{{error}}{.emph Type:} invalid_request_error\n{.emph Message:} This model's maximum context length is 4097 tokens. However, your messages resulted in 22261 tokens. Please reduce the length of the messages."

# Init messages work

    Code
      app_init_message(def)
    Message
      * Provider: OpenAI - Chat Completions
      * Path/URL: https://api.openai.com/v1/chat/completions
      * Model: gpt-3.5-turbo
      * Label: GPT 3.5 (OpenAI)
      ! A list of the top 10 files will be sent externally to OpenAI with every request
      To avoid this, set the number of files to be sent to 0 using `chattr::chattr_defaults(max_data_files = 0)`
      ! A list of the top 10 data.frames currently in your R session will be sent externally to OpenAI with every request
      To avoid this, set the number of data.frames to be sent to 0 using `chattr::chattr_defaults(max_data_frames = 0)`

