library(missMDA)
library(FactoMineR)

# Metoda PCA dla zbioru z brakami
data("airquality")

# IMPUTATION
## Step 1. estimate the number of dimensions used in the reconstruction formula 
nb = estim_ncpPCA(airquality, ncp.max=5)
# Important arguments:
   # ncp.min
   # ncp.max
   # method
   # method.cv
   # pNA (for Kfold method.cv)
   # nbsim (for Kfold method.cv)

## Step 2. impute the data set with the impute.PCA function using the number 
##    of dimensions previously calculated
res.comp = imputePCA(airquality,ncp=2, method = 'Regularized', seed = 123)
# Important arguments:
    # ncp
    # method

# METHOD PERFORMANCE
## 3. perform the PCA on the completed data set using the PCA function 
## of the FactoMineR package
res.pca = PCA(res.comp$completeObs) 


# VISUALISING UNCERTAINITY DUE TO MISSING DATA
res.mipca <- MIPCA(airquality, ncp = 2, nboot = 100)
plot.MIPCA(res.mipca, choice = 'dim')
plot.MIPCA(res.mipca, 'var')

# Przydatny link:
## http://factominer.free.fr/course/missing.html
?imputePCA






# metoda FAMD

#ramka danych w brakach w kolumnie numerycznej i kolumnie kategorycznej
data("wine")
wine
wine<- wine[, c(1, 2, 16, 22, 29, 28, 30,31)] #ograniczamy liczbe kolumn
wine
#usuwanie danych aby były braki
x <- sample(nrow(wine), 3)
y <- sample(nrow(wine), 3)
wine$Label[x] <- NA
wine$Harmony[y] <- NA



#szukanie wymiaru
nb3 <- estim_ncpFAMD(wine, ncp.min=1, ncp.max = 3) #ncp dla których chcemy sprawdzac - tu od 1 do 3

#imputacja

res.comp3 <- imputeFAMD(wine, ncp=2, 
                       method="Regularized") 

?imputeFAMD

# metoda MFA 

res.comp4 <- imputeMFA(wine, group=c(2,2,4), 
                       type=c('n', 's', 's'), ncp=2, graph=FALSE ) #graph=TRUE pokazuje kilka wykresów - przydatne
 
?imputeMFA

