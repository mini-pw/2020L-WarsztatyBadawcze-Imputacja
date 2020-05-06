## This script covers RandomForest method
# takes in imputed df and target column name

library(caret)
library(scales)
library(wesanderson)
library(randomForest)
library(Metrics)
library(here)

getRFResults <- function(df, target){
  df[[target]] <- factor(ifelse(df[[target]] == df[[target]][1], 1, 0), levels = c(1, 0))
  names(df)[names(df) == target] <- "target_column"
  
  ### splitting
  ind = sample(2, nrow(df), replace=TRUE, prob=c(0.7,0.3))
  df_train <- df[ind==1, ]
  df_test <- df[ind==2, ]
  
  rf_model <- randomForest(target_column ~., data=df_train)
  
  pred_class <- as.numeric(as.character(predict(rf_model, newdata = df_test)))
  true_class <- as.numeric(as.character(df_test$target_column))
  
  acc <- Metrics::accuracy(true_class, pred_class)
  f1 <- Metrics::f1(true_class, pred_class)
  prec <- Metrics::precision(true_class, pred_class)
  rec <- Metrics::recall(true_class, pred_class)
  return(data.frame(acc, f1, prec, rec))
}







# source('./loading_data.R')
# source('./imputing_function.R')
# DS <- loadAllSets()
# 
# df <- DS[[4]][[1]]
# target <- unlist(DS[[4]][2])
# df[[target]] <- factor(ifelse(df[[target]] == df[[target]][1], 1, 0), levels = c(1, 0))
# names(df)[names(df) == target] <- "target_column"
# 
# df <- imputation(df, 3)
# ### splitting
# ind = sample(2, nrow(df), replace=TRUE, prob=c(0.7,0.3))
# df_train <- df[ind==1, ]
# df_test <- df[ind==2, ]
# 
# rf_model <- randomForest(target_column ~., data=df_train)
# 
# pred_class <- as.numeric(as.character(predict(rf_model, newdata = df_test)))
# true_class <- as.numeric(as.character(df_test$target_column))
# 
# Metrics::accuracy(true_class, pred_class)
# Metrics::f1(true_class, pred_class)
# Metrics::precision(true_class, pred_class)
# Metrics::recall(true_class, pred_class)
