# http://naniar.njtierney.com/articles/getting-started-w-naniar.html
# https://cran.r-project.org/web/packages/naniar/vignettes/naniar-visualisation.html

# EDA ---------------------------------------------------------------------

library(naniar)
library(visdat)
library(ggplot2)
library(dplyr)
library(mice)

str(riskfactors)


### visualise whole dataset
summary(airquality)

vis_dat(airquality)

vis_miss(airquality)
vis_miss(airquality, cluster = TRUE)

airquality %>%
  arrange(Solar.R) %>%
  vis_miss()

miss_var_summary(airquality)
miss_case_summary(airquality)




# Visualise missings across cases and variables.
gg_miss_var(airquality)
gg_miss_var(airquality, 
            show_pct = TRUE) + 
  ylim(0, 100)


gg_miss_case(airquality)



# In the main body of the output table, “1” indicates nonmissing value and “0” indicates missing value. 
# The first column shows the number of unique missing data patterns. The last row counts the number of missing values for each variable. 
md.pattern(airquality)


# The upset shows the combination of missings, by default choosing the 5 variables with the most missings, and then orders by the size of the missings in that set.
gg_miss_upset(airquality)

# gg_miss_upset(riskfactors)


## scatersplots
ggplot(airquality, 
       aes(x = Wind, 
           y = Ozone)) +   
  geom_point()

ggplot(airquality, 
       aes(x = Wind, 
           y = Ozone)) +   
  geom_miss_point()+ 
  facet_wrap(~Month)

  
ggplot(airquality, 
       aes(x = Solar.R, 
           y = Ozone)) + 
  geom_miss_point() + 
  facet_wrap(~Month)


## shadow
airquality %>% bind_shadow() %>% glimpse()


## histograms

ggplot(airquality,
       aes(x = Wind)) + 
  geom_histogram()

airquality %>%
  bind_shadow() %>%
  ggplot(aes(x = Wind,
             fill = Ozone_NA )) +
  geom_histogram()




# ## alternative package 
# library(VIM)
# 
# matrixplot(airquality)
# 
# barMiss(airquality)
# 
# marginplot(airquality[,c('Solar.R', 'Ozone')], col = mdc(1:2), cex.numbers = 1.2, pch = 19)
# 
# 
# marginmatrix(airquality)
# 
# 
# scattmatrixMiss(airquality)



# Ad-hoc methods ----------------------------------------------------------

# delete missing values

airquality_wo_na <- na.omit(airquality)

# mean imputation
imp <- mice(airquality, method = "mean", m = 1, maxit = 1)

## complete dataset
complete(imp)

## explore imputated values
xyplot(imp,Ozone ~ Wind+Temp+Solar.R,pch=18,cex=1)

densityplot(imp)



# OpenML ------------------------------------------------------------------

library(OpenML)

task.ids = getOMLStudy('OpenML100')$tasks$task.id

getOMLDataSetQualities(task.ids[1])

task = getOMLTask(task.id) 
data = as.data.frame(task) 


