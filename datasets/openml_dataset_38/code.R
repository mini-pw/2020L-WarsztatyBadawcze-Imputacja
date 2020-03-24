# libraries
library(OpenML)
library(dplyr)
library(tidyverse)
source('create_summary_json.R')

# config
set.seed(1)
source <- 'openml'


# download data
list_all_openml_dataset <- listOMLDataSets()

openml_id <- 38
data_name <- list_all_openml_dataset[list_all_openml_dataset[,'data.id'] == openml_id,'name']

dataset_openml <- getOMLDataSet(data.id = openml_id)
dataset_raw <- dataset_openml$data
target_column <- dataset_openml$target.features


# preprocessing
## cleaning types of columns, removing columns etc.
dataset <- dataset_raw %>% 
  # drop 'TBG' column: whole is empty
  select(-TBG) %>% 
  # drop observation with missing age: just one in dataset
  drop_na(age)
# drop one observation with age==455
dataset <- dataset[dataset$age!=455,]
  

## create json
file <- CreateSummary(data = dataset, target_column = target_column, id = openml_id, data_name = data_name, source = 'openml', added_by = 'okcze')
write(file, 'dataset.json')
