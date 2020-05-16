#' Splits dataset into train and test sets, taking into account train size
#' @param dataset dataset to split
#' @param train_size size of train dataset, where 0 - no elements, 1 - all the elements
#' @return lis?, where list[1] - train frame, list[2] - test frame
train_test_split <- function(dataset, train_size){
  smp_size <- floor(train_size * nrow(dataset))
  typeof(smp_size)
  
  train_ind <- sample(seq_len(nrow(dataset)), size = smp_size)
  
  train <- dataset[train_ind, ]
  test <- dataset[-train_ind, ]
  
  return (list(train, test))
}


# METRICS FUNCTIONS

get_confusion_matrix <- function(test, pred){
  return (table(Truth = test, Prediction = pred))
}

confusion_matrix_values <- function(confusion_matrix){
  TP <- confusion_matrix[2,2]
  TN <- confusion_matrix[1,1]
  FP <- confusion_matrix[1,2]
  FN <- confusion_matrix[2,1]
  return (c(TP, TN, FP, FN))
}

accuracy <- function(confusion_matrix){
  conf_matrix <- confusion_matrix_values(confusion_matrix)
  return((conf_matrix[1] + conf_matrix[2]) / (conf_matrix[1] + conf_matrix[2] + conf_matrix[3] + conf_matrix[4]))
}

precision <- function(confusion_matrix){
  conf_matrix <- confusion_matrix_values(confusion_matrix)
  return(conf_matrix[1]/ (conf_matrix[1] + conf_matrix[3]))
}

recall <- function(confusion_matrix){
  conf_matrix <- confusion_matrix_values(confusion_matrix)
  return(conf_matrix[1] / (conf_matrix[1] + conf_matrix[4]))
}

f1 <- function(confusion_matrix){
  conf_matrix <- confusion_matrix_values(confusion_matrix)
  rec <- recall(confusion_matrix)
  prec <- precision(confusion_matrix)
  return(2 * (rec * prec) / (rec + prec))
}