# Saving defaults work

    Code
      chattr_use("gpt41")
    Message
      
      -- chattr 
      * Provider: OpenAI - Chat Completions
      * Model: gpt-4.1
      * Label: GPT 4.1 (OpenAI)

---

    Code
      readLines(defaults_file)
    Output
       [1] "default:"                                                                 
       [2] "  max_data_files: 0"                                                      
       [3] "  max_data_frames: 0"                                                     
       [4] "  include_doc_contents: no"                                               
       [5] "  include_history: no"                                                    
       [6] "  provider: OpenAI - Chat Completions"                                    
       [7] "  path: https://api.openai.com/v1/chat/completions"                       
       [8] "  model: gpt-4.1"                                                         
       [9] "  model_arguments:"                                                       
      [10] "    temperature: 0.01"                                                    
      [11] "    max_tokens: 1000"                                                     
      [12] "    stream: yes"                                                          
      [13] "  system_msg:"                                                            
      [14] "  - '{readLines(system.file(''prompt/base.txt'', package = ''chattr''))}'"
      [15] "  - You are a helpful coding assistant that uses R and the tidyverse"     
      [16] "  label: GPT 4.1 (OpenAI)"                                                
      [17] "  ellmer: ellmer::chat_openai(model = \"gpt-4.1\")"                       
      [18] "  mode: ellmer"                                                           

