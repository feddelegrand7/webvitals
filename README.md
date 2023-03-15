
# webvitals

<!-- badges: start -->
[![](https://img.shields.io/badge/devel%20version-0.1.0-orange.svg)](https://github.com/webvitals)
<!-- badges: end -->

The goal of `webvitals` is to provide the following metrics which can be used to monitor a Shiny app's performance:

- [FID](https://web.dev/fid/)
- [LCP](https://web.dev/lcp/)
- [CLS](https://web.dev/cls/)

## Installation

You can install the development version of the package with: 
``` r
devtools::install_github("feddelegrand7/webvitals")
```

## Example

- The `webvitals` package is a wrapper of the [web-vitals.iife](https://github.com/GoogleChrome/web-vitals) `JavaScript` library from `Google Chrome`. 

- The package has only one function called `implement_webvitals`, which must be implemented in the UI of a `Shiny Application`. The function takes four parameters: 

* `FID_id`: the ID of the FID observer that will be collected in your server
* `LCP_id`: the ID of the LCP observer that will be collected in your server
* `CLS_id`: the ID of the CLS observer that will be collected in your server
* `wait_to_get_info`: Given the fact that some metrics can only be fetched when the user interacts with the app, it is not possible to get the metrics at starting time. Therefore, the `wait_to_get_info` will schedule the collection of the metrics after a specific amount of time (in milliseconds) without blocking the thread of your browser. 

- __The package aims to provide the web-vitals metrics but only provide, what you do at the end with the values depends on you. This is deliberate in the sense that the packages aims to provide the flexibility to the users to do whatever they want with the collected metrics. Either write them in a CSV file, in a table in the data base, as JSON file or any other possible format.__

A very simple implementation will look like this: 

``` r

ui <- shiny::fluidPage(

  webvitals::implement_webvitals(
    FID_id = "fid",
    LCP_id = "lcp",
    CLS_id = "cls",
    wait_to_get_info = 10000 # give your time to your app to collect the metrics
  ),

  shiny::h1("The title, the amazing title"),

  shiny::plotOutput(outputId = "plt1"),

  shiny::actionButton("click", "Click me"),

  shiny::tableOutput(outputId = "tbl1")

)

server <- function(input, output, session) {


  output$plt1 <- shiny::renderPlot({

    ggplot2::ggplot(mtcars, ggplot2::aes(x = mpg)) +
      ggplot2::geom_histogram()

  })


  output$tbl1 <- shiny::renderTable({

    head(mtcars)

  })

  observeEvent(input$fid, {
    
    print(input$fid)
    
    # Do whatever you want with the returned list 
    
  })

  observeEvent(input$lcp, {
  
    print(input$lcp)
    
    # Do whatever you want with the returned list 
  
  })

  observeEvent(input$cls, {
    
    print(input$cls)
    
    # Do whatever you want with the returned list 


  })

}


shiny::shinyApp(ui = ui, server = server)


```

