# Saving defaults work

    Code
      chattr_use("gpt35")
    Message <cliMessage>
      * Provider: Open AI - Chat Completions
      * Path/URL: https://api.openai.com/v1/chat/completions
      * Model: gpt-3.5-turbo

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
       [7] "  provider: Open AI - Chat Completions"                                         
       [8] "  path: https://api.openai.com/v1/chat/completions"                             
       [9] "  model: gpt-3.5-turbo"                                                         
      [10] "  model_arguments:"                                                             
      [11] "    temperature: 0.01"                                                          
      [12] "    max_tokens: 1000"                                                           
      [13] "    stream: yes"                                                                
      [14] "  system_msg: You are a helpful coding assistant"                               
      [15] "chat:"                                                                          
      [16] "  prompt:"                                                                      
      [17] "  - '{readLines(system.file(''prompt/base.txt'', package = ''chattr''))}'"      
      [18] "  - For code output, use RMarkdown code chunks"                                 
      [19] "  - Avoid all code chunk options"                                               
      [20] "script:"                                                                        
      [21] "  prompt:"                                                                      
      [22] "  - '{readLines(system.file(''prompt/base.txt'', package = ''chattr''))}'"      
      [23] "  - Prefix ALL explanations with a pound sign"                                  
      [24] "  - Keep each line of explanations to no more than 80 characters"               
      [25] "  - DO NOT use Markdown for the code"                                           

