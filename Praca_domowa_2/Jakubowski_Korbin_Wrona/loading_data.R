## This scripts is used to load all datasets needed and put them into list

library(OpenML)
library(readr)
library(dplyr)


loadAllSets <- function(){



DS <- list()

#### Dataset 4
# config
set.seed(1)
source <- 'openml'


# download data
list_all_openml_dataset <- listOMLDataSets()

openml_id <- 4L
data_name <- list_all_openml_dataset[list_all_openml_dataset[,'data.id'] == openml_id,'name']

dataset_openml <- getOMLDataSet(data.id = openml_id)
dataset_raw <- dataset_openml$data
target_column <- dataset_openml$target.features


# preprocessing
## usuniÄ™cie kolumny id

dataset <- dataset_raw

DS[['data_set_4']] <- list(dataset, target_column)

#### Dataset 5
# download data
list_all_openml_dataset <- listOMLDataSets()

openml_id <- 27L
data_name <- list_all_openml_dataset[list_all_openml_dataset[,'data.id'] == openml_id,'name']

dataset_openml <- getOMLDataSet(data.id = openml_id)
dataset_raw <- dataset_openml$data
target_column <- dataset_openml$target.features

dataset_raw
# preprocessing
## cleaning types of columns, removing columns etc.
dataset <-dataset_raw[, -c(15, 20,21)]

DS[['data_set_27']] <- list(dataset, target_column)

#### Dataset 29

datasets <- listOMLDataSets()
data_name <- "credit-approval"
openml_id <- datasets[datasets$name == data_name ,]$data.id

data <- getOMLDataSet(data.id= openml_id)
target_column <- data$target.features

df <- data$data

# change ? to NA
for (col in colnames(df)){
  df[col][df[col] == "?"] <- NA
}

# lets see if it did it     -     commented
# str(df)   


change_to_factor <- function(df){
  for (i in seq_along(colnames(df))){
    if (!is.numeric(df[,i])){
      df[,i] <- as.factor(df[,i])
    }
  }
  return(df)
}
df <- change_to_factor(df)

colnames(df) <- c("Sex",
                  "Age",
                  "Debt",
                  "Married",
                  "BankCustomer",
                  "EducationLevel",
                  "Ethicity",
                  "YearsEmployed",
                  "PriorDefault",
                  "Employed",
                  "CreditScore",
                  "Driverslicense",
                  "Citizen",
                  "Zipcode",
                  "Income",
                  "class")

dataset <- df

DS[['data_set_29']] <- list(dataset, target_column)

#### Dataset 38
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
  # drop 'TBG' column: whole is empty, 'TBG_measured' column: has one same value
  select(-TBG, -TBG_measured) %>%
  # change unrealistic age values to NAs
  mutate(age=ifelse(age>123, NA, age))

DS[['data_set_38']] <- list(dataset, target_column)

#### Dataset 55
# download data
list_all_openml_dataset <- listOMLDataSets()

openml_id <- 55
data_name <- list_all_openml_dataset[list_all_openml_dataset[,'data.id'] == openml_id,'name']

dataset_openml <- getOMLDataSet(data.id = openml_id)
dataset_raw <- dataset_openml$data
target_column <- dataset_openml$target.features


# preprocessing no needed
# dataset is clean and ready to impute
dataset <- dataset_raw

DS[['data_set_55']] <- list(dataset, target_column)

#### Dataset 56
# download data
list_all_openml_dataset <- listOMLDataSets()

openml_id <- 56L
data_name <- list_all_openml_dataset[list_all_openml_dataset[,'data.id'] == openml_id,'name']

dataset_openml <- getOMLDataSet(data.id = openml_id)
dataset_raw <- dataset_openml$data
target_column <- dataset_openml$target.features


# preprocessing
## cleaning types of columns, removing columns etc.
# all NA'a are alreay marked, all columns are somewhat balanced and all columns are factors
dataset_raw <- dataset_raw[rowSums(is.na(dataset_raw))<16,]
dataset <- dataset_raw

DS[['data_set_56']] <- list(dataset, target_column)

#### Dataset 188
# download data
list_all_openml_dataset <- listOMLDataSets()

openml_id <- 188L
data_name <- list_all_openml_dataset[list_all_openml_dataset[, 'data.id']==openml_id, 'name']

dataset_openml <- getOMLDataSet(data.id=openml_id)
dataset_raw <- dataset_openml$data
target_column <- dataset_openml$target.features


# preprocessing
## cleaning types of columns, removing columns etc.
dataset <- dataset_raw %>%
  # transform Latitude from degrees and minutes to degrees with fractions
  mutate(Latitude=-as.numeric(substr(Latitude, 1, 2))-as.numeric(substr(Latitude, 5, 6))/60) %>%
  # cast Sp to unordered factor
  mutate(Sp=factor(Sp, levels=unique(Sp), ordered=F)) %>%
  # change unrealistic Latitude values to NAs
  mutate(Latitude=ifelse(Latitude<(-60), NA, Latitude)) %>%
  # change unrealistics DBH values to NAs
  mutate(DBH=ifelse(DBH>100, NA, DBH)) %>%
  # transform problem to binary classification
  mutate(Utility=factor(ifelse(Utility %in% c('best', 'good'), 1, 0), levels=c(1, 0), ordered=F)) %>%
  # drop some columns
  select(-Abbrev, -Rep, -Locality, -Map_Ref)

DS[['data_set_188']] <- list(dataset, target_column)

#### Dataset 944
# download data
list_all_openml_dataset <- listOMLDataSets()

openml_id <- 944
data_name <- list_all_openml_dataset[list_all_openml_dataset[,'data.id'] == openml_id,'name']

dataset_openml <- getOMLDataSet(data.id = openml_id)
dataset_raw <- dataset_openml$data
target_column <- dataset_openml$target.features


# preprocessing no needed
# dataset is clean and ready to impute
dataset <- dataset_raw

DS[['data_set_944']] <- list(dataset, target_column)

#### Dataset 1018
# download data
list_all_openml_dataset <- listOMLDataSets()

openml_id <- 	1018L
data_name <- list_all_openml_dataset[list_all_openml_dataset[,'data.id'] == openml_id,'name']

dataset_openml <- getOMLDataSet(data.id = openml_id)
dataset_raw <- dataset_openml$data
target_column <- dataset_openml$target.features


#Removing year column evary value the same 

dataset_raw <- dataset_raw[,-1]

dataset <- dataset_raw

DS[['data_set_1018']] <- list(dataset, target_column)

#### Dataset 1590
# download data
list_all_openml_dataset <- listOMLDataSets()

openml_id <- 1590L
data_name <- list_all_openml_dataset[list_all_openml_dataset[,'data.id'] == openml_id,'name']

dataset_openml <- getOMLDataSet(data.id = openml_id)
dataset_raw <- dataset_openml$data
target_column <- dataset_openml$target.features


# preprocessing
## cleaning types of columns, removing columns etc.
dataset_raw <- dataset_raw[, -c(3, 5)]
# fnlwgt nic istotnego nie mĂłwi, a education.num jest jednoznaczny z education
dataset_raw[,'age'] <- as.integer(dataset_raw[,'age'])
# wiek jest liczbÄ… caĹ‚kowitÄ…
czynnik <- sapply(dataset_raw, class)=="factor"
for (i in 1:13) if (czynnik[i]){
  dataset_raw[,i] <- tolower(as.character(dataset_raw[,i]))
  if (i==12){
    dataset_raw[!is.na(dataset_raw$native.country) & dataset_raw$native.country=='hong',
                'native.country'] <- 'hong-kong'
    dataset_raw[!is.na(dataset_raw$native.country) & dataset_raw$native.country=='holand-netherlands',
                'native.country'] <- 'netherlands'
    dataset_raw[!is.na(dataset_raw$native.country) & dataset_raw$native.country=='trinadad&tobago',
                'native.country'] <- 'trinidad&tobago'
  }
  dataset_raw[,i] <- factor(dataset_raw[,i],
                            levels=unique(dataset_raw[,i]),
                            ordered=F)
}
# konwersja czynnikĂłw do maĹ‚ych liter i poprawa niektĂłrych nazw
dataset_raw[,'relationship'] <- as.character(dataset_raw[,'relationship'])
dataset_raw[dataset_raw$relationship %in% c("husband", "wife"),'relationship'] <- "married"
dataset_raw[,'relationship'] <- factor(dataset_raw[,'relationship'],
                                       levels=unique(dataset_raw[,'relationship']),
                                       ordered=F)
# "husband" i "wife" moĹĽna sprowadziÄ‡ do jednej kategorii "married", poniewaĹĽ mamy juĹĽ gdzie indziej okreĹ›lonÄ… pĹ‚eÄ‡;
# zdarzaĹ‚y siÄ™ oczywiĹ›cie bardzo nieliczne przypadki "husband"/"female" (raz) i "wife"/"male" (trzy razy),
# ale moĹĽna je interpretowaÄ‡ np. jako posiadanie mÄ™ĹĽa zamiast bycia mÄ™ĹĽem
dataset <- dataset_raw

DS[['data_set_1590']] <- list(dataset, target_column)

#### Dataset 6332
# download data
list_all_openml_dataset <- listOMLDataSets()

openml_id <- list_all_openml_dataset[list_all_openml_dataset$name == 'cylinder-bands', 'data.id']
dataset_openml <- getOMLDataSet(data.id = openml_id)
data <- dataset_openml$data
target_column <- dataset_openml$target.features

# preprocessing
## encode missing data with the appropriate symbol
data[data == "?"] <- NA 

## getting rid of irrelevant columns
data <- data[, -c(2,6,8,9,12,23)] 

## Label-encoding
df <- data

label_cols <- c('customer', 'paper_type', 'ink_type', 'solvent_type', 'press_type', 'cylinder_size', 'paper_mill_location', 'grain_screened', 'proof_on_ctd_ink', 'type_on_cylinder')
for (col in label_cols){
  df[, col] <- as.numeric(df[, col])
  df[which(is.na(data[, col]), arr.ind = TRUE), col] <- NA
  df[, col] <- as.factor(df[,col])
}

## Types conversion
df$job_number <- as.factor(df$job_number)
to_numeric <- c('ink_temperature', 'roughness', 'varnish_pct', 'solvent_pct', 'ink_pct', 'wax', 'hardener', 'anode_space_ratio')
to_integer <- c('blade_pressure', 'proof_cut', 'viscosity', 'ESA_Voltage', 'roller_durometer', 'current_density', 'chrome_content', 'humifity', 'press_speed')

for (col in to_numeric){
  df[, col] <- as.numeric(df[, col])
}

for (col in to_integer) {
  df[, col] <- as.integer(df[, col])
}

dataset <- df

DS[['data_set_6332']] <- list(dataset, target_column)

#### Dataset 23381
# download data
list_all_openml_dataset <- listOMLDataSets()

openml_id <- 	23381L
data_name <- list_all_openml_dataset[list_all_openml_dataset[,'data.id'] == openml_id,'name']

dataset_openml <- getOMLDataSet(data.id = openml_id)
dataset_raw <- dataset_openml$data
target_column <- dataset_openml$target.features


# preprocessing
## cleaning types of columns, removing columns etc.
colnames(dataset_raw)[1:12] <- c('Style', 'Price', 'Rating', 'Size', 'Season', 'NeckLine',
                                 'SleeveLength', 'waiseline', 'Material', 'FabricType',
                                 'Decoration', 'Pattern')
# To lower 
zmienne <- c('Style', 'Price', 'Size', 'Season', 'NeckLine',
             'SleeveLength', 'waiseline', 'Material', 'FabricType',
             'Decoration', 'Pattern')
for (i in zmienne){
  dataset_raw[,i] <- tolower(dataset_raw[,i])
}

dataset_raw$Season <- ifelse(dataset_raw$Season=='automn','autumn',dataset_raw$Season)

d <- ifelse(dataset_raw$Rating==0,TRUE,FALSE)
dataset_raw$Rating[d] <- NA

for (i in zmienne){
  dataset_raw[,i] <- as.factor(dataset_raw[,i])
}

dataset <- dataset_raw

DS[['data_set_23381']] <- list(dataset, target_column)

#### Dataset 40536
# download data
list_all_openml_dataset <- listOMLDataSets()

openml_id <- 40536L
data_name <- list_all_openml_dataset[list_all_openml_dataset[, 'data.id']==openml_id, 'name']

dataset_openml <- getOMLDataSet(data.id=openml_id)
dataset_raw <- dataset_openml$data
target_column <- dataset_openml$target.features

# preprocessing
## cleaning types of columns
dataset <- dataset_raw
dataset$d_age[is.na(dataset$age) | is.na(dataset$age_o)] <- NA

DS[['data_set_40536']] <- list(dataset, target_column)

#### Dataset 41278
# download data
list_all_openml_dataset <- listOMLDataSets()

openml_id <- 41278L
data_name <- list_all_openml_dataset[list_all_openml_dataset[,'data.id'] == openml_id,'name']

dataset_openml <- getOMLDataSet(data.id = openml_id)
dataset_raw <- dataset_openml$data
target_column <- dataset_openml$target.features


# preprocessing
## cleaning types of columns, removing columns etc.

## usuniÄ™cie kolumny z datÄ… (typu character) - last_online.
dataset_raw <- dataset_raw[,-11]

## usuniÄ™cie wszystkich rekordĂłw opisujÄ…cych studentĂłw, dziÄ™ki czemu target (job) bÄ™dzie mieÄ‡ tylko dwa poziomy
dataset_raw <- dataset_raw%>%filter(job!="student")
dataset <- dataset_raw

DS[['data_set_41278']] <- list(dataset, target_column)


#### RETURN
return(DS)
}


