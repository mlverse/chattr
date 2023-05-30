# Saving defaults work

    Code
      readLines(defaults_file)
    Output
       [1] "default:"                                                                       
       [2] "  prompt: '{readLines(system.file(''prompt/base.txt'', package = ''chattr''))}'"
       [3] "  max_data_files: 20"                                                           
       [4] "  max_data_frames: 20"                                                          
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

