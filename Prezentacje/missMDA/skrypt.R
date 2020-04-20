library(missMDA)
library(FactoMineR)
library(VIM)
library(ggplot2)

# Metoda PCA - dla danych liczbowych

# Dane
data("airquality")
visdat::vis_dat(airquality)
summary(aggr(airquality, sortVar=TRUE))$combinations

# 1. Oszacowanie liczby wymiarów - metoda estim_ncpPCA

# Istotne argumenty:
#   X - ramka danych z wartościami ciągłymi, z brakami lub bez
#   ncp.min - minimalna liczba wymiarów brana pod uwagę w trakcie poszukiwań
#   ncp.max - maksymalna liczba wymiarów brana pod uwagę w trakcie poszukiwań
#   method - "Regularized" domyślnie lub "EM" - wyjaśnienie różnic w prezentacji
#   scaleboolean - TRUE narzuca taką samą wagę dla wszystkich zmiennych
#   method.cv - metoda kroswalidacji "gcv",  "loo" lub "Kfold" - wyjaśnienie różnic w prezentacji
#   nbsim - tylko dla metody "Kfold", liczba iteracji
#   pNA - tylko dla metody "Kfold", odsetek brakujących wartości który jest imputowany w kolejnych iteracjach
#   threshold - wartość graniczna dla określenia zbieżności
#   verbose - TRUE powoduje wyświetlenie paska postępu

nb <- estim_ncpPCA(airquality, method='Regularized', pNA=0.05, method.cv="Kfold", ncp.min=1, nbsim=150, verbose=FALSE)
# nb$criterion - wartości błędów prognozowania dla poszczególnych wymiarów
# nb$ncp - wymiar wynikowy, dla którego uzyskany błąd był najmniejszy

# Wizualizacja wyniku
plot(1:5, nb$criterion, xlab="nb dim", ylab="MSEP")
title(paste("Result = ", nb$ncp))

# 2. Imputacja - metoda imputePCA

# Istotne argumenty
#    X	- ramka danych o wartościach ciągłych zawierająca braki
#   ncp	- oszacowana liczba wymiarów
#   scale	- j.w.
#   method - j.w.
#   row.w	- waga wierszy  (dmyślnie, wektor sanych 1 dla równych wag wszystkich wierszy)
#   coeff.ridge	- 1 domyślnie, w celu zastosowania ustandaryzowanego algorytmu imputePCA; używana tylko gdy method="Regularized". 
#               Mniej niż 1, aby uzyskać retultaty zbliżone do wyniku metody EM i więcej niż 1 aby zbliżyć się do wyniku imputacji średnią. 
#   threshold - j.w.
#   seed - ziarno
#   nb.init	- liczba losowych inicjalizacji, pierwsza z nich to imputacja średnią
#   maxiter	- maksymalna liczba iteracji algorytmu
# ...	

res.comp <- imputePCA(airquality, ncp=nb$ncp, method="Regularized") 
head(res.comp$completeObs) # uzupełniona ramka

# Wywołanie metody PCA - nieistotne z punktu widzenia imputacji
res.pca <- PCA(res.comp$completeObs, graph=FALSE)
# Wizualizacja rezultatów
plot.PCA(res.pca, choix="var", graph.type='ggplot')
# Niepewności
res.mipca <- MIPCA(airquality, scale = TRUE, ncp = 2)
# widoczne szumy w pobliżu wektorów odpowiadających kolumnom z brakami
plot.MIPCA(res.mipca, 'var')
plot.MIPCA(res.mipca, choice='dim')

# Metoda MCA - dla danych kategorycznych

# Dane
summary(aggr(vnf, sortVar=TRUE))$combinations

# 1. Oszacowanie liczby wymiarów - metoda estim_ncpMCA

# Istotne argumenty:
#   don - ramka danych z wartościami ciągłymi, z brakami lub bez
#   ncp.min - minimalna liczba wymiarów brana pod uwagę w trakcie poszukiwań
#   ncp.max - maksymalna liczba wymiarów brana pod uwagę w trakcie poszukiwań
#   method - "Regularized" domyślnie lub "EM" - wyjaśnienie różnic w prezentacji
#   method.cv - metoda kroswalidacji "gcv",  "loo" lub "Kfold" - wyjaśnienie różnic w prezentacji
#   nbsim - tylko dla metody "Kfold", liczba iteracji
#   pNA - tylko dla metody "Kfold", odsetek brakujących wartości który jest imputowany w kolejnych iteracjach
#   threshold - wartość graniczna dla określenia zbieżności
#   verbose - TRUE powoduje wyświetlenie paska postępu

nb <- estim_ncpMCA(vnf, method='Regularized', verbose=TRUE, method.cv="Kfold")
# nb$criterion - wartości błędów prognozowania dla poszczególnych wymiarów
# nb$ncp - wymiar wynikowy, dla którego uzyskany błąd był najmniejszy

# Wizualizacja wyniku
plot(1:5, nb$criterion, xlab="nb dim", ylab="MSEP")
print("Result = ", nb$ncp)

# 2. Imputacja - metoda imputeMCA

# Istotne argumenty
#   don	- ramka danych o wartościach ciągłych zawierająca braki
#   ncp	- oszacowana liczba wymiarów
#   method - j.w.
#   row.w	- waga wierszy  (dmyślnie, wektor sanych 1 dla równych wag wszystkich wierszy)
#   coeff.ridge	- 1 domyślnie, w celu zastosowania ustandaryzowanego algorytmu imputePCA; używana tylko gdy method="Regularized". 
#               Mniej niż 1, aby uzyskać retultaty zbliżone do wyniku metody EM i więcej niż 1 aby zbliżyć się do wyniku imputacji średnią. 
#   threshold - j.w.
#   seed - ziarno
#   maxiter	- maksymalna liczba iteracji algorytmu
# ...	

res.comp <- imputeMCA(vnf, ncp=nb$ncp, method="Regularized") 

# Dane po imputacji
# complete disjunctive table (prawdopodobienstwa)
res.comp$tab.disj[25:30, 1:6]
# dane uzupelnione klasami
res.comp$completeObs[25:30, 1:2]

# Wywołanie metody PCA - nieistotne z punktu widzenia imputacji
res.mca <- MCA(res.comp$completeObs, graph=FALSE)
# Wizualizacja rezultatów
plot.MCA(res.mca, choix="var", graph.type='ggplot')

# wizualizacja niepewnosci
res.mimca <- MIMCA(vnf, ncp=nb$ncp)
plot.MIMCA(res.mimca, choice='dim')

# ramka danych w brakach w kolumnie numerycznej i kolumnie kategorycznej
data("wine")
wine
wine<- wine[, c(1, 2, 16, 22, 29, 28, 30,31)] # ograniczamy liczbe kolumn
wine
# usuwanie danych aby były braki
x <- sample(nrow(wine), 3)
y <- sample(nrow(wine), 3)
wine$Label[x] <- NA
wine$Harmony[y] <- NA

#Metoda FAMD - najlepsza do automatycznego uzupełniania dużej wiedzy o danych

# 1. Oszacowanie liczby wymiarów - metoda estim_ncpFAMD

# Istotne argumenty:
#   don - ramka danych z brakami lub bez - zmienne mogą być i ciągłe i kategoryczne
#   ncp.min - minimalna liczba wymiarów brana pod uwagę w trakcie poszukiwań
#   ncp.max - maksymalna liczba wymiarów brana pod uwagę w trakcie poszukiwań
#   method - "Regularized" domyślnie lub "EM" - wyjaśnienie różnic w prezentacji
#   method.cv - metoda kroswalidacji "gcv",  "loo" lub "Kfold" - wyjaśnienie różnic w prezentacji
#   nbsim - tylko dla metody "Kfold", liczba iteracji
#   pNA - tylko dla metody "Kfold", odsetek brakujących wartości który jest imputowany w kolejnych iteracjach
#   threshold - wartość graniczna dla określenia zbieżności
#   verbose - TRUE powoduje wyświetlenie paska postępu


nb3 <- estim_ncpFAMD(wine, ncp.min=1, ncp.max = 3) # ncp dla których chcemy sprawdzac - tu od 1 do 3

# 2. Imputacja - metoda imputeFAMD

# Istotne argumenty
#   X- ramka danych zawierająca braki - zmienne mogą być i ciągłe i kategoryczne
#   ncp	- oszacowana liczba wymiarów
#   method - j.w.
#   row.w	- waga wierszy  (dmyślnie, wektor sanych 1 dla równych wag wszystkich wierszy)
#   coeff.ridge	- 1 domyślnie, w celu zastosowania ustandaryzowanego algorytmu imputePCA; używana tylko gdy method="Regularized". 
#               Mniej niż 1, aby uzyskać retultaty zbliżone do wyniku metody EM i więcej niż 1 aby zbliżyć się do wyniku imputacji średnią. 
#   threshold - j.w.
#   sup.var - wektor określający rodzaj danych w każdej kolumnie (ciągłe lub kategoryczne) - jeśli nie podane algorytm sam się domyśla
#   seed - ziarno
#   maxiter	- maksymalna liczba iteracji algorytmu
# ...	
res.comp3 <- imputeFAMD(wine, ncp=2, 
                        method="Regularized") 

?imputeFAMD

# metoda MFA - też na danych wine 

# Imputacja - imputeMFA

# Istotne argumenty
#   X- ramka danych zawierająca braki - zmienne mogą być i ciągłe i kategoryczne
#   group - wektor określający liczbę zmiennych w każdej grupie (wcześniej musimy ustawić tak kolejność zmiennych w ramce aby dane z jednej grupy były obok siebie)
#   ncp	- oszacowana liczba wymiarów
#   type-  rodzaj danych w każdej z kolejnych grup - "c" albo "s" dla ciągłych, "n" dla kategorycznych
#   method - j.w.
#   row.w	- waga wierszy  (dmyślnie, wektor sanych 1 dla równych wag wszystkich wierszy)
#   coeff.ridge	- 1 domyślnie, w celu zastosowania ustandaryzowanego algorytmu imputePCA; używana tylko gdy method="Regularized". 
#               Mniej niż 1, aby uzyskać retultaty zbliżone do wyniku metody EM i więcej niż 1 aby zbliżyć się do wyniku imputacji średnią. 
#   threshold - j.w.
#   seed - ziarno
#   maxiter	- maksymalna liczba iteracji algorytmu
#   ...

res.comp4 <- imputeMFA(wine, group=c(2,2,4), 
                       type=c('n', 's', 's'), ncp=2, graph=FALSE )  #graph=TRUE pokazuje kilka wykresów - przydatne

?imputeMFA