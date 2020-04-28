library(VIM)
library(mice)
library(missForest)
imputacja <- function(df, num){
  # 1: usuwanie kolumn
  # 2: uzupełnianie średnią (zmienna numeryczna),
  # medianą (porządkowa)
  # lub modą (kategoryczna)
  # 3: IRMI z VIM
  # 4: mice
  # 5: missForest
  
  if (num==1)
    return(df[, colSums(is.na(df))==0])
  
  else if (num==2){
    classes <- sapply(df[, -ncol(df)], class)
    moda <- function(x){
      u <- unique(x)
      u[which.max(tabulate(match(x, u)))]
    }
    nas <- colSums(is.na(df[, -ncol(df)]))
    for (i in 1:(ncol(df)-1)) if (nas[[i]]==0){
      if(classes[[i]]=="numeric")
        df[is.na(df[,i]), i] <- mean(df[[i]], na.rm=T)
      else if(classes[[i]]=="integer")
        df[is.na(df[,i]), i] <- median(df[[i]], na.rm=T)
      else
        df[is.na(df[,i]), i] <- moda(df[[i]])
    }
    return(df)
  }
  
  else if (num==3){
    fit <- VIM::irmi(df, trace=F, imp_var=F)
    return(fit)
  }
  
  else if (num==4){
    fit <- mice(df, m=3, maxit=3, printFlag=F)
    return(complete(fit))
  }
  
  else if (num==5){
    fit <- missForest(df)
    return(fit$ximp)
  }
}
