#### Building Dataset for Stage 2 NO2 Modeling ####
#### October 10, 2023 ####

## The goal of this code is to load in the full stage 1 data, RF data, and stage 2 data
## Create full Stage 2 and monitor only Stage 2 datasets


#### Load packages ####
library(tidyverse)



#### Load data ####
setwd("/media/hd/no2_israel/processed_data")

dta <- read_csv("first_stage.csv") #n=110335632
rf <- read_csv("rf_no2.csv") #n=110320079, 15553 missing from 2005-02-07
monitor <- read_csv("monitor_avg.csv") #n=470472
#dta_grid <- read_csv("grids_date_id.csv") #n=110320079, date grids

## Process and merge data
rf <- rf %>%
  dplyr::select(lon, lat, date, rf_no2)
dta <- left_join(dta, rf, by = c("lon", "lat", "date"))
rm(rf)

#dta <- left_join(dta, dta_grid, by = c("lon", "lat", "date"))
#rm(dta_grid)

dta <- left_join(dta, monitor, by = c("grid_id", "date"))
summary(dta$no2) #NA=109865222; 110335632-109865222=470410; 470472-470410=62 not matched (the 2005-02-07s)

dta <- dta %>%
  rename(monitor_no2 = no2)

#### Subset of data with monitors only ####
dta2 <- dta %>%
  drop_na(monitor_no2) 

#dta3 <- dta2 %>%
#  filter(date == "2005-02-07") #n=0, so we're good

## Save files
## Write full and subsets
write_rds(dta, "second_stage.rds")
write_csv(dta2, "second_stage_monitors_only.csv")
