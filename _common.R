
# Laddar paketet med datamaterialet
suppressMessages({
  require(palmerpenguins, quietly = TRUE)
  require(tidyverse, quietly = TRUE)
  require(plotly, quietly = TRUE)
  require(kableExtra, quietly = TRUE)
  require(ggforce, quietly = TRUE)
  require(olsrr)
})

utils::data(penguins)

# Filtrerar bort observationer med saknade värden
penguins <- 
  penguins %>% 
  dplyr::filter(!is.na(sex))

modelData <- 
  penguins %>% 
  select(!c(island, year))

simpleModel <- stats::lm(formula = bill_length_mm ~ ., data = modelData)

options(knitr.kable.NA = '', knitr.table.html.attr = "quarto-disable-processing=true")

senic <- readr::read_csv("resources/data/SENIC.csv") %>% 
  dplyr::mutate(Medical_school_affiliation = ifelse(Medical_school_affiliation == 1, 1, 0) %>% as.factor())


residualPlots <- function(model) {
  
  residualData <- 
    data.frame(
      residuals = residuals(model),
      # Responsvariabeln finns som första kolumn i modellens model-objekt
      y = model$model[,1],
      yHat = fitted(model)
    )
  
  
  p1 <- ggplot2::ggplot(residualData) + 
    ggplot2::aes(x = residuals, y = after_stat(density)) +
    ggplot2::geom_histogram(bins = 20, fill = "steelblue", color = "black") + 
    ggplot2::theme_bw() + 
    ggplot2::labs(x = "Residualer", y = "Densitet")
  
  p2 <- ggplot2::ggplot(residualData) + 
    ggplot2::aes(x = yHat, y = residuals) + 
    ggplot2::geom_hline(aes(yintercept = 0)) + 
    ggplot2::geom_point(color = "steelblue") + 
    ggplot2::theme_bw() +
    ggplot2::labs(x = "Anpassade värden", y = "Residualer")
  
  
  p3 <- ggplot2::ggplot(residualData) + 
    # Använder standardiserade residualer
    ggplot2::aes(sample = scale(residuals)) + 
    ggplot2::geom_qq_line() + 
    ggplot2::geom_qq(color = "steelblue") +
    ggplot2::theme_bw() + 
    ggplot2::labs(x= "Teoretiska kvantiler", y = "Observerade kvantiler")
  
  cowplot::plot_grid(p1, p2, p3, nrow = 2)
  
}
