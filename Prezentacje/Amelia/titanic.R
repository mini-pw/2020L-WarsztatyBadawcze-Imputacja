library(Amelia)
library(dplyr)
library(mlr3)
library(mlr3learners)
library(pROC)
options(stringsAsFactors = FALSE)
options(warn=-1)

data <- read.csv("R/titanic.csv")
data <- data %>% mutate(sex=recode(sex,"male"=1,"female"=0))
data <- data %>% mutate(embarked=recode(embarked,"Q"=2,"S"=1,"C"=0))
data[data=="?"]<-NA
data <- select(data, -c(name,ticket,home.dest,cabin))
data$age <- as.numeric(data$age)
data$body <- as.numeric(data$body)
data$boat <- as.numeric(data$boat)
data$fare <- as.numeric(data$fare)
data$survived <- as.factor(data$survived)
y <- select(data,c(survived))

summary(data)

#Załadowanie danych

train_set = sample(nrow(data),0.8 * nrow(data))
test_set = setdiff(seq_len(nrow(data)), train_set)

train <- data[train_set,]
test <- data[-train_set,]

#Podział na train i test

noms <- c('embarked')
ords <- c('sex')
idvars <- c('survived')
auc <- mlr_measures$get('classif.auc')

#Ustawienie odpowiednich kolumn dla Amelii

imputed_train<- amelia(train,m=5,noms = noms,ords=ords,idvars=idvars)
imputed_test <- amelia(test,m=5,noms = noms,ords=ords,idvars=idvars)

#Inputacja

data1 <- rbind(imputed_train$imputations$imp1,imputed_test$imputations$imp1)
data2 <- rbind(imputed_train$imputations$imp2,imputed_test$imputations$imp2)
data3 <- rbind(imputed_train$imputations$imp3,imputed_test$imputations$imp3)
data4 <- rbind(imputed_train$imputations$imp4,imputed_test$imputations$imp4)
data5 <- rbind(imputed_train$imputations$imp5,imputed_test$imputations$imp5)

#Przygotowanie danych z 5 datasetow zwroconych przez Amelie

task= TaskClassif$new(id = "titanic", backend =data4, target = "survived")
learner = lrn("classif.rpart",predict_type='prob')

learner$param_set$values = mlr3misc::insert_named(
  learner$param_set$values,
  list(cp = 0.02, minsplit = 2)
)
learner$train(task,row_ids = train_set)
prediction = learner$predict(task,row_ids=test_set)

#Przewidywania probne na jednym z datasetóœ

y <- prediction$truth



pROC_obj <- roc(as.numeric(prediction$truth),as.numeric(prediction$response),
                smoothed = TRUE,
                ci=TRUE, ci.alpha=0.9, stratified=FALSE,
                plot=TRUE, auc.polygon=TRUE, max.auc.polygon=TRUE, grid=TRUE,
                print.auc=TRUE, show.thres=TRUE)

#Oraz wynik na tym probnym datasecie

scores <- data.frame(y)
acc_vector = vector()

#Przygotowanie do agregacji wyników

task1 <- TaskClassif$new(id = "titanic", backend =data1, target = "survived")
task2 <- TaskClassif$new(id = "titanic", backend =data2, target = "survived")
task3 <- TaskClassif$new(id = "titanic", backend =data3, target = "survived")
task4 <- TaskClassif$new(id = "titanic", backend =data4, target = "survived")
task5 <- TaskClassif$new(id = "titanic", backend =data5, target = "survived")
tasks <- list(task1,task2,task3,task4,task5)

#Ustawienie tasków

for (task in tasks){
  learner = lrn("classif.rpart",predict_type='prob')
  learner$param_set$values = list(cp = 0.01)
  learner$param_set$values = mlr3misc::insert_named(
    learner$param_set$values,
    list(cp = 0.02, minsplit = 2)
  )
  learner$train(task,row_ids = train_set)
  prediction = learner$predict(task,row_ids=test_set)
  scores <- cbind(scores,prediction$response)
  acc <- prediction$score(auc)
  acc_vector <- c(acc_vector,acc)
}
#Wykonanie serii pomiarów

scores <- as.matrix(sapply(scores, as.numeric))
scores <- cbind(scores,rowSums(scores[,2:6]))
scores[,7] <- round(scores[,7]/5)
scores <- round(scores/2)


#Ostateczna agregacja wyników oraz końcowy wykres

pROC_obj <- roc(scores[,1],scores[,7],
                smoothed = TRUE,
                ci=TRUE, ci.alpha=0.9,stratified=FALSE,
                plot=TRUE, auc.polygon=TRUE, max.auc.polygon=TRUE, grid=TRUE,
                print.auc=TRUE, show.thres=TRUE)
