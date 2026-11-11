#### Pre-modeling: checking old file ####
#### July 7, 2023 ####

## The purpose of this code is to check Mark's existing code base and check data format
## Also to subset out grids from the dataset

#### Load packages ####
library(tidyverse)
library(fst)



#### Load Dataset ####
setwd("/media/hd/no2_israel/split/132.72.155.230:3838/qnap_share/P70.no2.o3.IL/work/full_grid")
dta <- read_fst("grid_04_19_ready_for_modeling.fst")


#### Extract grids and nonrepeating data ####
dta2 <- dta %>%
  dplyr::select(sinu_id, date, majorroads_length_km_km2_T1, nearest_road_dist_km_T1, 
                majorroads_length_km_km2_T2, nearest_road_dist_km_T2,
                majorroads_length_km_km2_T3, nearest_road_dist_km_T3,
                majorroads_length_km_km2_T4, nearest_road_dist_km_T4,
                railways_length_km_km2, railways_dist_km, wb_dist_km,
                Ag_Pr, Pr_In_min, Pr_Ur, Elev, Pop_dens,
                X, Y, grid_lon, grid_lat)
dta2$date <- as.Date(dta2$date, format = "%Y-%m-%d")

## Subset of two days to test if datasets are identical
test1 <- filter(dta2, date == "2004-10-01") #16552
test2 <- filter(dta2, date == "2004-10-02") #16552
#86153160/16552 = 5205 days, which checks out

## Do a few checks of variables
test1$X == test2$X
unique(test1$X)

## Everything checks out here, so we can just keep the data for a single day
test1 <- test1 %>%
  dplyr::select(-date)

test2 <- test2 %>%
  dplyr::select(sinu_id, X, Y, grid_lon, grid_lat)

setwd("/media/hd/no2_israel/processed_data")
#write_csv(test1, "spatial_fixed.csv")
#write_csv(test2, "grids.csv")
