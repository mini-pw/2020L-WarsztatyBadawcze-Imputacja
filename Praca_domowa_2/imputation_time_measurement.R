## This script contains a function for time measurements of imputation techniques

library(microbenchmark)
library(OpenML)
library(dplyr)
source('./imputing_function.R')


measureImputationTime <- function(df, number_of_tests){
  measured <- microbenchmark::microbenchmark(
    removing = imputation(df, 1),
    mean_med_modal = imputation(df, 2),
    IRMI_VIM = imputation(df, 3),
    mice = imputation(df, 4),
    missForest = imputation(df, 5),
    times = number_of_tests
  )
  mean_times <- measured %>%
                group_by(expr) %>%
                summarize(mean_time = mean(time))
  return(mean_times)
}
