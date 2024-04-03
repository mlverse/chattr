# Set to GPT3.5

    Code
      chattr_use("gpt35")
    Message
      
      -- chattr 
      * Provider: OpenAI - Chat Completions
      * Path/URL: https://api.openai.com/v1/chat/completions
      * Model: gpt-3.5-turbo
      * Label: GPT 3.5 (OpenAI)

# UI output is as expected

    Code
      out
    Output
       [1] "<div class=\"container-fluid\" responsive=\"FALSE\">"                                                                                                                                                                                                                                                                                                                                                                                                                               
       [2] "  <style type=\"text/css\">.form-control {font-size: 80%;margin-left: 8px;padding: 5px;}.form-group {padding: 1px; margin: 1px;}.checkbox {font-size: 70%; padding: 1px}.shiny-tab-input {border-width: 0px;}.col-sm-11 {margin: 0px; padding-left: 5px; padding-right: 5px;}.col-sm-10 {margin: 0px; padding-left: 0px; padding-right: 0px;}.col-sm-2 {margin: 0px; padding-left: 0px; padding-right: 0px;}.col-sm-1 {margin: 0px; padding-left: 7px; padding-right: 0px;}</style>"
       [3] "  <button id=\"close\" type=\"button\" class=\"btn btn-default action-button\" style=\"font-size: 55%;padding-top: 3px;padding-bottom: 3px;padding-left: 5px;padding-right: 5px;color: #fff;background-color: #f1f6f8;\"></button>"                                                                                                                                                                                                                                                 
       [4] "  <div style=\"top:0px;left:0.1px;width:100%;position:fixed;cursor:inherit; z-index: 10;background-color: #242B31;\">"                                                                                                                                                                                                                                                                                                                                                              
       [5] "    <div class=\"row\">"                                                                                                                                                                                                                                                                                                                                                                                                                                                            
       [6] "      <div class=\"col-sm-11\" style=\"width: 85%;\">"                                                                                                                                                                                                                                                                                                                                                                                                                              
       [7] "        <div class=\"form-group shiny-input-container\" style=\"width: 100%;\">"                                                                                                                                                                                                                                                                                                                                                                                                    
       [8] "          <label class=\"control-label shiny-label-null\" for=\"prompt\" id=\"prompt-label\"></label>"                                                                                                                                                                                                                                                                                                                                                                              
       [9] "          <textarea id=\"prompt\" class=\"shiny-input-textarea form-control\" style=\"width:100%;resize:none;\"></textarea>"                                                                                                                                                                                                                                                                                                                                                        
      [10] "        </div>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
      [11] "      </div>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
      [12] "      <div class=\"col-sm-1\" style=\"width: 15%;\">"                                                                                                                                                                                                                                                                                                                                                                                                                               
      [13] "        <button id=\"submit\" type=\"button\" class=\"btn btn-default action-button\" style=\"font-size: 55%;padding-top: 3px;padding-bottom: 3px;padding-left: 5px;padding-right: 5px;color: #fff;background-color: #f1f6f8;\">Submit</button>"                                                                                                                                                                                                                                    
      [14] "        <button id=\"options\" type=\"button\" class=\"btn btn-default action-button\" style=\"font-size: 55%;padding-top: 3px;padding-bottom: 3px;padding-left: 5px;padding-right: 5px;color: #fff;background-color: #f1f6f8;\">"                                                                                                                                                                                                                                                  
      [15] "          <i class=\"fas fa-gear\" role=\"presentation\" aria-label=\"gear icon\"></i>"                                                                                                                                                                                                                                                                                                                                                                                             
      [16] "        </button>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
      [17] "        <br/>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
      [18] "        <div style=\"font-size:9px; color:#f1f6f8;\">"                                                                                                                                                                                                                                                                                                                                                                                                                              
      [19] "          <div id=\"provider\" class=\"shiny-html-output\"></div>"                                                                                                                                                                                                                                                                                                                                                                                                                  
      [20] "        </div>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
      [21] "      </div>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
      [22] "    </div>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
      [23] "  </div>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
      [24] "  <div style=\"top:52px;left:1%;width:98%;position:absolute;cursor:inherit;\">"                                                                                                                                                                                                                                                                                                                                                                                                     
      [25] "    <div class=\"tabbable\">"                                                                                                                                                                                                                                                                                                                                                                                                                                                       
      [26] "    </div>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
      [27] "  </div>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
      [28] "</div>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                             

# UI modal output is as expected

    Code
      capture.output(app_ui_modal())
    Output
       [1] "<div class=\"modal fade\" id=\"shiny-modal\" tabindex=\"-1\">"                                                                                                                                                                                 
       [2] "  <div class=\"modal-dialog\">"                                                                                                                                                                                                                
       [3] "    <div class=\"modal-content\">"                                                                                                                                                                                                             
       [4] "      <div class=\"modal-body\">"                                                                                                                                                                                                              
       [5] "        <p>Save / Load Chat</p>"                                                                                                                                                                                                               
       [6] "        <hr/>"                                                                                                                                                                                                                                 
       [7] "        <div class=\"form-group shiny-input-container\">"                                                                                                                                                                                      
       [8] "          <label class=\"control-label\" id=\"prompt2-label\" for=\"prompt2\">Prompt</label>"                                                                                                                                                  
       [9] "          <textarea id=\"prompt2\" class=\"shiny-input-textarea form-control\">Use the 'Tidy Modeling with R' (https://www.tmwr.org/) book as main reference"                                                                                  
      [10] "Use the 'R for Data Science' (https://r4ds.had.co.nz/) book as main reference"                                                                                                                                                                 
      [11] "Use tidyverse packages: readr, ggplot2, dplyr, tidyr"                                                                                                                                                                                          
      [12] "For models, use tidymodels packages: recipes, parsnip, yardstick, workflows, broom"                                                                                                                                                            
      [13] "Avoid explanations unless requested by user, expecting code only"                                                                                                                                                                              
      [14] "For code output, use RMarkdown code chunks"                                                                                                                                                                                                    
      [15] "Avoid all code chunk options</textarea>"                                                                                                                                                                                                       
      [16] "        </div>"                                                                                                                                                                                                                                
      [17] "        <br/>"                                                                                                                                                                                                                                 
      [18] "        <div class=\"form-group shiny-input-container\">"                                                                                                                                                                                      
      [19] "          <label class=\"control-label\" id=\"i_data-label\" for=\"i_data\">Max Data Frames</label>"                                                                                                                                           
      [20] "          <input id=\"i_data\" type=\"text\" class=\"shiny-input-text form-control\" value=\"0\"/>"                                                                                                                                            
      [21] "        </div>"                                                                                                                                                                                                                                
      [22] "        <div class=\"form-group shiny-input-container\">"                                                                                                                                                                                      
      [23] "          <label class=\"control-label\" id=\"i_files-label\" for=\"i_files\">Max Data Files</label>"                                                                                                                                          
      [24] "          <input id=\"i_files\" type=\"text\" class=\"shiny-input-text form-control\" value=\"0\"/>"                                                                                                                                           
      [25] "        </div>"                                                                                                                                                                                                                                
      [26] "        <div class=\"form-group shiny-input-container\">"                                                                                                                                                                                      
      [27] "          <div class=\"checkbox\">"                                                                                                                                                                                                            
      [28] "            <label>"                                                                                                                                                                                                                           
      [29] "              <input id=\"i_history\" type=\"checkbox\" class=\"shiny-input-checkbox\" checked=\"checked\"/>"                                                                                                                                  
      [30] "              <span>Include Chat History</span>"                                                                                                                                                                                               
      [31] "            </label>"                                                                                                                                                                                                                          
      [32] "          </div>"                                                                                                                                                                                                                              
      [33] "        </div>"                                                                                                                                                                                                                                
      [34] "        <button id=\"saved\" type=\"button\" class=\"btn btn-default action-button\" style=\"padding-top: 4px;padding-bottom: 4px;padding-left: 10px;padding-right: 10px;font-size: 60%;color: #fff;background-color: #f1f6f8;\">Save</button>"
      [35] "      </div>"                                                                                                                                                                                                                                  
      [36] "      <div class=\"modal-footer\"></div>"                                                                                                                                                                                                      
      [37] "    </div>"                                                                                                                                                                                                                                    
      [38] "  </div>"                                                                                                                                                                                                                                      
      [39] "  <script>if (window.bootstrap && !window.bootstrap.Modal.VERSION.match(/^4\\./)) {"                                                                                                                                                           
      [40] "         var modal = new bootstrap.Modal(document.getElementById('shiny-modal'));"                                                                                                                                                             
      [41] "         modal.show();"                                                                                                                                                                                                                        
      [42] "      } else {"                                                                                                                                                                                                                                
      [43] "         $('#shiny-modal').modal().focus();"                                                                                                                                                                                                   
      [44] "      }</script>"                                                                                                                                                                                                                              
      [45] "</div>"                                                                                                                                                                                                                                        

# UI entry for assistant reponse works as expected

    Code
      capture.output(app_ui_entry("test", TRUE, 1))
    Output
       [1] "<div class=\"row\" style=\"margin: 0px;padding: 0px;font-size: 80%;color: #000;background-color: #3E4A56;border-color: #fff;\">"                                                                                                    
       [2] "  <div class=\"col-sm-12\">"                                                                                                                                                                                                        
       [3] "    <div class=\"row\" align=\"right\">"                                                                                                                                                                                            
       [4] "      <div class=\"col-sm-10\" style=\"width: 80%;\">"                                                                                                                                                                              
       [5] "        <div></div>"                                                                                                                                                                                                                
       [6] "      </div>"                                                                                                                                                                                                                       
       [7] "      <div class=\"col-sm-2\" style=\"padding: 0px width: 20%;\">"                                                                                                                                                                  
       [8] "        <div style=\"display:inline-block\" title=\"Copy to clipboard\">"                                                                                                                                                           
       [9] "          <button id=\"copy1\" type=\"button\" class=\"btn btn-default action-button\" style=\"padding-top: 4px;padding-bottom: 4px;padding-left: 10px;padding-right: 10px;font-size: 60%;color: #fff;background-color: #f1f6f8;\">"
      [10] "            <i class=\"far fa-clipboard\" role=\"presentation\" aria-label=\"clipboard icon\"></i>"                                                                                                                                 
      [11] "            "                                                                                                                                                                                                                       
      [12] "          </button>"                                                                                                                                                                                                                
      [13] "        </div>"                                                                                                                                                                                                                     
      [14] "        <div style=\"display:inline-block\" title=\"Send to document\">"                                                                                                                                                            
      [15] "          <button id=\"doc1\" type=\"button\" class=\"btn btn-default action-button\" style=\"padding-top: 4px;padding-bottom: 4px;padding-left: 10px;padding-right: 10px;font-size: 60%;color: #fff;background-color: #f1f6f8;\">" 
      [16] "            <i class=\"far fa-file\" role=\"presentation\" aria-label=\"file icon\"></i>"                                                                                                                                           
      [17] "            "                                                                                                                                                                                                                       
      [18] "          </button>"                                                                                                                                                                                                                
      [19] "        </div>"                                                                                                                                                                                                                     
      [20] "        <div style=\"display:inline-block\" title=\"New script\">"                                                                                                                                                                  
      [21] "          <button id=\"new1\" type=\"button\" class=\"btn btn-default action-button\" style=\"padding-top: 4px;padding-bottom: 4px;padding-left: 10px;padding-right: 10px;font-size: 60%;color: #fff;background-color: #f1f6f8;\">" 
      [22] "            <i class=\"fas fa-plus\" role=\"presentation\" aria-label=\"plus icon\"></i>"                                                                                                                                           
      [23] "            "                                                                                                                                                                                                                       
      [24] "          </button>"                                                                                                                                                                                                                
      [25] "        </div>"                                                                                                                                                                                                                     
      [26] "      </div>"                                                                                                                                                                                                                       
      [27] "    </div>"                                                                                                                                                                                                                         
      [28] "    <div class=\"row\">"                                                                                                                                                                                                            
      [29] "      <div class=\"col-sm-12\"><p>test</p>"                                                                                                                                                                                         
      [30] "</div>"                                                                                                                                                                                                                             
      [31] "    </div>"                                                                                                                                                                                                                         
      [32] "  </div>"                                                                                                                                                                                                                           
      [33] "</div>"                                                                                                                                                                                                                             

---

    Code
      capture.output(app_ui_entry("test", FALSE, 2))
    Output
       [1] "<div class=\"row\" style=\"margin: 0px;padding: 0px;font-size: 80%;color: #000;background-color: #3E4A56;border-color: #fff;\">"
       [2] "  <div class=\"col-sm-12\">"                                                                                                    
       [3] "    <div class=\"row\" align=\"right\">"                                                                                        
       [4] "      <div class=\"col-sm-10\" style=\"width: 80%;\">"                                                                          
       [5] "        <div></div>"                                                                                                            
       [6] "      </div>"                                                                                                                   
       [7] "      <div class=\"col-sm-2\" style=\"padding: 0px width: 20%;\"></div>"                                                        
       [8] "    </div>"                                                                                                                     
       [9] "    <div class=\"row\">"                                                                                                        
      [10] "      <div class=\"col-sm-12\"><p>test</p>"                                                                                     
      [11] "</div>"                                                                                                                         
      [12] "    </div>"                                                                                                                     
      [13] "  </div>"                                                                                                                       
      [14] "</div>"                                                                                                                         
