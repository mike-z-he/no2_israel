#### Stage 2 NO2 Modeling ####
#### October 10, 2023 ####

## Reran on 12/8


#### Load Packages ####
library(tidyverse)
library(ranger)


#### Load Dataset ####
setwd("/media/hd/no2_israel/processed_data")
dta <- read_csv("second_stage_monitors_only.csv")

## Adding Julian date
dta$jd <- julian(dta$date)

#### Preliminary Random Forest Modeling ####
set.seed(824)
formula <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + cloud + elevation + road_length + jd)

formula <- as.formula(monitor_no2 ~ rf_no2)
formula2 <- as.formula(monitor_no2 ~ rf_no2 + wind_u)
formula3 <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v)
formula4 <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m)
formula5 <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh)
formula6 <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + Elev)
formula7 <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + Elev + jd)
formula8 <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens)

## testing roads
#formula9_1 <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens + majorroads_length_km_km2_T1)
#formula9_2 <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens + nearest_road_dist_km_T1)
formula9_3 <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens + majorroads_length_km_km2_T2)
#formula9_4 <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens + nearest_road_dist_km_T2)
#formula9_5 <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens + majorroads_length_km_km2_T3)
#formula9_6 <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens + nearest_road_dist_km_T3)
#formula9_7 <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens + majorroads_length_km_km2_T4)
#formula9_8 <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens + nearest_road_dist_km_T4)

## Continuing with other variables
formula10_1 <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens + majorroads_length_km_km2_T2 + railways_length_km_km2)
formula10_2 <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens + majorroads_length_km_km2_T2 + railways_dist_km)
formula10_3 <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens + majorroads_length_km_km2_T2 + wb_dist_km)

## rail/wb_dist also pretty useless...will omit

formula11 <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens + majorroads_length_km_km2_T2 + Ag_Pr)
formula12 <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens + majorroads_length_km_km2_T2 + Pr_In_min)
formula13 <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens + majorroads_length_km_km2_T2 + Pr_Ur)


mod1 <- ranger(formula, data=dta, num.trees=50, mtry=1)
mod1$prediction.error
mod1$r.squared
#OOB.RMSE= 75.05817 OOB.R2= 0.3513065 RUN in ~ 1 minute.

mod2 <- ranger(formula2, data=dta, num.trees=50, mtry=2)
mod2$prediction.error
mod2$r.squared
#OOB.RMSE= 68.81223 OOB.R2= 0.4052873 RUN in ~ 1 minute.

mod3 <- ranger(formula3, data=dta, num.trees=50, mtry=3)
mod3$prediction.error
mod3$r.squared
#OOB.RMSE= 66.66673 OOB.R2= 0.4238298 RUN in ~ 1 minute.

mod4 <- ranger(formula4, data=dta, num.trees=50, mtry=4)
mod4$prediction.error
mod4$r.squared
#OOB.RMSE= 64.77756 OOB.R2= 0.4401571 RUN in ~ 1 minute.

mod5 <- ranger(formula5, data=dta, num.trees=50, mtry=5)
mod5$prediction.error
mod5$r.squared
#OOB.RMSE= 61.80011 OOB.R2= 0.4658898 RUN in ~ 1 minute.

mod6 <- ranger(formula6, data=dta, num.trees=50, mtry=6)
mod6$prediction.error
mod6$r.squared
#OOB.RMSE= 36.44038 OOB.R2= 0.6850624 RUN in ~ 1 minute.

mod7 <- ranger(formula7, data=dta, num.trees=50, mtry=7)
mod7$prediction.error
mod7$r.squared
#OOB.RMSE= 23.05527 OOB.R2= 0.8007438 RUN in ~ 1 minute.

mod8 <- ranger(formula8, data=dta, num.trees=50, mtry=8)
mod8$prediction.error
mod8$r.squared
#OOB.RMSE= 22.16367 OOB.R2= 0.8084495 RUN in ~ 1 minute.

## Road variables testing
## did not rerun this section on 12/8
mod9_1 <- ranger(formula9_1, data=dta, num.trees=50, mtry=9)
mod9_1$prediction.error
mod9_1$r.squared
#OOB.RMSE= 22.97141 OOB.R2= 0.8014805 RUN in ~ 1 minute.

mod9_2 <- ranger(formula9_2, data=dta, num.trees=50, mtry=9)
mod9_2$prediction.error
mod9_2$r.squared
#OOB.RMSE= 22.84929 OOB.R2= 0.8025359 RUN in ~ 1 minute.

mod9_3 <- ranger(formula9_3, data=dta, num.trees=50, mtry=9)
mod9_3$prediction.error
mod9_3$r.squared
#OOB.RMSE= 22.59891 OOB.R2= 0.8046996 RUN in ~ 1 minute.

mod9_4 <- ranger(formula9_4, data=dta, num.trees=50, mtry=9)
mod9_4$prediction.error
mod9_4$r.squared
#OOB.RMSE= 23.13089 OOB.R2=  0.8001023 RUN in ~ 1 minute.

mod9_5 <- ranger(formula9_5, data=dta, num.trees=50, mtry=9)
mod9_5$prediction.error
mod9_5$r.squared
#OOB.RMSE= 23.05606 OOB.R2= 0.8007489 RUN in ~ 1 minute.

mod9_6 <- ranger(formula9_6, data=dta, num.trees=50, mtry=9)
mod9_6$prediction.error
mod9_6$r.squared
#OOB.RMSE= 23.06596 OOB.R2= 0.8006634 RUN in ~ 1 minute.

mod9_7 <- ranger(formula9_7, data=dta, num.trees=50, mtry=9)
mod9_7$prediction.error
mod9_7$r.squared
#OOB.RMSE= 22.802 OOB.R2= 0.8029445 RUN in ~ 1 minute.

mod9_8 <- ranger(formula9_8, data=dta, num.trees=50, mtry=9)
mod9_8$prediction.error
mod9_8$r.squared
#OOB.RMSE= 23.26798 OOB.R2= 0.7989175 RUN in ~ 1 minute.

## Conclusion: all are pretty useless...but we'll keep mod9_3

## continuing with other variables
mod10_1 <- ranger(formula10_1, data=dta, num.trees=50, mtry=10)
mod10_1$prediction.error
mod10_1$r.squared
#OOB.RMSE= 21.88331 OOB.R2= 0.8108725 RUN in ~ 1 minute.

mod10_2 <- ranger(formula10_2, data=dta, num.trees=50, mtry=10)
mod10_2$prediction.error
mod10_2$r.squared
#OOB.RMSE= 22.17652 OOB.R2= 0.8083384 RUN in ~ 1 minute.

mod10_3 <- ranger(formula10_3, data=dta, num.trees=50, mtry=10)
mod10_3$prediction.error
mod10_3$r.squared
#OOB.RMSE= 22.7112 OOB.R2= 0.8122775 RUN in ~ 1 minute.

mod11 <- ranger(formula11, data=dta, num.trees=50, mtry=10)
mod11$prediction.error
mod11$r.squared
#OOB.RMSE= 21.75526 OOB.R2= 0.8119792 RUN in ~ 1 minute.

mod12 <- ranger(formula12, data=dta, num.trees=50, mtry=10)
mod12$prediction.error
mod12$r.squared
#OOB.RMSE= 22.00494 OOB.R2= 0.8098214 RUN in ~ 1 minute.

mod13 <- ranger(formula13, data=dta, num.trees=50, mtry=10)
mod13$prediction.error
mod13$r.squared
#OOB.RMSE= 22.16101 OOB.R2= 0.8084725 RUN in ~ 1 minute.

## After full set of variable testing, it appears mod8 is the best one
## Now test num.tree and mtry (n-1 is good)
formula_final <- as.formula(monitor_no2 ~ rf_no2 + wind_u + wind_v + temp_2m + blh + Elev + jd + Pop_dens + majorroads_length_km_km2_T2)
mod <- ranger(formula_final, data=dta, num.trees=500, mtry=8)
mod$prediction.error
mod$r.squared
#OOB.RMSE= 20.50471 OOB.R2= 0.8227871 RUN in ~ 3 minute. (num.trees = 500)