# libraries
library(OpenML)
source('create_summary_json.R')

# config
set.seed(1)
source <- 'openml'


# download data
list_all_openml_dataset <- listOMLDataSets()

openml_id <- 31L
data_name <- list_all_openml_dataset[list_all_openml_dataset[,'data.id'] == openml_id,'name']

dataset_openml <- getOMLDataSet(data.id = openml_id)
dataset_raw <- dataset_openml$data
target_column <- dataset_openml$target.features


# preprocessing
## cleaning types of columns, removing columns etc.
dataset_raw[,'installment_commitment'] <- as.factor(dataset_raw[,'installment_commitment'])
dataset_raw[,'purpose'] <- tolower(dataset_raw[,'purpose'])
dataset <- dataset_raw[, -4]


## create json
## CreateSummary(data = dataset, target_column = target_column, id = openml_id, data_name = data_name, source = 'openml', added_by = 'woznicak)

