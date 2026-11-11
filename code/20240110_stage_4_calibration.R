#### Calibration for Stage 4 NO2 Modeling ####
#### January 10, 2024 ####


## The goal of this script is to run preliminary calibration for the residual data
## Need to still match time-fixed data (road and elevation) to dataset


#### Load packages ####
library(tidyverse)
library(ranger)
library(doParallel)
library(foreach)
library(data.table)

setwd("/home/mike/Desktop/no2_model_mexico_city/code/helpers")
source("per_meas.R")


#### Load and merge with time-fixed data ####
setwd("/media/hd/no2_israel/processed_data")
dta <- read_csv("fourth_stage_monitors_only.csv")

road <- read_csv("road_200m_grid_matched.csv")
ele <- read_csv("elevation_200m_grid_matched.csv")

fixed <- left_join(road, ele, by = c("grid_id", "X", "Y")) %>%
  dplyr::select(grid_id, elev, road_length_m)

dta <- left_join(dta, fixed, by = "grid_id")



#### Preliminary Residual Calibration using RF (Skip) ####
set.seed(824)
formula_1 <- as.formula(resid_no2 ~ wind_u)
formula_2 <- as.formula(resid_no2 ~ wind_u + wind_v)
formula_3 <- as.formula(resid_no2 ~ wind_u + wind_v + temp_2m)
formula_4 <- as.formula(resid_no2 ~ wind_u + wind_v + temp_2m + blh)
formula_5 <- as.formula(resid_no2 ~ wind_u + wind_v + temp_2m + blh + cloud)
formula_6 <- as.formula(resid_no2 ~ wind_u + wind_v + temp_2m + blh + cloud + elev)
formula_7 <- as.formula(resid_no2 ~ wind_u + wind_v + temp_2m + blh + cloud + elev + road_length_m)

mod1 <- ranger(formula_1, data=dta, num.trees=50, mtry=1)
mod1$prediction.error
mod1$r.squared
#OOB.RMSE= 7.227188 OOB.R2= -0.1214988 RUN in ~ 1 minute.

mod2 <- ranger(formula_2, data=dta, num.trees=50, mtry=2)
mod2$prediction.error
mod2$r.squared
#OOB.RMSE= 6.803622 OOB.R2= -0.05577076 RUN in ~ 1 minute.

mod3 <- ranger(formula_3, data=dta, num.trees=50, mtry=3)
mod3$prediction.error
mod3$r.squared
#OOB.RMSE= 6.715232 OOB.R2= -0.04205466 RUN in ~ 1 minute.

mod4 <- ranger(formula_4, data=dta, num.trees=50, mtry=4)
mod4$prediction.error
mod4$r.squared
#OOB.RMSE= 6.598617 OOB.R2= -0.02395853 RUN in ~ 1 minute.

mod5 <- ranger(formula_5, data=dta, num.trees=50, mtry=5)
mod5$prediction.error
mod5$r.squared
#OOB.RMSE= 6.511255 OOB.R2= -0.01040194 RUN in ~ 1 minute.

mod6 <- ranger(formula_6, data=dta, num.trees=50, mtry=6)
mod6$prediction.error
mod6$r.squared
#OOB.RMSE= 6.441683 OOB.R2= 0.0003941119 RUN in ~ 1 minute.

mod7 <- ranger(formula_7, data=dta, num.trees=50, mtry=7)
mod7$prediction.error
mod7$r.squared
#OOB.RMSE= 6.321149 OOB.R2= 0.0190983 RUN in ~ 1 minute.



#### Calibration using XGBoost ####
## Formula
s1 <- dta
formula <- as.formula(resid_no2 ~ wind_u + wind_v + temp_2m + blh + cloud + elev + road_length_m)

# Define the hyper-parameters for the Xgboost model
xgbGrid <- expand.grid(nrounds =500, max_depth = 16, colsample_bytree = 0.631,
                       eta = 0.01, gamma=6, min_child_weight = 9,subsample = 1)
fitGBMMon <- caret::trainControl( method = "none")

## Check and play around with tuning RF

#### Data processing ####
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

#### Validation (90% each time and predict on 10% excluded from validation of ensemble) ####
ptm <- proc.time()
c1 <- makeCluster(16)
registerDoParallel(c1)

validation =  foreach (i=1:10, .packages = c("data.table") ) %dopar% {
  
  # First we create the train and validation data in order to produce NO2 predictions for the 10% validation from the learners
  train                 <- subset(s1, split!=i)
  validation            <- subset(s1, split==i)
  
  # XGBoost ############################################
  mod1  <-  caret::train(formula, data = s1, method = "xgbTree", trControl = fitGBMMon, verbose = FALSE, tuneGrid = xgbGrid)
  validation$pred.bo <- predict(mod1, validation)
  
  
  validation$Outer_iter <- i
  validation <- validation[,list(date, grid_id, X, Y,
                                 resid_no2, pred.bo,
                                 Outer_iter)]
  
}
stopCluster(c1) 
proc.time() - ptm # ~about 70 mins

# Bind all validation predictions together
validation_res <- do.call(rbind, validation)

# Make sure we have out-of-sample predictions at the same size of original data
nrow(validation_res)==nrow(s1)

#### Bind results for all models and calculate CV performance ####
validation_res <- as.data.frame(validation_res)

cv_res_bo <- per_meas(y=validation_res$resid_no2, x=validation_res$pred.bo, data=validation_res, name_y = "resid_no2", name_x = "pred.bo")
cv_res_bo <- as.data.frame(cv_res_bo)
colnames(cv_res_bo) <- "bo"
#write_csv(cv_res_bo, "residual_4b_cv_metrics_bo_only.csv")



#### Run predictions for full layer ####
## Load full datasets
setwd("/media/hd/no2_israel/processed_data")
resid <- read_csv("resid_200m_grid_matched.csv") %>%
  dplyr::select(-X, -Y)

# Define the hyper-parameters for the Xgboost model
xgbGrid <- expand.grid(nrounds =500, max_depth = 16, colsample_bytree = 0.631,
                       eta = 0.01, gamma=6, min_child_weight = 9,subsample = 1)
fitGBMMon <- caret::trainControl( method = "none")

formula <- as.formula(resid_no2 ~ wind_u + wind_v + temp_2m + blh + cloud + elev + road_length_m)
mod1  <-  caret::train(formula, data = dta, method = "xgbTree", trControl = fitGBMMon, verbose = FALSE, tuneGrid = xgbGrid)

dta_04_10 <- read_rds("era5_200m_04_10.rds")
dta_04_10 <- left_join(dta_04_10, resid, by = c("grid_id", "date"))
dta_04_10 <- left_join(dta_04_10, fixed, by = "grid_id")
dta_04_10$pred.bo           <- predict(mod1, dta_04_10)

dta_11_16 <- read_rds("era5_200m_11_16.rds")
dta_11_16 <- left_join(dta_11_16, resid, by = c("grid_id", "date"))
dta_11_16 <- left_join(dta_11_16, fixed, by = "grid_id")
dta_11_16$pred.bo           <- predict(mod1, dta_11_16)

dta_17_22 <- read_rds("era5_200m_17_22.rds")
dta_17_22 <- left_join(dta_17_22, resid, by = c("grid_id", "date"))
dta_17_22 <- left_join(dta_17_22, fixed, by = "grid_id")
dta_17_22$pred.bo           <- predict(mod1, dta_17_22)

## svm and regular gradient boosting?

## Too much data...will need to predict one at a time
## Updated 2/19: full dataset then subsetting worked; just need to be careful
## to not exceed RAM

dta_04_10 <- dta_04_10 %>%
  dplyr::select(grid_id, X, Y, date, resid_no2, pred.bo)

dta_11_16 <- dta_11_16 %>%
  dplyr::select(grid_id, X, Y, date, resid_no2, pred.bo)

dta_17_22 <- dta_17_22 %>%
  dplyr::select(grid_id, X, Y, date, resid_no2, pred.bo)

## Save results
setwd("/media/hd/no2_israel/processed_data")
#saveRDS(dta_04_10, "residual_4b_predictions_04_10.rds")
#saveRDS(dta_11_16, "residual_4b_predictions_11_16.rds")
#saveRDS(dta_17_22, "residual_4b_predictions_17_22.rds")



#### Quick check of temporal trends for residuals ####
dta_04_10 <- read_rds("residual_4b_predictions_04_10.rds")
dta_11_16 <- read_rds("residual_4b_predictions_11_16.rds")
dta_17_22 <- read_rds("residual_4b_predictions_17_22.rds")

library(patchwork)

# Use group_by() first to plot by date
temporal_04_10 <- dta_04_10 %>%
  group_by(date) %>%
  summarize(mean_bo = mean(pred.bo))

temporal_11_16 <- dta_11_16 %>%
  group_by(date) %>%
  summarize(mean_bo = mean(pred.bo))

temporal_17_22 <- dta_17_22 %>%
  group_by(date) %>%
  summarize(mean_bo = mean(pred.bo))


a <- ggplot(temporal_04_10, aes(x = date, y = mean_bo)) +
  geom_line()

b <- ggplot(temporal_11_16, aes(x = date, y = mean_bo)) +
  geom_line()

c <- ggplot(temporal_17_22, aes(x = date, y = mean_bo)) +
  geom_line()

a / b / c #trends look okay

d <- ggplot(temporal_04_10, aes(x = mean_bo)) +
  geom_histogram()

e <- ggplot(temporal_11_16, aes(x = mean_bo)) +
  geom_histogram()

f <- ggplot(temporal_17_22, aes(x = mean_bo)) +
  geom_histogram()

d / e / f



#### Making plots with Michael's code ####
# Preprocessing
spatial_04_10 <- dta_04_10 %>%
  group_by(grid_id) %>%
  summarize(x = mean(X),
            y = mean(Y),
            mean_bo = mean(pred.bo))

spatial_11_16 <- dta_11_16 %>%
  group_by(grid_id) %>%
  summarize(x = mean(X),
            y = mean(Y),
            mean_bo = mean(pred.bo))

spatial_17_22 <- dta_17_22 %>%
  group_by(grid_id) %>%
  summarize(x = mean(X),
            y = mean(Y),
            mean_bo = mean(pred.bo))

spatial_04_10 <- st_as_sf(spatial_04_10, coords=c("x", "y"), crs=4326)
spatial_11_16 <- st_as_sf(spatial_11_16, coords=c("x", "y"), crs=4326)
spatial_17_22 <- st_as_sf(spatial_17_22, coords=c("x", "y"), crs=4326)

plot(spatial_04_10)
plot(spatial_11_16)
plot(spatial_17_22)


g <- ggplot(spatial_04_10, aes(x = mean_bo)) +
  geom_histogram()

h <- ggplot(spatial_11_16, aes(x = mean_bo)) +
  geom_histogram()

i <- ggplot(spatial_17_22, aes(x = mean_bo)) +
  geom_histogram()

g / h / i


## Michael's code
library(stars)
library(raster)

# Read
r = read_stars('template_200m_cropped_masked.tif')

# Prepare template
crs = st_crs(r)
r = st_set_dimensions(r, 'x', offset = st_dimensions(r)$x$offset + st_dimensions(r)$x$delta/2, delta = st_dimensions(r)$x$delta)
r = st_set_dimensions(r, 'y', offset = st_dimensions(r)$y$offset + st_dimensions(r)$y$delta/2, delta = st_dimensions(r)$y$delta)
r = st_set_crs(r, crs)

# To points
spatial_04_10 <- st_transform(spatial_04_10, st_crs(r))
spatial_11_16 <- st_transform(spatial_11_16, st_crs(r))
spatial_17_22 <- st_transform(spatial_17_22, st_crs(r))

# Rasterize
r_04_10 = st_rasterize(spatial_04_10['mean_bo'], r)
r_11_16 = st_rasterize(spatial_11_16['mean_bo'], r)
r_17_22 = st_rasterize(spatial_17_22['mean_bo'], r)

plot(r_04_10)
plot(r_bo)
plot(r_gam)

## Make a regular raster?
st_as_raster <- function(rstars){
  rext <- st_bbox(rstars)
  raster(t(rstars[[1]]), xmn = rext[1], xmx = rext[3],
         ymn = rext[2], ymx=rext[4],
         crs = st_crs(rstars)$proj4string)
}

raster_04_10 <- st_as_raster(r_04_10)
raster_11_16 <- st_as_raster(r_11_16)
raster_17_22 <- st_as_raster(r_17_22)

## Michael's code doesn't work here...not sure what to do to remove NAs from stars


