# Request submission works

    Code
      out$gpt41
    Output
      [1] "OpenAI - Chat Completions - gpt-4.1 (gpt41) \n"

---

    Code
      out$gpt4o
    Output
      [1] "OpenAI - Chat Completions - gpt-4o (gpt4o) \n"

# Invalid label returns expected error

    [ENOENT] Failed to search directory 'inst/configs': no such file or directory

# Uses ellmer object

    Code
      chattr_use(my_model)
    Message
      
      -- chattr 
      * Provider: ellmer
      * Model: claude-3-5-sonnet-latest

