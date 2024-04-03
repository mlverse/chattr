# Split content function

    Code
      app_split_content(content)
    Output
      [[1]]
      [[1]]$is_code
      [1] FALSE
      
      [[1]]$content
      [1] "Sure! Here's an example of a scatter plot using the `ggplot2` package:\n\n"
      
      
      [[2]]
      [[2]]$is_code
      [1] TRUE
      
      [[2]]$content
      [1] "```{r}\nlibrary(ggplot2)\n\n# Load data\ndata(mpg)\n\n# Create scatter plot\nggplot(mpg, aes(x = displ, y = hwy)) +\n  geom_point()\n\n```"
      
      
      [[3]]
      [[3]]$is_code
      [1] FALSE
      
      [[3]]$content
      [1] "\n\nThis code creates a scatter plot of `displ` (engine displacement) on the x-axis and `hwy` (highway miles per gallon) on the y-axis using the `mpg` dataset that comes with `ggplot2`. The `geom_point()` function adds points to the plot."
      
      

