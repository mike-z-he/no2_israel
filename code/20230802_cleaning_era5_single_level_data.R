#### Cleaning ERA5 Boundary Layer/Cloud Data ####
#### August 2, 2023 ####


## The purpose of this script is to process the CAMS NO2 data
## Code here is based on the 20210205_cleaning_era5_2_data.R script
## from the Mexico model


#### Load Packages ####
library(tidyverse)
library(sf)
library(ncdf4)
library(raster)


#### Load Data ####
setwd("/media/hd/no2_israel/processed_data")
grid <- read_csv("grids_new.csv")
grid <- grid %>%
  dplyr::select(sinu_id, lon, lat)
grid <- st_as_sf(grid, coords=c("lon", "lat"), crs=4326)

setwd("/media/hd/no2_israel/raw_data/CAMS/era5_single_levels")
## output a text file about the metadata (only need to do once)
#nc <- nc_open("era5_2022.nc")
#{
#  sink("era5_2022.nc.txt")
#  print(nc)
#  sink()
#}



#### Processing boundary layer height data ####
blh_04_09 <- brick("era5_2004_2009.nc", varname = "blh")
blh_10_15 <- brick("era5_2010_2015.nc", varname = "blh")
blh_16_21 <- brick("era5_2016_2021.nc", varname = "blh")
blh_22    <- brick("era5_2022.nc", varname = "blh")

blh <- stack(blh_04_09, blh_10_15, blh_16_21, blh_22)
#blh2 <- blh
#blh <- blh2

## Remove layers 1 through 6576 (1/1/2004 to 9/30/2004)
#index <- seq(6577, 166560, 1)
#blh <- brick(subset(blh2, index))
#this didn't work properly, so we'll deal with it later

## Generate indexes for subsetting
## 166560 total entries (6940 days * 24)
index_1 <- seq(1, 166560, 24)
index_2 <- seq(2, 166560, 24)
index_3 <- seq(3, 166560, 24)
index_4 <- seq(4, 166560, 24)
index_5 <- seq(5, 166560, 24)
index_6 <- seq(6, 166560, 24)
index_7 <- seq(7, 166560, 24)
index_8 <- seq(8, 166560, 24)
index_9 <- seq(9, 166560, 24)
index_10 <- seq(10, 166560, 24)
index_11 <- seq(11, 166560, 24)
index_12 <- seq(12, 166560, 24)
index_13 <- seq(13, 166560, 24)
index_14 <- seq(14, 166560, 24)
index_15 <- seq(15, 166560, 24)
index_16 <- seq(16, 166560, 24)
index_17 <- seq(17, 166560, 24)
index_18 <- seq(18, 166560, 24)
index_19 <- seq(19, 166560, 24)
index_20 <- seq(20, 166560, 24)
index_21 <- seq(21, 166560, 24)
index_22 <- seq(22, 166560, 24)
index_23 <- seq(23, 166560, 24)
index_24 <- seq(24, 166560, 24)

## Subset
blh_00 <- brick(subset(blh, index_1))
blh_01 <- brick(subset(blh, index_2))
blh_02 <- brick(subset(blh, index_3))
blh_03 <- brick(subset(blh, index_4))
blh_04 <- brick(subset(blh, index_5))
blh_05 <- brick(subset(blh, index_6))
blh_06 <- brick(subset(blh, index_7))
blh_07 <- brick(subset(blh, index_8))
blh_08 <- brick(subset(blh, index_9))
blh_09 <- brick(subset(blh, index_10))
blh_10 <- brick(subset(blh, index_11))
blh_11 <- brick(subset(blh, index_12))
blh_12 <- brick(subset(blh, index_13))
blh_13 <- brick(subset(blh, index_14))
blh_14 <- brick(subset(blh, index_15))
blh_15 <- brick(subset(blh, index_16))
blh_16 <- brick(subset(blh, index_17))
blh_17 <- brick(subset(blh, index_18))
blh_18 <- brick(subset(blh, index_19))
blh_19 <- brick(subset(blh, index_20))
blh_20 <- brick(subset(blh, index_21))
blh_21 <- brick(subset(blh, index_22))
blh_22 <- brick(subset(blh, index_23))
blh_23 <- brick(subset(blh, index_24))

## Average across the raster bricks (and preserve names and date/time)
blh_averaged <- mosaic(blh_00, blh_01, blh_02, blh_03, blh_04,
                       blh_05, blh_06, blh_07, blh_08, blh_09,
                       blh_10, blh_11, blh_12, blh_13, blh_14, 
                       blh_15, blh_16, blh_17, blh_18, blh_19, 
                       blh_20, blh_21, blh_22, blh_23, fun = mean)
names(blh_averaged) <- names(blh_00)



#### Processing cloud data ####
cloud_04_09 <- brick("era5_2004_2009.nc", varname = "tcc")
cloud_10_15 <- brick("era5_2010_2015.nc", varname = "tcc")
cloud_16_21 <- brick("era5_2016_2021.nc", varname = "tcc")
cloud_22    <- brick("era5_2022.nc", varname = "tcc")

cloud <- stack(cloud_04_09, cloud_10_15, cloud_16_21, cloud_22)

## Subset
cloud_00 <- brick(subset(cloud, index_1))
cloud_01 <- brick(subset(cloud, index_2))
cloud_02 <- brick(subset(cloud, index_3))
cloud_03 <- brick(subset(cloud, index_4))
cloud_04 <- brick(subset(cloud, index_5))
cloud_05 <- brick(subset(cloud, index_6))
cloud_06 <- brick(subset(cloud, index_7))
cloud_07 <- brick(subset(cloud, index_8))
cloud_08 <- brick(subset(cloud, index_9))
cloud_09 <- brick(subset(cloud, index_10))
cloud_10 <- brick(subset(cloud, index_11))
cloud_11 <- brick(subset(cloud, index_12))
cloud_12 <- brick(subset(cloud, index_13))
cloud_13 <- brick(subset(cloud, index_14))
cloud_14 <- brick(subset(cloud, index_15))
cloud_15 <- brick(subset(cloud, index_16))
cloud_16 <- brick(subset(cloud, index_17))
cloud_17 <- brick(subset(cloud, index_18))
cloud_18 <- brick(subset(cloud, index_19))
cloud_19 <- brick(subset(cloud, index_20))
cloud_20 <- brick(subset(cloud, index_21))
cloud_21 <- brick(subset(cloud, index_22))
cloud_22 <- brick(subset(cloud, index_23))
cloud_23 <- brick(subset(cloud, index_24))

## Average across the raster bricks (and preserve names and date/time)
cloud_averaged <- mosaic(cloud_00, cloud_01, cloud_02, cloud_03, cloud_04,
                         cloud_05, cloud_06, cloud_07, cloud_08, cloud_09,
                         cloud_10, cloud_11, cloud_12, cloud_13, cloud_14, 
                         cloud_15, cloud_16, cloud_17, cloud_18, cloud_19, 
                         cloud_20, cloud_21, cloud_22, cloud_23, fun = mean)
names(cloud_averaged) <- names(cloud_00)


#### Loop and output both files ####
## First, double check the two output files
blh_averaged
cloud_averaged

## Subset out dates before 10/1/2004 (first 274 days)
#index <- seq(275, 6940, 1)
#blh <- brick(subset(blh_averaged, index))
#blh_23 <- brick(subset(blh, index_24))
#cloud <- brick(subset(cloud_averaged, index))
# for some reason, this also doesn't work...

blh <- blh_averaged
cloud <- cloud_averaged


## Since files are same length, just pick one to use as "base" with x/y/time information
## cbind the rest

## Reformatting for a single CSV file
blh.1 <- as.data.frame(rasterToPoints(blh[[1]]))
cloud.1 <- as.data.frame(rasterToPoints(cloud[[1]]))

blh.1$date <- as.Date(substr(names(blh.1)[3], 2, 11), format = "%Y.%m.%d")

names(blh.1)[3] <- "blh"
names(cloud.1)[3] <- "cloud"

## use blh as "base", bind data together
nc.1 <- blh.1[, c(1, 2, 4, 3)]
nc.1 <- cbind(nc.1, cloud.1$cloud)

names(nc.1)[5] <- "cloud" #need to do this again due to cbind

nc.1 <- st_as_sf(nc.1, coords=c("x", "y"), crs=4326)
nc.1 <- st_join(grid, nc.1, join = st_nearest_feature)
coords <- as.data.frame(st_coordinates(nc.1))
nc.1 <- nc.1 %>%
  as.data.frame(dplyr::select(sinu_id, date, blh, cloud)) %>%
  dplyr::select(-geometry)
nc.1 <- cbind(nc.1, coords)
nc.1 <- nc.1[, c(1, 5, 6, 2, 3, 4)]

## Looping procedure
setwd("/media/hd/no2_israel/processed_data/era5_single_levels")
files.length <- dim(blh)[3]
dates <- as.data.frame(seq(as.Date("2004-10-01"), as.Date("2022-12-31"), by = 1))
names(dates)[1] <- "date"

# i in  1:files.length
for (i in  1:files.length){
  ## data frame all variables
  blh.i <- as.data.frame(rasterToPoints(blh[[i]]))
  cloud.i <- as.data.frame(rasterToPoints(cloud[[i]]))
  
  ## date
  blh.i$date <- as.Date(substr(names(blh.i)[3], 2, 11), format = "%Y.%m.%d")
  
  ## change names
  names(blh.i)[3] <- "blh"
  names(cloud.i)[3] <- "cloud"
  
  ## use blh as "base", bind data together
  nc.i <- blh.i[, c(1, 2, 4, 3)]
  nc.i <- cbind(nc.i, cloud.i$cloud)
  
  names(nc.i)[5] <- "cloud"
  
  nc.i <- st_as_sf(nc.i, coords=c("x", "y"), crs=4326)
  nc.i <- st_join(grid, nc.i, join = st_nearest_feature)
  coords <- as.data.frame(st_coordinates(nc.i))
  nc.i <- nc.i %>%
    as.data.frame(dplyr::select(sinu_id, date, blh, cloud)) %>%
    dplyr::select(-geometry)
  nc.i <- cbind(nc.i, coords)
  nc.i <- nc.i[, c(1, 5, 6, 2, 3, 4)]
  
  ## output
  nm1 <- paste("era5_s_", dates$date[i], ".csv", sep="")
  write.csv(nc.i, file = nm1 ,row.names = FALSE)
}