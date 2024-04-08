# Basic default tests

    Code
      chattr_use("llamagpt")
    Message
      
      -- chattr 
      * Provider: LlamaGPT
      * Path/URL: ~/LlamaGPTJ-chat/build/bin/chat
      * Model: ~/ggml-gpt4all-j-v1.3-groovy.bin
      * Label: GPT4ALL 1.3 (LlamaGPT)

---

    Code
      chattr_defaults()
    Message
      
      -- chattr ----------------------------------------------------------------------
      
      -- Defaults for: Console --
      
      -- Prompt: 
      * Use the R language, the tidyverse, and tidymodels
      
      -- Model 
      * Provider: LlamaGPT
      * Path/URL: ~/LlamaGPTJ-chat/build/bin/chat
      * Model: ~/ggml-gpt4all-j-v1.3-groovy.bin
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

# Makes sure that changing something on 'default' changes it every where

    Code
      chattr_use("llamagpt")
    Message
      
      -- chattr 
      * Provider: LlamaGPT
      * Path/URL: ~/LlamaGPTJ-chat/build/bin/chat
      * Model: ~/ggml-gpt4all-j-v1.3-groovy.bin
      * Label: GPT4ALL 1.3 (LlamaGPT)

---

    Code
      chattr_defaults(model = "test")
    Message
      
      -- chattr ----------------------------------------------------------------------
      
      -- Defaults for: Default --
      
      -- Prompt: 
      * Use the R language, the tidyverse, and tidymodels
      
      -- Model 
      * Provider: LlamaGPT
      * Path/URL: ~/LlamaGPTJ-chat/build/bin/chat
      * Model: test
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

# Changing something in non-default does not impact others

    Code
      chattr_use("llamagpt")
    Message
      
      -- chattr 
      * Provider: LlamaGPT
      * Path/URL: ~/LlamaGPTJ-chat/build/bin/chat
      * Model: ~/ggml-gpt4all-j-v1.3-groovy.bin
      * Label: GPT4ALL 1.3 (LlamaGPT)

