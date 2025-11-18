require(shiny)
require(bslib)
require(stringr)
require(lubridate)
require(dplyr)
require(tidyr)
require(ggplot2)
require(munsell)

# Define UI for app that draws a histogram ----
ui <- page_sidebar(
  sidebar = sidebar(open = "open",
    sliderInput("group_1", "Medelvärde för Grupp 1", min = -10, max = 10, value = 0, step = 0.1),
    sliderInput("group_2", "Medelvärde för Grupp 2", min = -10, max = 10, value = 0, step = 0.1),
    sliderInput("group_3", "Medelvärde för Grupp 3", min = -10, max = 10, value = 0, step = 0.1),
    sliderInput("group_4", "Medelvärde för Grupp 4", min = -10, max = 10, value = 0, step = 0.1),
    numericInput("sample_size", "Stickprovsstorlek", value = 30, min = 1, step = 1),
    actionButton("new_sample", "Klicka här för ett nytt urval."),
    uiOutput("variances"),
  ),
  plotOutput("plot", height = "600px")
)

server <- function(input, output, session) {
  data_input <- reactive({
    means <- c(input$group_1, input$group_2, input$group_3, input$group_4)
    seed <- today() + input$new_sample
    set.seed(seed = seed)
    samples <- sapply(means, FUN = function(x) {
        rnorm(n = input$sample_size, mean = x, sd = 1)
    }) %>% 
      as.data.frame()
    data_samples <- pivot_longer(samples, cols = everything()) %>% 
      mutate(
        name = str_replace(name, "V", "Grupp ")
      )
  })
  
  output$plot <- renderPlot({
    data_samples <- data_input()
    sample_means <- aggregate(value ~ name, data_samples, mean)

    ggplot2::ggplot(data = data_samples) + aes(x = value) + 
    geom_histogram(binwidth = 0.25, color = "black", fill = "steelblue") +
    geom_vline(data = sample_means, aes(xintercept = value), linetype = 2, linewidth = 1.2) +
    geom_vline(aes(xintercept = mean(value)), color = "#d9230f", linewidth = 1) +
            scale_x_continuous(breaks = seq(-20, 20, by = 1)) +
            facet_grid(rows = vars(name)) + theme_bw() +
            theme(strip.text.y = element_text(angle = 0, color = "white", size = 14),
                  strip.background.y = element_rect(fill = "black"),
                  axis.title.y = element_blank()) +
            labs(x = "Y") 
  })

  output$variances <- renderUI({
    data_samples <- data_input()
    sample_means <- aggregate(value ~ name, data_samples, mean)
    sample_sizes <- aggregate(value ~ name, data_samples, length)

    SSY <- sum((data_samples$value - mean(data_samples$value))^2)

    SSR <- sum(sample_sizes$value * (sample_means$value - mean(data_samples$value))^2)
    MSR <- SSR/(nrow(sample_means) - 1)

    SSE <- SSY-SSR
    MSE <- SSE/(nrow(data_samples) - nrow(sample_means))
    
    pvalue <- pf(
      round(MSR / MSE, 3), 
      df1 = (nrow(sample_means) - 1), 
      df2 = (nrow(data_samples) - nrow(sample_means)),
      lower.tail = FALSE
    )

    withMathJax(
      paste("$$SSY = ", round(SSY, 3), "\\\\",
            "SSR = ", round(SSR, 3), "\\\\",
            "SSE = ", round(SSE, 3), "\\\\",
            "F_{test} = ", round(MSR / MSE, 3), "\\\\",
            "\\text{p-värde} = ", pvalue %>% round(3), "$$")
    )
  })
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
