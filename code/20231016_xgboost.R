#### XGBoost Model ####
#### October 16, 2023  ####

## This script is largely based off of 20220523_xgboost.R


# Load packages
library(tidyverse)
library(data.table)
library(ranger)
library(mlrMBO)
library(magrittr)
library(ggplot2)
library(xgboost)
library(DiceKriging)
library(rgenoud)



#### Load Dataset ####
setwd("/media/hd/no2_israel/processed_data")
s1 <- read_csv("second_stage_monitors_only.csv")
s1$jd <- julian(s1$date)


# Keep only variables we plan on using
s1 <- s1 %>%
  dplyr::select(monitor_no2, rf_no2, wind_u, wind_v, temp_2m, blh, Elev, jd, Pop_dens, majorroads_length_km_km2_T2)


#### Tuning ####

# Define how many cores to use
ncores <- 16

# Define the task
task <- makeRegrTask(target = "monitor_no2", data =s1) # i think this just runs with everything?

# Set up the xgboost learner
learner = makeLearner(
  cl = "regr.xgboost",
  nthread = ncores,    # let xgboost run in parallel
  nrounds = 500,    # number of iterations
  gamma=6)# regularization

# Hyperparameters to tune
par.set = makeParamSet(
  makeNumericParam("eta", 0.01, 0.3),           # learning rate (small = slow)
  makeIntegerParam("max_depth", 5, 25),         # max tree depth; change this to smaller range to test
  makeNumericParam("colsample_bytree", 0.5, 1), # pct features evaluated per tree
  makeIntegerParam("min_child_weight", 1, 10) 
)


# When tuning, train on two 20% samples of the data
resampling = makeResampleDesc("Subsample", split = 0.2, iters = 2)
# I did not use the outer cross-validation to evaluate the results because it takes a really long time, and I will later use my own cross validation to see how the model performs using the suggested hyper parameters.

# Tune the hyper-parameters
stime <- proc.time()
tune_res <- tuneParams(learner=learner,task=task,resampling=resampling,
                       measures=list(rmse,rsq, mae, timetrain),
                       par.set=par.set,control=makeTuneControlMBO(budget = 60))# Tune using mlrMBO with 60 iterations 
final <- proc.time()-stime
final # 3 hours or so

# Save the results of the tuning
setwd("/media/hd/no2_israel/processed_data")
write_rds(tune_res, "tune_res.rds")

#Tune result:
#  Op. pars: eta=0.149; max_depth=10; colsample_bytree=0.808; min_child_weight=1
#rmse.test.rmse=4.4767103