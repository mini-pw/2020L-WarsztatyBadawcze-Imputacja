## https://www.openml.org/s/14


#install.packages("OpenML")
#install.packages("mlr3verse")

library(OpenML)
library(mlr3)
library(data.table)
  
set.seed(1)

# pobranie danych z OpenML
credit_task_openml <- getOMLDataSet(data.id = 31L)
credit <- credit_task_openml$data
head(credit)



# zdefiniowanie rodzaju problemu - task ----------------
## traget - kolumna, ktora objasniamy
## TaskRegr do problemu regresji
## TaskClassif do problemu klasyfikacji
task_credit = TaskClassif$new(id = "credit", backend = credit, target = "class")

## podsumowanie zbioru danych
print(task_credit)


# podzial na zbior testowy i treningowy
## definiujemy, ktore wiersze naleza do zbioru treningowego, a ktore do testowego
train_set = sample(task_credit$nrow, 0.8 * task_credit$nrow)
test_set = setdiff(seq_len(task_credit$nrow), train_set)

# Zadanie
# Wczytaj wybrane przez siebie dane  i podziel je na zbior treningowy i testowy. Wybierz klasyfikację


# zdefiniowanie modelu ---------------
## w mlr3 mamy do dyspozycji 
# https://github.com/mlr-org/mlr3learners

library("mlr3learners")
mlr_learners

## wybor typy algorytmu
learner = mlr_learners$get("classif.rpart")
print(learner)

## dostepne hiperparametry dla tego modelu
learner$param_set

## przed wytrenowaniem modelu ustawić wartosci hiperparametrow
### nadpisanie dotychczasowych hiperparametrow
learner$param_set$values = list(cp = 0.01)
learner

## dodanie do istniejacych hiperparametrow
learner$param_set$values = mlr3misc::insert_named(
  learner$param_set$values,
  list(cp = 0.02, minsplit = 2)
)
learner

# trenowanie modelu ---------------------

## na razie w obiekcie nie ma typu modelu
print(learner$model)

## trenowanie modelu
learner$train(task_credit, row_ids = train_set)

print(learner$model)

# predykcja na zbiorze testowym -----------------------
prediction = learner$predict(task_credit, row_ids = test_set)
print(prediction)

head(as.data.table(prediction))

learner$predict_type = "prob"

# Zadanie 
## Na wybranym przez siebie zbiorze danych dopasuj model lasu losowego (ranger) i dowolny inny.


# Miary
as.data.table(mlr_measures)[task_type=='classif']


# kroswalidacja ------------------------
cv = rsmp("cv", folds = 5)
print(cv)



## kroswalidacja dla wybranego zbioru danych i algorytmu
rr = resample(task_credit, learner, cv, store_models = TRUE)
print(rr)


## porównywanie miar modeli z kroswalidacji
rr$score(msr("classif.acc"))

## sredni blad kroswalidacji
rr$aggregate(msr("classif.acc"))

## miary z foldow agregowane sa do sredniej miary
mean(rr$score(msr("classif.acc"))$classif.acc)

# predykcja
rr$prediction() 

rr$predictions()[[2]]

### inne metody resamplingu
as.data.table(mlr_resamplings)



## kroswalidacja dla ustalonych podzialow zbioru
## pozwala stosować te same podzialy krowalidacyjne do porownywania roznych modeli

random_groups <- sample(1:5, task_credit$nrow, replace = TRUE)

cross_split <- split(1:task_credit$nrow, random_groups)
cross_split_train <- lapply(cross_split, function(x) setdiff(1:task_credit$nrow, x))

resampling = rsmp("custom")
resampling$instantiate(task_credit,
                       train = cross_split_train,
                       test = cross_split)

resampling$iters


# Zadanie
# Dla wybranych modeli klasyfikacyjnych na podstawie CV sprawdzić jego Accuracy i AUC.




## wizualizaja wynikow

library("mlr3viz")

autoplot(rr)



