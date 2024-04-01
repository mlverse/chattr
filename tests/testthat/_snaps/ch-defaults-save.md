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
      [16] "  mode: gpt35"                                                                  
      [17] "console:"                                                                       
      [18] "  prompt:"                                                                      
      [19] "  - '{readLines(system.file(''prompt/base.txt'', package = ''chattr''))}'"      
      [20] "  - 'For any line that is not code, prefix with a: #'"                          
      [21] "  - Keep each line of explanations to no more than 80 characters"               
      [22] "  - DO NOT use Markdown for the code"                                           
      [23] "chat:"                                                                          
      [24] "  prompt:"                                                                      
      [25] "  - '{readLines(system.file(''prompt/base.txt'', package = ''chattr''))}'"      
      [26] "  - For code output, use RMarkdown code chunks"                                 
      [27] "  - Avoid all code chunk options"                                               
      [28] "script:"                                                                        
      [29] "  prompt:"                                                                      
      [30] "  - '{readLines(system.file(''prompt/base.txt'', package = ''chattr''))}'"      
      [31] "  - 'For any line that is not code, prefix with a: #'"                          
      [32] "  - Keep each line of explanations to no more than 80 characters"               
      [33] "  - DO NOT use Markdown for the code"                                           

