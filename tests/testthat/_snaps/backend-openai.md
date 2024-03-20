# Init messages work

    Code
      chattr_use("gpt35")
    Message
      
      -- chattr 
      * Provider: OpenAI - Chat Completions
      * Path/URL: https://api.openai.com/v1/chat/completions
      * Model: gpt-3.5-turbo
      * Label: GPT 3.5 (OpenAI)

---

    Code
      app_init_message(chattr_defaults())
    Message
      * Provider: OpenAI - Chat Completions
      * Path/URL: https://api.openai.com/v1/chat/completions
      * Model: gpt-3.5-turbo
      * Label: GPT 3.5 (OpenAI)

---

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
      app_init_message(chattr_defaults())
    Message
      * Provider: LlamaGPT
      * Path/URL: ~/LlamaGPTJ-chat/build/bin/chat
      * Model: ~/ggml-gpt4all-j-v1.3-groovy.bin
      * Label: GPT4ALL 1.3 (LlamaGPT)

