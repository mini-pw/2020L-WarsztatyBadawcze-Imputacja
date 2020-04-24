# install.packages("VIM")

library(VIM)

data(sleep, package = 'VIM')

### Visualization of missing and imputed values

## barMiss
x <- sleep[, c("Exp", "Sleep")]
barMiss(x, only.miss = FALSE)
# mało intuicyjna, pierwszą kolumnę traktuje jako grupy, drugą do zliczania obserwacji

## marginMatrix
x <- sleep[, 1:5]
marginmatrix(x)

## scattJitt
data(tao, package = 'VIM')
scattJitt(tao[, c("Air.Temp", "Humidity")])

## histMiss
x <- tao[, c("Air.Temp", "Humidity")]
histMiss(x, only.miss = FALSE)

## scattMiss
scattMiss(x)

## spineMiss
spineMiss(kNN(x), delimiter = "_imp")

### Imputation

## irmi
sleep_imp <- sleep
form = list(
  NonD = c('BodyWGT', 'BrainWGT'),
  Dream = c('BodyWGT', 'BrainWGT'),
  Sleep = c('BrainWGT')
) # kolumny od których ma zależeć imputacja

sleep_imp <- irmi(sleep_imp, modelFormulas = form, trace = TRUE)

## kNN
sleep_imp <- kNN(sleep)

## hot-deck
sleep_imp <- hotdeck(sleep, variable=c("NonD", "Dream", "Sleep", "Span", "Gest"),
                     ord_var = "BodyWgt", domain_var = "Pred")

## regessionImp
sleep_imp <- regressionImp(Dream+NonD~BodyWgt+BrainWgt, data = sleep)



####@@@@@@@@@@@@@@@   DODATKOWE FUNKCJE Z PAKIETU:

## gapMiss()

v <- rpois(100, lambda = 1) # z rozkładu Poissona
v[3:5] <- NA
v[6:9] <- NA
v[sample(100, 20)] <- NA

gapMiss(v, what = median) # mediana długości sekwencji NA
gapMiss(v, what = function(x) mean(x, trim = 0.05)) # średnia ucięta
gapMiss(v, what = function(x) psych::harmonic.mean(x))


## sampleCat() - wybiera kategorię używając wag jako p-stw. Używane przez kNN().
# maxCat() wybierze najczęstszą kategorię

v <- as.factor(c(1,1,2,2,3,3))

set.seed(800)
sampleCat(v, weights = c(0.1, 0.1, 0.5, 0.5, 2, 2))
sampleCat(v, weights = c(0.1, 0.1, 0.5, 0.5, 2, 2))
sampleCat(v, weights = c(0.1, 0.1, 0.5, 0.5, 2, 2))
sampleCat(v, weights = c(0.1, 0.1, 0.5, 0.5, 2, 2))
sampleCat(v, weights = c(10, 10, 0.5, 0.5, 2, 2)) # 1 z dużą wagą
sampleCat(v, weights = c(10, 10, 0.5, 0.5, 2, 2)) # 1 z dużą wagą
maxCat(v)  # w tym przypadku losową :)
maxCat(as.factor(c(1,2,4,3,4,2,4,4))) # a tutaj wybierze zawsze 4 :)

## prepare()   - transformuje & standaryzuje zmienne

data(sleep, package = "VIM")
x <- sleep[, c("BodyWgt", "BrainWgt")]

head(x,10)
head(prepare(x, scaling = "robust", transformation = "logarithm"),10)


## countInf(), countNA() - zlicza Inf/NA w wektorze atomowym

dane <- c(5,Inf,-Inf, 5,-2, 5, Inf, 0, -Inf, 5, NA, NA, Inf, 6, 5, 9) 
countInf(dane) # 5
countNA(dane) # 2

## colSequence() - Oblicza kolory pośrednie między 2 kolorami. RGB lub HCL


p <- seq(0,1,length = 20)
cs <- colSequence(p, RGB(0, 1, 1), "blue")
plot(x = 1:20, y = seq(2,20,length = 20), lty = 3, col = cs, cex = 2, lwd = 40, ylab = "Y", xlab = "X")

## alphablend() - kontroluje przezroczystosc, 
# 1 parametr = kolor, 
# 2 parametr  = stopień to opacity 'alpha' (od 0 = przezroczystego do 1 bez efektu)

# np.
alphablend("blue", 1) # == "blue
# [1] "#0000FFFF"


alphablend("blue", 0.1) # == transparent blue
# [1] "#0000FF1A"


plot(x = 1:10, y = seq(2,20,2), lty = 3, col = alphablend("red", 0.1), cex = 2, lwd = 40, ylab = "Y", xlab = "X")
lines(x = 1:10, y = seq(2,20,2), lty = 1, col = alphablend("red", 0.1), type = "h", lw = 80)
lines(x = 1:10, y = seq(2,20,2), lty = 1, col = alphablend("red", 0.3), type = "h", lw = 30)
lines(x = 1:10, y = seq(2,20,2), lty = 1, col = alphablend("red", 0.5), type = "h", lw = 7)
lines(x = 1:10, y = seq(2,20,2), lty = 1, col = alphablend("red", 0.7), type = "h", lw = 3)

