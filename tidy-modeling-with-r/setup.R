library(tidymodels)
library(tidyverse)
tidymodels_prefer()

# if (interactive()) {
#     fs::dir_ls(fs::path_wd("funs")) |>
#         purrr::walk(
#             \(file) {
#                 rlang::inform(glue::glue("Sourcing: {file}"))
#                 source(file)
#             }
#         )
#     ames <- read_ames()
# } else {
#     data(ames)
#     ames <- ames %>% mutate(Sale_Price = log10(Sale_Price))
# }

read_ames <- function() {
  ames_path <- here("data", "ames.parquet")
  nanoparquet::read_parquet(ames_path)
}


set.seed(502)
ames_split <- initial_split(ames, prop = 0.80, strata = Sale_Price)
ames_train <- training(ames_split)
ames_test <- testing(ames_split)

lm_model <- linear_reg() %>% set_engine("lm")
