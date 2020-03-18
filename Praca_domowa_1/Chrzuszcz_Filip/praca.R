library(OpenML)
library(naniar)
library(visdat)
library(ggplot2)
library(dplyr)
library(mice)
library(mlr3)
library(data.table)
library(mlr3learners)
library(mlr3viz)

cjs_openml <- getOMLDataSet(data.id = 23380)
cjs <- cjs_openml$data


vis_dat(cjs)
vis_miss(cjs, cluster = TRUE)
x <- miss_var_summary(cjs)

naniar::gg_miss_upset(cjs, 
              nsets = 10,
              nintersects = 50)
#TL,IN - numeric

ggplot(cjs, 
       aes(x = BR, 
           y = TL)) + 
  geom_miss_point() + 
  facet_wrap(~TR)


ggplot(cjs, 
       aes(x = BR, 
           y = INTERNODE_2)) + 
  geom_miss_point() + 
  facet_wrap(~TR)

a <- select_if(cjs,is.numeric)

vis_cor(a)
gg_miss_var(cjs)



## shadow
cjs %>% bind_shadow() %>% glimpse()

ggplot(cjs,
       aes(x = IN)) + 
  geom_histogram()


cjs %>%   bind_shadow() %>%
  ggplot(aes(x = TL, fill=INTERNODE_2_NA))+
  geom_histogram()


gg_miss_var(cjs, facet = TR)

cjs %>%   bind_shadow() %>%
  ggplot(aes(x = TL, fill=INTERNODE_29_NA))+
  geom_histogram()


ggplot(cjs, 
       aes(x = TL, 
           y = IN)) +   
  geom_point()+ 
  facet_wrap(~TR)

gg_miss_var_cumsum(cjs)



task_cjs = TaskClassif$new(id = "cjs", backend = cjs, target = "TR")

train <- cjs %>% dplyr::sample_frac(.75)
test  <- dplyr::anti_join(cjs, train, by = "N")
learner = mlr_learners$get("classif.xgboost")

learner$param_set$values = mlr3misc::insert_named(
  learner$param_set$values,
  list(cp = 0.02, minsplit = 2))
learner$train(task_cjs, row_ids = train$N)





