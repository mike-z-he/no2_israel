#### Prediction Stage Modeling (Generating full surfaces) ####
#### October 22, 2023 ####

## Updated 7/5/2024: added code in the end to subset dataset (GAM predictions only) for transfer to Maayan

## This script is largely based off of 20220530_3a_prediction_modeling.R

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
library(patchwork)
library(raster)
library(sf)
library(stars)


#### Load Dataset ####
setwd("/media/hd/no2_israel/processed_data")
s1 <- read_csv("second_stage_monitors_only.csv")

## Adding Julian date
s1$jd <- julian(s1$date)

## Formula
formula <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens + majorroads_length_km_km2_T2)

# Define the hyper-parameters for the Xgboost model
xgbGrid <- expand.grid(nrounds = 500, max_depth = 10, colsample_bytree = 0.678,
                       eta = 0.162, gamma=6, min_child_weight = 1, subsample = 1)
fitGBMMon <- trainControl(method = "none")

# (1) Fit the RF
mod1Def  <- ranger(formula, data=s1, num.trees=500, mtry=8, min.node.size = 2, importance="impurity", keep.inbag=TRUE, seed=824)

# (2) Fit the XgBoost Model
mod2Def  <-  caret::train(formula, data = s1,method = "xgbTree", trControl = fitGBMMon, verbose = FALSE, tuneGrid = xgbGrid)

# (3) Fit the ensemble GAM model using data predicted on the cross-validated database
s1.cv <- readRDS("calibration_cv_stage2_final.rds") # These are the cv predictions for all models
mod3Def <- gam(monitor_no2 ~ s(x, y , by=pred.rf)+
                 s(x, y, by=pred.bo)
               ,data=s1.cv)



#### Predict for all locations and days ####
## Load full dataset
setwd("/media/hd/no2_israel/processed_data")
stage3 <- read_rds("second_stage.rds")

## Adding Julian date
stage3$jd <- julian(stage3$date)
stage3 <- filter(stage3, date != "2005-02-07") ## to prevent issues later on
# tested summary of all variables at this point, and found no NAs after

## Predictions
stage3$pred.rf         <- predict(mod1Def, stage3)$predictions
stage3$pred.bo         <- predict(mod2Def, stage3)
stage3$pred.gam        <- predict(object=mod3Def, newdata=stage3)

dta <- stage3 %>%
  dplyr::select(x, y, lat, lon, 
                grid_id, date, year, month, Elev,
                omi_no2, monitor_no2, rf_no2,
                pred.rf, pred.bo, pred.gam)

## Checking % of negatives
dta2 <- dta %>%
  filter(pred.rf < 0) #0 negatives

dta3 <- dta %>%
  filter(pred.bo < 0) #134894 negatives (0.12%) for new preds
hist(dta3$pred.bo)

dta4 <- dta %>%
  filter(pred.gam < 0) #119011 negatives (0.11%) for new preds
hist(dta4$pred.gam)

## Replace negatives with 1's for pred.rf, pred.bo and pred.gam
dta$pred.bo <- replace(dta$pred.bo, dta$pred.bo<1, 1)
dta$pred.gam <- replace(dta$pred.gam, dta$pred.gam<1, 1)

summary(dta$pred.rf)
summary(dta$pred.bo)
summary(dta$pred.gam)

## everything looks good here

dta$pred.gam <- as.numeric(unlist(dta$pred.gam))

saveRDS(dta, "prediction_3a_final.rds")



#### Visualization ####
dta <- read_rds("prediction_3a_final.rds")
# Use group_by() first to plot by date
temporal <- dta %>%
  group_by(date) %>%
  summarize(mean_rf = mean(pred.rf),
            mean_bo = mean(pred.bo),
            mean_gam = mean(pred.gam))


a <- ggplot(temporal, aes(x = date, y = mean_rf)) +
  geom_line()

b <- ggplot(temporal, aes(x = date, y = mean_bo)) +
  geom_line()

c <- ggplot(temporal, aes(x = date, y = mean_gam)) +
  geom_line()

a / b / c #trends look good



#### Spatial Trends ####
spatial <- dta %>%
  group_by(grid_id) %>%
  summarize(x = mean(lon),
            y = mean(lat),
            mean_rf = mean(pred.rf),
            mean_bo = mean(pred.bo),
            mean_gam = mean(pred.gam)
  )

spatial_rf <- spatial %>%
  dplyr::select(x, y, mean_rf)
spatial_bo <- spatial %>%
  dplyr::select(x, y, mean_bo)
spatial_gam <- spatial %>%
  dplyr::select(x, y, mean_gam)

spatial_rf <- st_as_sf(spatial_rf, coords=c("x", "y"), crs=4326)
spatial_bo <- st_as_sf(spatial_bo, coords=c("x", "y"), crs=4326)
spatial_gam <- st_as_sf(spatial_gam, coords=c("x", "y"), crs=4326)

plot(spatial_rf)
plot(spatial_bo)
plot(spatial_gam)



#### Making plots with Michael's code ####
# Read
r = read_stars('template.tif')

# Prepare template
crs = st_crs(r)
r = st_set_dimensions(r, 'x', offset = st_dimensions(r)$x$offset + st_dimensions(r)$x$delta/2, delta = st_dimensions(r)$x$delta)
r = st_set_dimensions(r, 'y', offset = st_dimensions(r)$y$offset + st_dimensions(r)$y$delta/2, delta = st_dimensions(r)$y$delta)
r = st_set_crs(r, crs)

# To points
spatial_rf <- st_transform(spatial_rf, st_crs(r))
spatial_bo <- st_transform(spatial_bo, st_crs(r))
spatial_gam <- st_transform(spatial_gam, st_crs(r))

# Rasterize
r_rf = st_rasterize(spatial_rf['mean_rf'], r)
r_bo = st_rasterize(spatial_bo['mean_bo'], r)
r_gam = st_rasterize(spatial_gam['mean_gam'], r)

plot(r_rf)
plot(r_bo)
plot(r_gam)

## Make a regular raster?
st_as_raster <- function(rstars){
  rext <- st_bbox(rstars)
  raster(t(rstars[[1]]), xmn = rext[1], xmx = rext[3],
         ymn = rext[2], ymx=rext[4],
         crs = st_crs(rstars)$proj4string)
}

raster_rf <- st_as_raster(r_rf)
raster_bo <- st_as_raster(r_bo)
raster_gam <- st_as_raster(r_gam)

plot(raster_rf)
plot(raster_bo)
plot(raster_gam)

#spatial_rf <- rasterFromXYZ(spatial_rf, crs = "+proj=sinu +lon_0=0 +x_0=0 +y_0=0 +R=6371007.181 +units=m +no_defs")
#spatial_bo <- rasterFromXYZ(spatial_bo, crs = "+proj=sinu +lon_0=0 +x_0=0 +y_0=0 +R=6371007.181 +units=m +no_defs")
#spatial_gam <- rasterFromXYZ(spatial_gam, crs = "+proj=sinu +lon_0=0 +x_0=0 +y_0=0 +R=6371007.181 +units=m +no_defs")



#### Testing residuals ####
## Process data and calculate residuals
resid <- dta %>%
  dplyr::select(grid_id, date, monitor_no2, pred.gam) %>%
  rename(ensemble_no2 = pred.gam) %>%
  mutate(resid_no2 = monitor_no2 - ensemble_no2) %>%
  drop_na(resid_no2) #n=470410; slight missing from full monitor dataset of s1 (n=470472)

resid <- resid %>%
  dplyr::select(-monitor_no2)

s4 <- left_join(s1, resid, by = c("grid_id", "date"))

s4 <- s4 %>%
  drop_na(resid_no2)




#### Preliminary Residual Calibration ####
set.seed(824)
formula_1 <- as.formula(resid_no2 ~ wind_u)
formula_2 <- as.formula(resid_no2 ~ wind_u + wind_v)
formula_3 <- as.formula(resid_no2 ~ wind_u + wind_v + temp_2m)
formula_4 <- as.formula(resid_no2 ~ wind_u + wind_v + temp_2m + blh)
formula_5 <- as.formula(resid_no2 ~ wind_u + wind_v + temp_2m + blh + Elev)
formula_6 <- as.formula(resid_no2 ~ wind_u + wind_v + temp_2m + blh + Elev + jd)
formula_7 <- as.formula(resid_no2 ~ wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens)
formula_8 <- as.formula(resid_no2 ~ wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens + majorroads_length_km_km2_T2)
## baseline models are doing terribly...let's add some extra variables

formula_9 <- as.formula(resid_no2 ~ wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens + majorroads_length_km_km2_T2 + railways_length_km_km2)
formula_10 <- as.formula(resid_no2 ~ wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens + majorroads_length_km_km2_T2 + railways_length_km_km2 + Ag_Pr + Pr_In_min + Pr_Ur)


mod1 <- ranger(formula_1, data=s4, num.trees=50, mtry=1)
mod1$prediction.error
mod1$r.squared
#OOB.RMSE= 7.217803 OOB.R2= -0.1200424 RUN in ~ 1 minute.

mod2 <- ranger(formula_2, data=s4, num.trees=50, mtry=2)
mod2$prediction.error
mod2$r.squared
#OOB.RMSE= 6.806428 OOB.R2= -0.05620625 RUN in ~ 1 minute.

mod3 <- ranger(formula_3, data=s4, num.trees=50, mtry=3)
mod3$prediction.error
mod3$r.squared
#OOB.RMSE= 6.722749 OOB.R2= -0.04322107 RUN in ~ 1 minute.

mod4 <- ranger(formula_4, data=s4, num.trees=50, mtry=4)
mod4$prediction.error
mod4$r.squared
#OOB.RMSE= 6.591718 OOB.R2= -0.02288795 RUN in ~ 1 minute.

mod5 <- ranger(formula_5, data=s4, num.trees=50, mtry=5)
mod5$prediction.error
mod5$r.squared
#OOB.RMSE= 6.558324 OOB.R2= -0.01770599 RUN in ~ 1 minute.

mod6 <- ranger(formula_6, data=s4, num.trees=50, mtry=6)
mod6$prediction.error
mod6$r.squared
#OOB.RMSE= 6.180547 OOB.R2= 0.04091657 RUN in ~ 1 minute.

mod7 <- ranger(formula_7, data=s4, num.trees=50, mtry=7)
mod7$prediction.error
mod7$r.squared
#OOB.RMSE= 6.055668 OOB.R2= 0.06029505 RUN in ~ 1 minute.

mod8 <- ranger(formula_8, data=s4, num.trees=50, mtry=8)
mod8$prediction.error
mod8$r.squared
#OOB.RMSE= 6.118175 OOB.R2= 0.05059531 RUN in ~ 1 minute.

## New models
mod9 <- ranger(formula_9, data=s4, num.trees=50, mtry=8)
mod9$prediction.error
mod9$r.squared
#OOB.RMSE= 6.099849 OOB.R2= 0.05343913 RUN in ~ 1 minute.

mod9 <- ranger(formula_9, data=s4, num.trees=50, mtry=8)
mod9$prediction.error
mod9$r.squared
#OOB.RMSE= 6.099849 OOB.R2= 0.05343913 RUN in ~ 1 minute.

mod10 <- ranger(formula_10, data=s4, num.trees=50, mtry=11)
mod10$prediction.error
mod10$r.squared
#OOB.RMSE= 6.092242 OOB.R2= 0.05461947 RUN in ~ 1 minute.


#### Adding monitor locations ####
setwd("/home/mike/Desktop/no2_model_mexico_city/data/processed_data")
monitor <- read_csv("monitor_grid_matched.csv", col_types = 
                      list(col_double(), col_double(), col_date(format = "%m/%d/%Y"), 
                           col_character(), col_double()))

monitor <- monitor %>%
  drop_na(monitor_no2) %>%
  filter(date != "2019-12-31")

monitor <- monitor %>%
  group_by(monitor) %>%
  summarize(x = mean(x),
            y = mean(y),
            mean_no2 = mean(monitor_no2, na.rm = T))

coords <- monitor %>%
  dplyr::select(x, y)

no2 <- monitor %>%
  dplyr::select(mean_no2)

no2 <- SpatialPointsDataFrame(coords = coords, data = no2, 
                              proj4string = CRS("+proj=sinu +lon_0=0 +x_0=0 +y_0=0 +R=6371007.181 +units=m +no_defs"),)

plot(spatial_rf)
plot(no2, add = T)


#### Extra code: clean up and add to 20220805_6_plots.R ####
annual <- s1 %>%
  group_by(year) %>%
  summarize(mean_no2 = mean(monitor_no2))

temporal$year <- year(temporal$date)
annual_2 <- temporal %>%
  group_by(year) %>%
  summarize(mean_gam = mean(mean_gam))


#### Create exportable file for Stage 3 NO2 predictions ####
dta <- read_rds("prediction_3a_final.rds")

dta_final <- dta %>%
  dplyr::select(x, y, lat, lon, grid_id, date, pred.gam)

saveRDS(dta_final, "prediction_3a_final_export.rds")
