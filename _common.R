
# Laddar paketet med datamaterialet
suppressMessages({
  require(palmerpenguins, quietly = TRUE)
  require(tidyverse, quietly = TRUE)
  require(plotly, quietly = TRUE)
  require(kableExtra, quietly = TRUE)
  require(ggforce, quietly = TRUE)
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

options(knitr.kable.NA = '')