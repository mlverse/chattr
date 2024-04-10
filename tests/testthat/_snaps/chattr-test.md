# Test function works for OpenAI

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
      chattr_test()
    Message
      
      -- Testing chattr 
      * Provider: OpenAI - Chat Completions
      * Path/URL: https://api.openai.com/v1/chat/completions
      * Model: gpt-3.5-turbo
      * Label: GPT 3.5 (OpenAI)
      v Connection with OpenAI cofirmed
      |--Prompt: TEST
      |--Response: TEST

# Test function works for LlamaGPT

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
      chattr_test()
    Message
      
      -- Testing chattr 
      * Provider: LlamaGPT
      * Path/URL: ~/LlamaGPTJ-chat/build/bin/chat
      * Model: ~/ggml-gpt4all-j-v1.3-groovy.bin
      * Label: GPT4ALL 1.3 (LlamaGPT)
      v Model started sucessfully
      v Model session closed sucessfully

# Test function works for Copilot

    Code
      chattr_use("copilot")
    Message
      
      -- chattr 
      * Provider: OpenAI - GitHub Copilot Chat
      * Path/URL: https://api.githubcopilot.com/chat/completions
      * Model:
      * Label: Copilot (GitHub)

---

    Code
      chattr_test()
    Message
      
      -- Testing chattr 
      * Provider: OpenAI - GitHub Copilot Chat
      * Path/URL: https://api.githubcopilot.com/chat/completions
      * Model:
      * Label: Copilot (GitHub)
      v Connection with GitHub Copilot cofirmed
      |--Prompt: TEST
      |--Response: TEST

