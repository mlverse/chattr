# Request submission works

    Code
      out$gpt35
    Output
      [1] "OpenAI - Chat Completions - gpt-3.5-turbo (gpt35) \n"

---

    Code
      out$gpt4
    Output
      [1] "OpenAI - Chat Completions - gpt-4 (gpt4) \n"

# Menu works

    Code
      chattr_defaults(force = TRUE)
    Message
      
      -- chattr ----------------------------------------------------------------------
      
      -- Defaults for: Default --
      
      -- Prompt: 
      * Use the R language, the tidyverse, and tidymodels
      
      -- Model 
      * Provider: LlamaGPT
      * Path/URL: ~/LlamaGPTJ-chat/build/bin/chat
      * Model: test/path
      * Label: GPT4ALL 1.3 (LlamaGPT)
      
      -- Model Arguments: 
      * threads: 4
      * temp: 0.01
      * n_predict: 1000
      
      -- Context: 
      Max Data Files: 0
      Max Data Frames: 0
      x Chat History
      x Document contents

