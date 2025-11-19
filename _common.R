
# Laddar paketet med datamaterialet
suppressMessages({
  require(palmerpenguins, quietly = TRUE)
  require(tidyverse, quietly = TRUE)
  require(plotly, quietly = TRUE)
  require(kableExtra, quietly = TRUE)
  require(ggforce, quietly = TRUE)
  require(olsrr)
  require(nnet)
  require(emmeans)
  require(car)
  require(lme4)
})

utils::data(penguins)

# Filtrerar bort observationer med saknade värden
penguins <- 
  penguins |> 
  dplyr::filter(!is.na(sex))

modelData <- 
  penguins |> 
  select(!c(island, year))

simpleModel <- stats::lm(formula = bill_length_mm ~ ., data = modelData)

options(knitr.kable.NA = '', knitr.table.html.attr = "quarto-disable-processing=true")

senic <- readr::read_csv("resources/data/SENIC.csv") |> 
  dplyr::mutate(Medical_school_affiliation = ifelse(Medical_school_affiliation == 1, 1, 0) |> as.factor()) |> 
  suppressMessages()

weeds <- readr::read_csv2("resources/data/weeds.csv") |> 
  rename(
    metod = 1,
    skörd = 2
  ) |> 
  # Måste säkerställa att den kvalitativa variabeln är en faktor
  mutate(
    metod = as.factor(metod)
  ) |> 
  suppressMessages()

coffee <- readr::read_csv2("resources/data/coffee.csv") |> 
  suppressMessages()

roach <- readr::read_csv2("resources/data/roaches.csv") |> 
  mutate(across(humidity:temperature, ~ as.factor(.x))) |> 
  suppressMessages()

fuel <- readr::read_csv2("resources/data/fuelefficiency.csv") |> 
  mutate(across(car:driver, ~ as.factor(.x))) |> 
  suppressMessages()

prices <- readr::read_csv("resources/data/electricityprice.csv") |> 
  suppressMessages()

consumption <- readr::read_csv2("resources/data/electricityconsumption.csv") |> 
  suppressMessages()

diagnosticPlots <- 
  function(
    model, 
    primaryColor = "steelblue",
    secondaryColor = "firebrick",
    bins = 10, 
    independence = FALSE,
    scaleLocation = FALSE
  ) {
    if (model |> class() != "lm") {
      stop("model must be an lm object")
    }
    if (bins <= 0 | (bins %% 1) > 0) {
      stop("bins must be a positive integer")
    }
    if (!(independence %in% c(TRUE, FALSE))) {
      stop("independence must be a boolean operator")
    }
    if (!(scaleLocation %in% c(TRUE, FALSE))) {
      stop("independence must be a boolean operator")
    }
    
    residualData <- 
      dplyr::tibble(
        residuals = residuals(model),
        # Responsvariabeln finns som första kolumn i modellens model-objekt
        y = model$model[,1],
        yHat = fitted(model)
      )
    
    ## Histogram för kontroll av normalfördelning
    p1 <- 
      ggplot2::ggplot(residualData) + 
      ggplot2::aes(x = residuals, y = ggplot2::after_stat(density)) +
      ggplot2::geom_histogram(bins = bins, fill = primaryColor, color = "black") + 
      ggplot2::theme_bw() + 
      ggplot2::labs(x = "Residualer", y = "Densitet")
    
    ## Spridningsdiagram för kontroll av homoskedasticitet
    p2 <- 
      ggplot2::ggplot(residualData) + 
      ggplot2::aes(x = yHat, y = residuals) + 
      ggplot2::geom_hline(ggplot2::aes(yintercept = 0), color = "black") + 
      ggplot2::geom_point(color = primaryColor) + 
      ggplot2::theme_bw() +
      ggplot2::labs(x = "Anpassade värden", y = "Residualer")
    
    
    ## Kvantildiagram för kontroll av normalfördelning
    p3 <- 
      ggplot2::ggplot(residualData) + 
      ## Använd standardiserade residualer
      ggplot2::aes(sample = scale(residuals)) + 
      ggplot2::geom_qq_line() + 
      ggplot2::geom_qq(color = primaryColor) +
      ggplot2::theme_bw() + 
      ggplot2::labs(x= "Teoretiska kvantiler", y = "Observerade kvantiler")
    
    plotList <- list(p1, p2, p3)
    
    if (independence) {
      p4 <- 
        ggplot2::ggplot(residualData) + 
        ggplot2::aes(x = seq_len(nrow(residualData)), y = scale(residuals)) + 
        ggplot2::geom_hline(ggplot2::aes(yintercept = 0), color = "black") + 
        ggplot2::geom_line(color = primaryColor, linewidth = 1) + 
        ggplot2::theme_bw() + 
        ggplot2::labs(x= "Obs. ordning", y = "Residualer")
      
      plotList <- append(plotList, p4)
    }
    
    if (scaleLocation) {
      p5 <- 
        ggplot2::ggplot(residualData) + 
        ggplot2::aes(x = yHat, y = sqrt(abs(residuals))) + 
        ggplot2::geom_point(color = primaryColor) + 
        ggplot2::theme_bw() +
        ggplot2::labs(x = "Anpassade värden", y = expression(sqrt("|Residualer|")))
      
      plotList <- append(plotList, p5)
    }
    
    cowplot::plot_grid(
      plotlist = plotList,
      nrow = 2
    )
    
  }
