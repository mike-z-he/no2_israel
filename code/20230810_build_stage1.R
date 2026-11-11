#### Building Stage 1 Dataset ####
#### August 10, 2023 ####


## The purpose of this code is to build the full dataset necessary
## For the imputation of the missing OMI data with CAMS
## Code is adapted from 20210617_build_stage1.R from the Mexico model

## Cannot read more files after 2015-12-02...will break this down into two groups
## 2004 to 2014; 2015 to 2022

## Update 12/5: reran this code with updated datasets


#### Load Packages ####
library(tidyverse)
library(lubridate)

options(mc.cores=parallel::detectCores())


#### Build grids by date ####
setwd("/media/hd/no2_israel/processed_data")
grid <- read_csv("grids_new.csv")

## Dates
dates <- as.data.frame(seq(as.Date("2004-10-01"), as.Date("2022-12-31"), by = 1))
names(dates)[1] <- "date"
grid_date <- merge(grid, dates) #110,335,632 obs, takes about 5 mins
grid <- grid_date
grid$year <- year(grid$date) #1 min
grid$month <- month(grid$date) #1 min



#### CAMS NO2 Data ####
setwd("/media/hd/no2_israel/processed_data/era5_no2/2004_2014")
file.list <- list.files(pattern='*.csv')
df.list <- lapply(file.list, read_csv)
df <- bind_rows(df.list)
cams <- df

setwd("/media/hd/no2_israel/processed_data/era5_no2/2015_2022")
file.list <- list.files(pattern='*.csv')
df.list <- lapply(file.list, read_csv)
df <- bind_rows(df.list)
cams2 <- df

cams <- rbind(cams, cams2)
rm(cams2)
gc()



#### ERA5 Data ####
setwd("/media/hd/no2_israel/processed_data/era5_single_levels/2004_2014")
file.list <- list.files(pattern='*.csv')
df.list <- lapply(file.list, read_csv)
df <- bind_rows(df.list)
era5_1 <- df

setwd("/media/hd/no2_israel/processed_data/era5_single_levels/2015_2022")
file.list <- list.files(pattern='*.csv')
df.list <- lapply(file.list, read_csv)
df <- bind_rows(df.list)
era5_1b <- df

setwd("/media/hd/no2_israel/processed_data/era5_land/2004_2014")
file.list <- list.files(pattern='*.csv')
df.list <- lapply(file.list, read_csv)
df <- bind_rows(df.list)
era5_2 <- df

setwd("/media/hd/no2_israel/processed_data/era5_land/2015_2022")
file.list <- list.files(pattern='*.csv')
df.list <- lapply(file.list, read_csv)
df <- bind_rows(df.list)
era5_2b <- df

era5_1 <- rbind(era5_1, era5_1b)
era5_2 <- rbind(era5_2, era5_2b)
rm(era5_1b)
rm(era5_2b)

## only keep the ones relevant for the NO2 model for now
era5_2 <- era5_2 %>% 
  dplyr::select(X, Y, date, wind_u, wind_v, temp_2m)
gc()



#### OMI Data ####
setwd("/media/hd/no2_israel/processed_data/OMNO2d/2004_2014")
file.list <- list.files(pattern='*.csv')
df.list <- lapply(file.list, read_csv)
df <- bind_rows(df.list)
omi <- df

setwd("/media/hd/no2_israel/processed_data/OMNO2d/2005_2022")
file.list <- list.files(pattern='*.csv')
df.list <- lapply(file.list, read_csv)
df <- bind_rows(df.list)
omi2 <- df

omi <- rbind(omi, omi2)
rm(omi2)
gc()



#### Time-Fixed Data ####
setwd("/media/hd/no2_israel/processed_data")
fixed <- read_csv("spatial_fixed_new.csv")



#### Merge Dataset Together ####
era5 <- left_join(era5_1, era5_2, by = c("X", "Y", "date"))

## remove sinu_id from remaining datasets to prevent issues
cams <- select(cams, -sinu_id)
omi <- select(omi, -sinu_id)
fixed <- select(fixed, -sinu_id)
fixed <- fixed %>%
  select(-x, -y) %>%
  rename(X = lon, Y = lat)

dta <- era5
dta <- left_join(dta, cams, by = c("X", "Y", "date"))
dta2 <- left_join(dta, omi, by = c("X", "Y", "date")) %>%
  distinct() #not sure why I need to do this in the left join, but it works...might be the NAs
dta2 <- left_join(dta2, fixed, by = c("X", "Y"))

dta2 <- dta2 %>%
  select(-sinu_id) %>%
  rename(lon = X, lat = Y)
#dta <- left_join(grid, dta, by = c("lon", "lat", "date"))

dta_final <- left_join(grid, dta2, by = c("lon", "lat", "date"))

setwd("/media/hd/no2_israel/processed_data")
write_csv(dta_final, "first_stage.csv")
