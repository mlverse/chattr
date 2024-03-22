# Saving defaults work

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
      readLines(defaults_file)
    Output
       [1] "default:"                                                                       
       [2] "  prompt: '{readLines(system.file(''prompt/base.txt'', package = ''chattr''))}'"
       [3] "  max_data_files: 0"                                                            
       [4] "  max_data_frames: 0"                                                           
       [5] "  include_doc_contents: no"                                                     
       [6] "  include_history: yes"                                                         
       [7] "  provider: OpenAI - Chat Completions"                                          
       [8] "  path: https://api.openai.com/v1/chat/completions"                             
       [9] "  model: gpt-3.5-turbo"                                                         
      [10] "  model_arguments:"                                                             
      [11] "    temperature: 0.01"                                                          
      [12] "    max_tokens: 1000"                                                           
      [13] "    stream: yes"                                                                
      [14] "  system_msg: You are a helpful coding assistant"                               
      [15] "  label: GPT 3.5 (OpenAI)"                                                      
      [16] "console:"                                                                       
      [17] "  prompt:"                                                                      
      [18] "  - '{readLines(system.file(''prompt/base.txt'', package = ''chattr''))}'"      
      [19] "  - 'For any line that is not code, prefix with a: #'"                          
      [20] "  - Keep each line of explanations to no more than 80 characters"               
      [21] "  - DO NOT use Markdown for the code"                                           
      [22] "chat:"                                                                          
      [23] "  prompt:"                                                                      
      [24] "  - '{readLines(system.file(''prompt/base.txt'', package = ''chattr''))}'"      
      [25] "  - For code output, use RMarkdown code chunks"                                 
      [26] "  - Avoid all code chunk options"                                               
      [27] "script:"                                                                        
      [28] "  prompt:"                                                                      
      [29] "  - '{readLines(system.file(''prompt/base.txt'', package = ''chattr''))}'"      
      [30] "  - 'For any line that is not code, prefix with a: #'"                          
      [31] "  - Keep each line of explanations to no more than 80 characters"               
      [32] "  - DO NOT use Markdown for the code"                                           

