read_ames <- function() {
  ames_path <- fs::path_wd("data", "ames", ext = "parquet")
  nanoparquet::read_parquet(ames_path)
}
