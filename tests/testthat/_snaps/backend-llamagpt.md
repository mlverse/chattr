# Submit method works

    Code
      ch_submit(def, "test", preview = TRUE)
    Output
      [1] "test(Use the R language, the tidyverse, and tidymodels\n)"

---

    Code
      ch_submit(def, "test", preview = TRUE)
    Output
      [1] "test(Use the R language, the tidyverse, and tidymodels\n)"

# Printout works

    Code
      ch_llamagpt_printout(def, output = "xxx")
    Message
      
      -- chattr --
      
      -- Initializing model 
    Output
      test return

---

    Code
      ch_llamagpt_printout(def, output = "xxx")
    Output
      [1] "test return"

# Args output is correct

    Code
      out
    Output
      [1] "--threads"   "4"           "--temp"      "0.01"        "--n_predict"
      [6] "1000"        "--model"    

# Output works as expected

    Code
      ch_llamagpt_output("tests\n> ", stream = TRUE)
    Output
      tests
      [1] "tests\n"

