# Data frames context

    Code
      .
    Output
      Data frames currently in R memory (and columns): 
      |--  iris (Sepal.Length, Sepal.Width, Petal.Length, Petal.Width, Species) 
      |--  mtcars (mpg, cyl, disp, hp, drat, wt, qsec, vs, am, gear, carb)

---

    Code
      .
    Output
      Data frames currently in R memory (and columns): 
      |--  iris (Sepal.Length, Sepal.Width, Petal.Length, Petal.Width, Species)

# File finder works

    Code
      ch_context_data_files(file_types = "R")
    Output
      [1] "Data files available: \n|- helper-utils.R\n|- setup.R\n|- test-app_server.R\n|- test-app_ui.R\n|- test-backend-llamagpt.R\n|- test-backend-openai.R\n|- test-ch-defaults-save.R\n|- test-ch_context.R\n|- test-ch_defaults.R\n|- test-chattr-app.R\n|- test-chattr-test.R\n|- test-chattr-use.R\n|- test-chattr.R\n|- test-ide.R\n|- test-utils.R"

---

    Code
      ch_context_data_files(max = 2, file_types = "R")
    Output
      [1] "Data files available: \n|- helper-utils.R\n|- setup.R"

