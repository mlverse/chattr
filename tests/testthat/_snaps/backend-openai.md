# Init messages work

    Code
      chattr_use("gpt35")
    Message <cliMessage>
      
      -- chattr 
      * Provider: Open AI - Chat Completions
      * Path/URL: https://api.openai.com/v1/chat/completions
      * Model: gpt-3.5-turbo

---

    Code
      app_init_openai(chattr_defaults())
    Message <cliMessage>
      * Provider: Open AI - Chat Completions
      * Path/URL: https://api.openai.com/v1/chat/completions
      * Model: gpt-3.5-turbo
      ! A list of the top 10 files will be sent externally to OpenAI with every request
      To avoid this, set the number of files to be sent to 0 using `chattr::chattr_defaults(max_data_files = 0)`
      ! A list of the top 10 data.frames currently in your R session will be sent externally to OpenAI with every request
      To avoid this, set the number of data.frames to be sent to 0 using `chattr::chattr_defaults(max_data_frames = 0)`

---

    Code
      chattr_use("llamagpt")
    Message <cliMessage>
      
      -- chattr 
      * Provider: LlamaGPT
      * Path/URL: ~/LlamaGPTJ-chat/build/bin/chat
      * Model: ~/ggml-gpt4all-j-v1.3-groovy.bin

---

    Code
      app_init_openai(chattr_defaults())
    Message <cliMessage>
      * Provider: LlamaGPT
      * Path/URL: ~/LlamaGPTJ-chat/build/bin/chat
      * Model: ~/ggml-gpt4all-j-v1.3-groovy.bin

