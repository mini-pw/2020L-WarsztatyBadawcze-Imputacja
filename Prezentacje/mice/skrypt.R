library(mice)
library(visdat)

## Zbiory dostępne w pakiecie mice
summary(brandsma)
str(brandsma)
summary(boys)
summary(mtcars)
summary(iris)

## ampute

### Przykład 1 - losowe usuwanie we wszystkich kolumnach
iris_new <- iris[,-5]
iris_amp <- ampute(data = iris_new, # dane muszą być numeryczne
                  prop = 0.5, # proporcja danych do usunięcia
                  mech = "MCAR" # Missing Completely at Random 
                  )

summary(iris_amp$amp)

### Przykład 2 - usuwanie w 2 kolumnach w tych samych wierszach
mtcars_amp1<-ampute(data=mtcars,
                   # patterns - ramka danych wskazująca gdzie usunąć
                  patterns=c(1,1,1,1,1,1,1,0,0,1,1),
                    prop = 0.5,
                    mech="MCAR")
summary(mtcars_amp1$amp)

### Przykład 3 - usuwanie w 2 kolumnach niezależnie (w różnych wierszach)?b
mtcars_amp2<-ampute(data=mtcars,
                    # patterns - ramka danych wskazująca gdzie usunąć
                    patterns=rbind(
                      c(1,1,1,1,1,1,1,0,1,1,1),
                      c(1,1,1,1,1,1,1,1,0,1,1)),
                    prop = 0.5,
                    mech="MCAR")


## Wizualizacja brakujących danych

mice::bwplot(iris_amp, which.pat = 1)
# lattice
md.pattern(iris_amp$amp)

fluxplot(iris_amp$amp)

## Imputacja danych

dutch_boys <- boys

summary(dutch_boys)

# mice samo rozpoznaje kolumny które może imputowac daną metoda
# w tym przypadku wszystkie z brakami można uzupełnić pmm
imp <- mice(dutch_boys,
            method="pmm", m=3, maxit=3)

dutch_boys <- complete(imp)
str(dutch_boys)

# możemy też wyspecyfikować które kolumny chcemy uzupełnić jaką metodą
# odpowiednią dla typu danych

dutch_boys_2 <- boys 
str(dutch_boys_2)

# wybieramy tylko kolumny numeryczne
imp1 <- mice(dutch_boys_2[,-c(6,7,9)],
            method="pmm", m=3, maxit=3)

dutch_boys_2[,-c(6,7,9)] <- complete(imp1)
 
# teraz kolumna 9 czyli nieuporządkowane dane kategoryczne
imp2 <- mice(dutch_boys_2[,-c(6,7)], method="polyreg", m=3, maxit=3)
dutch_boys_2[,-c(6,7)] <- complete(imp2)

# i na koniec kolumny 6 i 7 (uporządkowane kategoryczne)
imp3 <- mice(dutch_boys_2, method="polr", m=3, maxit=3)
dutch_boys_2 <- complete(imp3)

summary(dutch_boys_2)

## Metody wizualizacji danych imputowanych

# niebieski - "normalne" dane, czerwony - imputowane
densityplot(imp1) # tylko dla danych ciągłych !!!

# czerwone - dane imputowane
stripplot(imp1,col=c("grey",mdc(2)),pch=c(1,20))

xyplot(imp3, gen+phb ~ hgt+wgt,
       cex=1,col=c("grey",mdc(2)),pch=c(1,20))

## Zebranie wyników analiz 

dutch_boys <- boys

# imputacja
temp <- mice(dutch_boys, m = 10, maxit = 5, seed = 123)

# dopasowanie modelu lm 
modelFit <- with(data=temp, 
                 expr=lm(age ~ hgt + wgt))

summary(modelFit)

# zebranie wyników
summary(pool(modelFit))
