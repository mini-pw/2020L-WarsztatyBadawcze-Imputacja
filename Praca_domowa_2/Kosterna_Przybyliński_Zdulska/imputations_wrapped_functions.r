library(mice)
library(missForest)
library(VIM)

# IMPUTATION FUNCTIONS

imputation_fun_mice <- function(df){
  init <- mice(df, maxit=0) 
  meth <- init$method
  predM <- init$predictorMatrix
  imputed <- mice(df, method=meth, predictorMatrix=predM, m=5)
  completed <- complete(imputed)
  return(completed)
}

imputation_fun_vim <- function(df){
  no_columns <- length(df)
  imputed <- kNN(df)
  imputed <- imputed[,1:no_columns]
  return(imputed)
}

imputation_fun_missForest <- function(df){
  return(missForest(df)$ximp)
}

imputation_remove_rows <- function(df){
  return (na.omit(df))}

# impute median within numeric type columns and mode within character type ones 
imputation_mode_median <- function(df){
  
  Mode <- function(x) {
    ux <- unique(x)
    ux[which.max(tabulate(match(x, ux)))]
  }
  
  for (i in 1L:length(df)){
    if (sum(is.na(df[,i])) > 0){
      if (mode(df[,i]) == 'character' | is.factor(df[,i])){
        to_imp <- Mode(df[,i])
        df[,i][is.na(df[,i])] <- to_imp
      }
      else{
        to_imp <- median(df[,i], na.rm = TRUE) 
        df[,i][is.na(df[,i])] <- to_imp
      }
    }
  }
  
  return(df)
}