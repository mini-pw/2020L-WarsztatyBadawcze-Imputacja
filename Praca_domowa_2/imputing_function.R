library(VIM)
library(mice)
library(missForest)
library(dplyr)

imputation <- function(df, num){
  # 1: removing columns with missing data
  # 2: imputing with: mean (continous variables),
  # median (ordinal variables)
  # modal value (nominal variables)
  # 3: IRMI from VIM
  # 4: mice
  # 5: missForest
  
  if (num==1)
    return(df[, colSums(is.na(df))==0])
  
  else if (num==2){
    classes <- sapply(df[, -ncol(df)], class)
    moda <- function(x){
      u <- unique(x)
      u <- u[!is.na(u)]
      u[which.max(tabulate(match(x, u)))]
    }
    nas <- colSums(is.na(df[, -ncol(df)]))
    for (i in 1:(ncol(df)-1)) if (nas[[i]]>0){
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
    fit <- VIM::irmi(df[, -ncol(df)], trace=F, imp_var=F, maxit=10) %>%
      cbind.data.frame(df[, ncol(df)])
    colnames(fit)[ncol(fit)] <- colnames(df)[ncol(df)]
    return(fit)
  }
  
  else if (num==4){
    fit <- mice(df[, -ncol(df)], m=2, maxit=3, printFlag=F)
    comp <- complete(fit) %>%
      cbind.data.frame(df[, ncol(df)])
    colnames(comp)[ncol(comp)] <- colnames(df)[ncol(df)]
    return(comp)
  }
  
  else if (num==5){
    fit <- missForest(df[, -ncol(df)], maxiter=3, ntree=15)
    comp <- fit$ximp %>%
      cbind.data.frame(df[, ncol(df)])
    colnames(comp)[ncol(comp)] <- colnames(df)[ncol(df)]
    return(comp)
  }
}
