# Test function works for GPT 4.1

    Code
      chattr_use("gpt41")
    Message
      
      -- chattr 
      * Provider: OpenAI - Chat Completions
      * Model: gpt-4.1
      * Label: GPT 4.1 (OpenAI)

---

    Code
      chattr_test()
    Message
      
      -- Testing chattr 
      * Provider: OpenAI - Chat Completions
      * Model: gpt-4.1
      * Label: GPT 4.1 (OpenAI)
      v Connection to gpt-4.1 cofirmed
      |--Prompt: TEST
      |--Response: TEST

# chattr_app() runs

    Code
      chattr_test(td)
    Message
      
      -- Testing chattr 
      * Provider: OpenAI - Chat Completions
      * Model: gpt-4.1
      * Label: GPT 4.1 (OpenAI)
      v Connection to gpt-4.1 cofirmed
      |--Prompt: Hi!
      |--Response: [1] "Hi!"

