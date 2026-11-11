#### Calibration Stage Cross Validation ####
#### October 17, 2022 ####

## This script is largely based off of 20210717_stage2_cv.R
## with extraneous code removed

## Updated on 12/8


#### Load packages ####
library(tidyverse)
library(data.table)
library(dplyr)
library(doParallel)
library(foreach)
library(ranger)
library(mgcv)
library(caret)
library(xgboost)
library(DiceKriging)
library(rgenoud)

setwd("/home/mike/Desktop/no2_model_mexico_city/code/helpers")
source("per_meas.R")


#### Load Dataset ####
setwd("/media/hd/no2_israel/processed_data")
s1 <- read_csv("second_stage_monitors_only.csv")

## Adding Julian date
s1$jd <- julian(s1$date)

## Creating 10 splits for CV
s1 <- as.data.table(s1)
size <- dim(s1)[1]
random                <- sample(size)
s1[,random:= random]
s1[random>=0*round(size/10)+1 & random<=1*round(size/10), split:= 1]
s1[random>=1*round(size/10)+1 & random<=2*round(size/10), split:= 2]
s1[random>=2*round(size/10)+1 & random<=3*round(size/10), split:= 3]
s1[random>=3*round(size/10)+1 & random<=4*round(size/10), split:= 4]
s1[random>=4*round(size/10)+1 & random<=5*round(size/10), split:= 5]
s1[random>=5*round(size/10)+1 & random<=6*round(size/10), split:= 6]
s1[random>=6*round(size/10)+1 & random<=7*round(size/10), split:= 7]
s1[random>=7*round(size/10)+1 & random<=8*round(size/10), split:= 8]
s1[random>=8*round(size/10)+1 & random<=9*round(size/10), split:= 9]
s1[random>=9*round(size/10)+1 & random<=size,             split:= 10]
gc()



#### Inputs for the learners ####
formula <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens + majorroads_length_km_km2_T2)

# Define the hyper-parameters for the Xgboost model
xgbGrid <- expand.grid(nrounds = 500, max_depth = 10, colsample_bytree = 0.808,
                       eta = 0.149, gamma=6, min_child_weight = 1, subsample = 1)
fitGBMMon <- trainControl( method = "none")

#### Stage 1: Run the CV for the learners ####
cv_scheme <- expand.grid(Inner = 1:10, Outer = 1:10) # Outer-validation of gam model, # Inner- testing of learners
cv_scheme <- cv_scheme[cv_scheme$Inner != cv_scheme$Outer, ] # Remove all rows where the inner and outer split is the same. 

ptm <- proc.time()

c1 <- makeCluster(16)
registerDoParallel(c1)


pred_models =  foreach (i=1:nrow(cv_scheme), .packages = c("data.table", "ranger", "caret", "xgboost", "rgenoud", "DiceKriging") ) %dopar% {
  print(i)
  
  train                 <- subset(s1, split!=cv_scheme $Inner[i] & split!=cv_scheme $Outer[i]) # 80% of the data
  test                  <- subset(s1, split==cv_scheme $Inner[i]) # 10% of the data subset
  
  # RF #################################################
  mod1 <- ranger(formula, data=train, num.trees=500, mtry=8, min.node.size = 2, importance="impurity", keep.inbag=TRUE, seed=824)
  test$pred.rf         <- predict(mod1, test)$predictions
  
  # XGBoost ############################################
  mod2  <-  caret::train(formula, data = s1,method = "xgbTree", trControl = fitGBMMon, verbose = FALSE, tuneGrid = xgbGrid)
  test$pred.bo <- predict(mod2, test)
  
  # Keep needed var ####################################
  test$Inner_iter <- cv_scheme $Inner[i]
  test$Outer_iter <- cv_scheme $Outer[i]
  test[, list(date, grid_id, x, y, monitor_no2, pred.rf, pred.bo, Inner_iter, Outer_iter)]
  
}

# stopCluster(c1)
proc.time() - ptm #about 7 hours

# Bind results from all folds and save
mod_pred.cv = do.call(rbind, pred_models)
nrow(mod_pred.cv) == (nrow(s1))*9 # make sure it makes sense 
setwd("/media/hd/no2_israel/processed_data")
saveRDS(mod_pred.cv, "calibration_cv_stage1_final.rds")



#### Stage 2: Fit GAM model (90% each time and predict on 10% excluded from validation of ensemble) ####
ptm <- proc.time()
c1 <- makeCluster(16)
registerDoParallel(c1)

gam_validation =  foreach (i=1:10, .packages = c("data.table", "ranger", "caret", "xgboost", "rgenoud", "DiceKriging", "mgcv") ) %dopar% {
  
  # First we create the train and validation data in order to produce NO2 predictions for the 10% validation from the learners
  train                 <- subset(s1, split!=i)
  validation            <- subset(s1, split==i)
  
  ###############
  # For the out-of sample 10% Predict NO2 using the different models
  ###############
  
  # RF ############################################################################
  mod1 <- ranger(formula, data=train, num.trees=500, mtry=8, min.node.size = 2, importance="impurity", keep.inbag=TRUE, seed=824)
  validation$pred.rf         <- predict(mod1, validation)$predictions
  
  # XGBoost #######################################################################
  mod2  <-  caret::train(formula, data = train, method = "xgbTree", trControl = fitGBMMon, verbose = FALSE, tuneGrid = xgbGrid)
  validation$pred.bo <- predict(mod2, validation)
  
  ################################
  # For the out-of sample 10% gam validation Predict NO2 using the cv predictions from different models
  ################################
  
  # Create a test set that is 90% of the data that includes the out of sample predictions
  train                 <- subset(mod_pred.cv, Outer_iter== i)
  
  ensemble <- gam(monitor_no2 ~ s(x, y , by=pred.rf)+
                    s(x, y, by=pred.bo)
                  ,data=train)
  
  # Predict ensemble model
  validation$pred.gam <- predict(object=ensemble, newdata = validation)
  
  
  validation$Outer_iter <- i
  validation <- validation[,list(date, grid_id, x, y,
                                 monitor_no2,pred.rf,pred.bo,pred.gam,
                                 Outer_iter)]
  
}
stopCluster(c1) 
proc.time() - ptm #about 75 mins

# Bind all gam validation predictions together
gam_validation_res <- do.call(rbind, gam_validation)

# Make sure we have out-of-sample predictions at the same size of original data
nrow(gam_validation_res)==nrow(s1)
saveRDS(gam_validation_res, "calibration_cv_stage2_final.rds")



#### Stage 3: Bind results for all models and calculate CV performance ####
gam_validation_res <- as.data.frame(gam_validation_res)

cv_res_gam <- per_meas(y=gam_validation_res$monitor_no2, x=gam_validation_res$pred.gam, data=gam_validation_res, name_y = "monitor_no2", name_x = "pred.gam")
cv_res_gam <- round(cv_res_gam,2)

cv_res_rf <- per_meas(y=gam_validation_res$monitor_no2, x=gam_validation_res$pred.rf, data=gam_validation_res, name_y = "monitor_no2", name_x = "pred.rf")
cv_res_rf <- round(cv_res_rf,2)

cv_res_bo <- per_meas(y=gam_validation_res$monitor_no2, x=gam_validation_res$pred.bo, data=gam_validation_res, name_y = "monitor_no2", name_x = "pred.bo")
cv_res_bo <- round(cv_res_bo,2)

cv_res <- cbind(cv_res_gam, cv_res_rf, cv_res_bo)
colnames(cv_res) <- c("GAM", "RF", "BO")
cv_res <- as.data.frame(cv_res)
write_csv(cv_res, "calibration_ensemble_final.csv")
