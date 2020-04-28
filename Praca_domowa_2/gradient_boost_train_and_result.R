## This script covers XGBoost method
# takes in imputed df and target column name

library(rsample)
library(caret)
library(scales)
library(wesanderson)
library(gbm)
library(Metrics)
library(here)

getGDBRestults <- function(df, target){
  df[[target]] <- ifelse(df[[target]] == df[[target]][1], 1, 0)
  names(df)[names(df) == target] <- "target_column"
  
  ### splitting
  ind = sample(2, nrow(df), replace=TRUE, prob=c(0.7,0.3))
  df_train <- df[ind==1, ]
  df_test <- df[ind==2, ]
  
  gbm.model <- gbm::gbm(target_column ~., data = df_train, cv.folds=3)
  best.iter = gbm.perf(gbm.model, method = 'cv')
  
  preds <- predict(gbm.model, newdata = df_test, n.trees = best.iter, type = 'response')
  pred_class <- ifelse(preds>=0.5, 1, 0)
  
  acc <- Metrics::accuracy(df_test$target_column, pred_class)
  f1 <- Metrics::f1(df_test$target_column, pred_class)
  prec <- Metrics::precision(df_test$target_column, pred_class)
  rec <- Metrics::recall(df_test$target_column, pred_class)
  return(data.frame(acc, f1, prec, rec))
}

# source('./loading_data.R')
# source('./imputing_function.R')
# DS <- loadAllSets()
# 
# df <- DS[[4]][[1]]
# target <- unlist(DS[[4]][2])
# df[[target]] <- ifelse(df[[target]] == df[[target]][1], 1, 0)
# names(df)[names(df) == target] <- "target_column"
# 
# df <- imputation(df, 2)
# ### splitting
# data_split <- initial_split(df, prop = .7)
# df_train <- training(data_split)
# df_test <- testing(data_split)
# 
# gbm.model <- gbm::gbm(target_column ~., data = df_train, cv.folds=3)
# best.iter = gbm.perf(gbm.model, method = 'cv')
# 
# preds <- predict(gbm.model, newdata = df_test, n.trees = best.iter, type = 'response')
# pred_class <- ifelse(preds>=0.5, 1, 0)
# Metrics::accuracy(df_test$target_column, pred_class)
# Metrics::f1(df_test$target_column, pred_class)
# Metrics::auc(df_test$target_column, preds)
# Metrics::precision(df_test$target_column, pred_class)
# Metrics::recall(df_test$target_column, pred_class)
