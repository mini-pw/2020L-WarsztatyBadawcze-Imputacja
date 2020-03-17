#install.packages("OpenML")
#install.packages("mlr3verse")
#install.packages("corrplot")
library(OpenML)
library(mlr3)
library(data.table)
library(naniar)
library(visdat)
library(ggplot2)
library(dplyr)
library(mice)
library(corrplot)


set.seed(123)
# Pobieranie danych z OpenML\ --------------
# nie działa nwm czemu 
#credit_task_openml <- getOMLDataSet(data.id = 31L)
# credit <- credit_task_openml$data
# head(credit)
# install.packages("fraff")



# Wczytywanie danych ----

dresses_sales <- read.csv("dresses-sales.csv")

# Na początek nadamy właściwe nazwy kolumnom 

colnames(dresses_sales)[1:12] <- c('Style', 'Price', 'Rating', 'Size', 'Season', 'NeckLine',
                                   'SleeveLength', 'waiseline', 'Material', 'FabricType',
                                   'Decoration', 'Pattern')

# Ekspoloracja danych 

summary(dresses_sales)

# Widzimy braki w kolumnach zapisane jako "?" najpierw zastąpie je przez NA 

for (i in (1:length(colnames(dresses_sales)))) {
  d <- ifelse(dresses_sales[,i]=="?",TRUE,FALSE)
  dresses_sales[,i][d] <- NA 
}
# dane zwierają braki jako NA 
gg_miss_upset(dresses_sales)



  
  task = TaskClassif$new(id = "col_remove", backend = dresses_sales, target = "Class")
  
  
  train_set = sample(length(row.names(dresses_sales)), 0.8 * length(row.names(dresses_sales)))
  test_set = setdiff(seq_len(length(row.names(dresses_sales))), train_set)
  learner <- param_search(dresses_sales[train_set,])  
  
  learner$train(task, row_ids = train_set)
  
  # Predykcja
  prediction <- learner$predict(task, row_ids = test_set)
  
  # Miary
  acc <- prediction$score(accuracy)
  pr <- prediction$score(precision)
  pr
  acc
  