#### Stage 1 NO2 Modeling ####
#### September 4, 2023 ####


## This is largely based off of the 20210624_stage1_modeling script from the Mexico model
## Spatial R2 needs to be re-run with the newly created grid_ids
## Since sinu_id was not unique for every grid

## Reran this on 12/7


#### Load packages ####
library(tidyverse)
library(lubridate)
library(data.table)
library(doParallel)



#### Descriptive Statistics ####

## omi_no2 units: molecules / cm^2
## tropomi no2 units: ?
## cams no2 units: kg / m^2
## temperature units: Kelvins
## blh units: meters
## elevation units: meters
## road length units: km

## Load data
setwd("/media/hd/no2_israel/processed_data")
dta <- read_csv("first_stage.csv")

## Add step to put grids inside (load grids_date_id.csv file)
#dta_grid <- read_csv("grids_date_id.csv")
#dta <- left_join(dta, dta_grid, by = c("lon", "lat", "date"))
#rm(dta_grid)

## Adding Julian date
dta$jd <- julian(dta$date)
dta$yday <- yday(dta$date)

## Stoichiometry to convert from molecules/cm^2 to kg/m^2
dta$omi_no2 <- dta$omi_no2*((10000*46.0055)/(6.02e23*1000))

## Remove 2005-02-07 (n=15553)
dta <- dta[!is.na(dta$temp_2m), ]

## Filter out the negative values (to extract)
dta_negative <- dta %>%
  filter(omi_no2 < 0)

## Dataset without missing OMI/CAMS data
dta2 <- dta[!is.na(dta$omi_no2), ]
dta2 <- dta2[!is.na(dta2$cams_no2), ]
dta2 <- dta2[!is.na(dta2$temp_2m), ]

dta_omi <- dta2 %>%
  filter(omi_no2 >= 0)
summary(dta_omi$omi_no2)
# 789858 negative values out of 52,867,088...~1.5% (in line with 1.4% from before)
# Will remove these just in case as well for prediction purposes

dta2 <- dta2 %>%
  filter(omi_no2 >= 0)
#rm(dta_omi)

## Small amount of missingness in temp_2m data...let's check
dta_temp <- dta2[is.na(dta2$temp_2m), ] ## all missing for 2005-02-07...not sure why but removing for now (in code above)
## Checked the original data, and indeed 2005-02-07 is missing a portion of data for the relevant period


#### Random Forest Model/Cross Validation ####
## To expedite testing, we are using the exact same model as we used earlier for the Mexico model
## Going straight to cross validation
registerDoParallel(cores=17) # use 17 out of 18 cores

set.seed(824)
s1 <- dta2
size <- dim(s1)[1]
s1 <- as.data.table(s1)

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

formula <- as.formula(omi_no2 ~ cams_no2 + temp_2m)
#formula <- as.formula(omi_no2 ~ cams_no2 + lon + lat + blh + temp_2m)

# Takes about ~1.5 hours each to run (old model)
final =  foreach (i=1:10, .packages = c("data.table", "ranger") ) %dopar% {
  print(i)
  test               <- subset(s1, split==i)
  train              <- subset(s1, split!=i)
  mod                <- ranger(formula, data=train, num.trees=50, mtry=2)
  pred               <- mod$predictions
  test$pred.no2.cv   <- predict(mod, test)$predictions
  test$itercv        <- i
  test[, list(grid_id, jd, x, y, omi_no2, pred.no2.cv, itercv)]
}
mod.all = do.call(rbind, final)

# Overall
m1.fit.all  <- lm(omi_no2~pred.no2.cv, data=mod.all)
r2.all      <- summary(m1.fit.all)$r.squared
rmspe       <- ModelMetrics::rmse(modelObject = m1.fit.all)
inter       <- summary(m1.fit.all)$coef[1,1]
slope       <- summary(m1.fit.all)$coef[2,1]

# Spatial
spatial_all <- mod.all %>%
  group_by(grid_id) %>%
  dplyr::summarize(
    bar_omi = mean(omi_no2),
    bar_pred = mean(pred.no2.cv))

m1.fit.all.s    <- lm(bar_omi ~ bar_pred, data=spatial_all)
r2.spatial      <- summary(m1.fit.all.s)$r.squared
rmse.spatial    <- ModelMetrics::rmse(modelObject = m1.fit.all.s)
spatial.inter   <- summary(m1.fit.all.s)$coef[1,1]
spatial.slope   <- summary(m1.fit.all.s)$coef[2,1]

# Temporal
temporal_all    <- left_join(mod.all,spatial_all)
del_no2         <- temporal_all$omi_no2-temporal_all$bar_omi
del_pred        <- temporal_all$pred.no2.cv-temporal_all$bar_pred
mod_temporal    <- lm(del_no2 ~ del_pred)
r2.temporal     <- summary(mod_temporal)$r.squared
rmse.temporal   <- ModelMetrics::rmse(modelObject = mod_temporal)
temporal.inter  <- summary(mod_temporal)$coef[1,1]
temporal.slope  <- summary(mod_temporal)$coef[2,1]

# Results
options(scipen=999)
cv.results <<- rbind(r2.all,      rmspe,         inter,          slope,
                     r2.spatial,  rmse.spatial,  spatial.inter,  spatial.slope, 
                     r2.temporal, rmse.temporal, temporal.inter, temporal.slope)
cv.results <- round(cv.results,digits=3)
print(cv.results)
# r2.all         0.960
# rmspe          0.000
# inter          0.000
# slope          1.000
# r2.spatial     0.972
# rmse.spatial   0.000
# spatial.inter  0.000
# spatial.slope  1.000
# r2.temporal    0.957
# rmse.temporal  0.000
# temporal.inter 0.000
# temporal.slope 0.999

# rmspe now looks normal



#### Predicting for Full Dataset ####
set.seed(824)
s1 <- dta2

formula <- as.formula(omi_no2 ~ cams_no2 + lon + lat + blh + temp_2m)
mod1 <- ranger(formula, data=s1, num.trees=50, mtry=4)
mod1$prediction.error #0.000000000000002341486
mod1$r.squared #0.9987803

## this is rather high...let's try stepwise
formula <- as.formula(omi_no2 ~ cams_no2)
mod1 <- ranger(formula, data=s1, num.trees=50, mtry=1)
mod1$prediction.error #0.0000000000005676973
mod1$r.squared #0.7042699

formula <- as.formula(omi_no2 ~ cams_no2 + lon)
mod1 <- ranger(formula, data=s1, num.trees=50, mtry=2)
mod1$prediction.error #0.0000000000005572118
mod1$r.squared #0.7097321

formula <- as.formula(omi_no2 ~ cams_no2 + lat)
mod1 <- ranger(formula, data=s1, num.trees=50, mtry=2)
mod1$prediction.error #0.00000000000003799944
mod1$r.squared #0.980205

formula <- as.formula(omi_no2 ~ cams_no2 + blh)
mod1 <- ranger(formula, data=s1, num.trees=50, mtry=2)
mod1$prediction.error #0.0000000000002078185
mod1$r.squared #0.8917413

formula <- as.formula(omi_no2 ~ cams_no2 + temp_2m)
mod1 <- ranger(formula, data=s1, num.trees=50, mtry=2)
mod1$prediction.error #0.00000000000007660408
mod1$r.squared #0.9600947

formula <- as.formula(omi_no2 ~ cams_no2 + lon + lat)
mod1 <- ranger(formula, data=s1, num.trees=50, mtry=3)
mod1$prediction.error #0.00000000000001914271
mod1$r.squared #0.990028

formula <- as.formula(omi_no2 ~ cams_no2 + lon + blh)
mod1 <- ranger(formula, data=s1, num.trees=50, mtry=3)
mod1$prediction.error #0.0000000000001679865
mod1$r.squared #0.9124909

formula <- as.formula(omi_no2 ~ cams_no2 + lon + temp_2m)
mod1 <- ranger(formula, data=s1, num.trees=50, mtry=3)
mod1$prediction.error #0.00000000000005407368
mod1$r.squared #0.9718314

formula <- as.formula(omi_no2 ~ cams_no2 + lat + blh)
mod1 <- ranger(formula, data=s1, num.trees=50, mtry=3)
mod1$prediction.error #0.00000000000003054467
mod1$r.squared #0.9840884

formula <- as.formula(omi_no2 ~ cams_no2 + lat + temp_2m)
mod1 <- ranger(formula, data=s1, num.trees=50, mtry=3)
mod1$prediction.error #0.00000000000001920516
mod1$r.squared #0.9899955

formula <- as.formula(omi_no2 ~ cams_no2 + blh + temp_2m)
mod1 <- ranger(formula, data=s1, num.trees=50, mtry=3)
mod1$prediction.error #0.00000000000006652589
mod1$r.squared #0.9655451

formula <- as.formula(omi_no2 ~ cams_no2 + lon + lat + blh)
mod1 <- ranger(formula, data=s1, num.trees=50, mtry=4)
mod1$prediction.error #0.000000000000002477485
mod1$r.squared #0.9987109

formula <- as.formula(omi_no2 ~ cams_no2 + lon + lat + temp_2m)
mod1 <- ranger(formula, data=s1, num.trees=50, mtry=4)
mod1$prediction.error #0.000000000000002635576
mod1$r.squared #0.9986271

## based on this, Itai recommended that we use the cams_no2 + temp_2m only model
formula <- as.formula(omi_no2 ~ cams_no2 + temp_2m)
mod1 <- ranger(formula, data=s1, num.trees=50, mtry=2)
mod1$prediction.error #0.00000000000007660745
mod1$r.squared #0.9600929

dta$pred_no2  <- predict(mod1, dta)$predictions

# Replace observed NO2 to predicted, when observed are available
dta <- as.data.table(dta)
dta[,rf_no2 := pred_no2]
dta[!is.na(omi_no2), rf_no2 := omi_no2]

cor(dta$pred_no2, dta$rf_no2) #0.9799225
cor(dta$omi_no2, dta$pred_no2, use = "complete.obs") #0.9565511
cor(dta$omi_no2, dta$rf_no2, use = "complete.obs") #1


## Extract relevant information (update with final model)
output <- dta %>%
  select(x, y, lon, lat, grid_id, date, rf_no2)

setwd("/media/hd/no2_israel/processed_data")
#write_csv(output, "rf_no2.csv")
