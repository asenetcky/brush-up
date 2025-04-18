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

# read_ames <- function() {
#   ames_path <- here("data", "ames.parquet")
#   nanoparquet::read_parquet(ames_path)
# }

# ames <- read_ames()

data(ames)
ames <- ames %>% mutate(Sale_Price = log10(Sale_Price))

set.seed(502)
ames_split <- initial_split(ames, prop = 0.80, strata = Sale_Price)
ames_train <- training(ames_split)
ames_test <- testing(ames_split)

ames_rec <-
  recipe(
    Sale_Price ~
      Neighborhood +
        Gr_Liv_Area +
        Year_Built +
        Bldg_Type +
        Latitude +
        Longitude,
    data = ames_train
  ) |>
  step_log(Gr_Liv_Area, base = 10) |>
  step_other(Neighborhood, threshold = 0.01) |>
  step_dummy(all_nominal_predictors()) |>
  step_interact(~ Gr_Liv_Area:starts_with("Bldg_Type_")) |>
  step_ns(Latitude, Longitude, deg_free = 20)

lm_model <- linear_reg() |> set_engine("lm")

lm_wflow <-
  workflow() |>
  add_model(lm_model) |>
  add_recipe(ames_rec)

lm_fit <- fit(lm_wflow, ames_train)
