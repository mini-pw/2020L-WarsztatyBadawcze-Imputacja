# libraries
library(missMDA)
source('create_summary_json.R')

# config
set.seed(1)
source <- 'missMDA'


# download data

id <- 1L
data_name <- 'snorena'

data(snorena)
dataset <- as.data.frame(snorena)
target_column <- 'snore'

## create json
file <- CreateSummary(data = dataset, target_column = target_column, id = id, data_name = data_name, source = source, added_by = 'ejowik')
write(file, 'dataset.json')
