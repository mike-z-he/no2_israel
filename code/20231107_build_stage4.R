#### Building Dataset for Stage 4 NO2 Modeling ####
#### November 7, 2023 ####


## This code builds on existing code from the 20230810_build_stage1.R
## Uses 200 meter grids and calculates residuals



#### Load packages ####
library(tidyverse)
library(raster)
library(sf)
library(ncdf4)



#### Import 200m grids from Michael (DO NOT RUN AGAIN) ####
## this is based on the new cropped/masked template that Michael created
setwd("/media/hd/no2_israel/processed_data")

dta <- raster('template_200m_cropped_masked.tif')
#dta[] <- 1:ncell(dta) #this step messed things up and created grid IDs for even NAs...

## Get the coordinates of the centroid of each cell in the study area
dta <- rasterToPoints(dta, spatial = TRUE) %>%
  st_as_sf()
xy <- st_coordinates(dta) %>%
  as_tibble() %>%
  rename(sinu_x = X,
         sinu_y = Y)
lon_lat <- st_transform(dta, crs = 4326) %>%
  st_coordinates() %>%
  as_tibble() %>%
  rename(lon = X,
         lat = Y)
  
# Create data frame of grids
grid <- cbind(xy, lon_lat)
grid <- grid %>%
  mutate(grid_id = row_number())
grid <- grid[, c(5, 1, 2, 3, 4)]
#write_csv(grid, "grid_200m.csv") #n=954654, down from n=2024875 for the full fishnet
## !! should actually be only n=437466, not accounting for the empty space in the fishnet
## This portion of code does not need to be run again



#### Load grids ####
setwd("/media/hd/no2_israel/processed_data")
grid <- read_csv("grid_200m.csv")
grid <- grid %>%
  dplyr::select(grid_id, lon, lat)
grid <- st_as_sf(grid, coords=c("lon", "lat"), crs=4326)



#### Processing Boundary Layer Height Data ####
setwd("/media/hd/no2_israel/raw_data/CAMS/era5_single_levels")
## read in all data, then generate the daily results for the grids of interest in a single loop
blh_04_09 <- brick("era5_2004_2009.nc", varname = "blh")
blh_10_15 <- brick("era5_2010_2015.nc", varname = "blh")
blh_16_21 <- brick("era5_2016_2021.nc", varname = "blh")
blh_22    <- brick("era5_2022.nc", varname = "blh")

blh <- stack(blh_04_09, blh_10_15, blh_16_21, blh_22)

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
blh <- mosaic(blh_00, blh_01, blh_02, blh_03, blh_04,
                       blh_05, blh_06, blh_07, blh_08, blh_09,
                       blh_10, blh_11, blh_12, blh_13, blh_14, 
                       blh_15, blh_16, blh_17, blh_18, blh_19, 
                       blh_20, blh_21, blh_22, blh_23, fun = mean)
names(blh) <- names(blh_00)



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
cloud <- mosaic(cloud_00, cloud_01, cloud_02, cloud_03, cloud_04,
                         cloud_05, cloud_06, cloud_07, cloud_08, cloud_09,
                         cloud_10, cloud_11, cloud_12, cloud_13, cloud_14, 
                         cloud_15, cloud_16, cloud_17, cloud_18, cloud_19, 
                         cloud_20, cloud_21, cloud_22, cloud_23, fun = mean)
names(cloud) <- names(cloud_00)



#### Processing U-Wind component data ####
setwd("/media/hd/no2_israel/raw_data/CAMS/era5_land")
## Naming convention is dta_year_month
#2004
dta_04_10 <- brick("2004_10.nc", varname = "u10")
dta_04_11 <- brick("2004_11.nc", varname = "u10")
dta_04_12 <- brick("2004_12.nc", varname = "u10")

#2005
dta_05_01 <- brick("2005_01.nc", varname = "u10")
dta_05_02 <- brick("2005_02.nc", varname = "u10")
dta_05_03 <- brick("2005_03.nc", varname = "u10")
dta_05_04 <- brick("2005_04.nc", varname = "u10")
dta_05_05 <- brick("2005_05.nc", varname = "u10")
dta_05_06 <- brick("2005_06.nc", varname = "u10")
dta_05_07 <- brick("2005_07.nc", varname = "u10")
dta_05_08 <- brick("2005_08.nc", varname = "u10")
dta_05_09 <- brick("2005_09.nc", varname = "u10")
dta_05_10 <- brick("2005_10.nc", varname = "u10")
dta_05_11 <- brick("2005_11.nc", varname = "u10")
dta_05_12 <- brick("2005_12.nc", varname = "u10")

#2006
dta_06_01 <- brick("2006_01.nc", varname = "u10")
dta_06_02 <- brick("2006_02.nc", varname = "u10")
dta_06_03 <- brick("2006_03.nc", varname = "u10")
dta_06_04 <- brick("2006_04.nc", varname = "u10")
dta_06_05 <- brick("2006_05.nc", varname = "u10")
dta_06_06 <- brick("2006_06.nc", varname = "u10")
dta_06_07 <- brick("2006_07.nc", varname = "u10")
dta_06_08 <- brick("2006_08.nc", varname = "u10")
dta_06_09 <- brick("2006_09.nc", varname = "u10")
dta_06_10 <- brick("2006_10.nc", varname = "u10")
dta_06_11 <- brick("2006_11.nc", varname = "u10")
dta_06_12 <- brick("2006_12.nc", varname = "u10")

#2007
dta_07_01 <- brick("2007_01.nc", varname = "u10")
dta_07_02 <- brick("2007_02.nc", varname = "u10")
dta_07_03 <- brick("2007_03.nc", varname = "u10")
dta_07_04 <- brick("2007_04.nc", varname = "u10")
dta_07_05 <- brick("2007_05.nc", varname = "u10")
dta_07_06 <- brick("2007_06.nc", varname = "u10")
dta_07_07 <- brick("2007_07.nc", varname = "u10")
dta_07_08 <- brick("2007_08.nc", varname = "u10")
dta_07_09 <- brick("2007_09.nc", varname = "u10")
dta_07_10 <- brick("2007_10.nc", varname = "u10")
dta_07_11 <- brick("2007_11.nc", varname = "u10")
dta_07_12 <- brick("2007_12.nc", varname = "u10")

#2008
dta_08_01 <- brick("2008_01.nc", varname = "u10")
dta_08_02 <- brick("2008_02.nc", varname = "u10")
dta_08_03 <- brick("2008_03.nc", varname = "u10")
dta_08_04 <- brick("2008_04.nc", varname = "u10")
dta_08_05 <- brick("2008_05.nc", varname = "u10")
dta_08_06 <- brick("2008_06.nc", varname = "u10")
dta_08_07 <- brick("2008_07.nc", varname = "u10")
dta_08_08 <- brick("2008_08.nc", varname = "u10")
dta_08_09 <- brick("2008_09.nc", varname = "u10")
dta_08_10 <- brick("2008_10.nc", varname = "u10")
dta_08_11 <- brick("2008_11.nc", varname = "u10")
dta_08_12 <- brick("2008_12.nc", varname = "u10")

#2009
dta_09_01 <- brick("2009_01.nc", varname = "u10")
dta_09_02 <- brick("2009_02.nc", varname = "u10")
dta_09_03 <- brick("2009_03.nc", varname = "u10")
dta_09_04 <- brick("2009_04.nc", varname = "u10")
dta_09_05 <- brick("2009_05.nc", varname = "u10")
dta_09_06 <- brick("2009_06.nc", varname = "u10")
dta_09_07 <- brick("2009_07.nc", varname = "u10")
dta_09_08 <- brick("2009_08.nc", varname = "u10")
dta_09_09 <- brick("2009_09.nc", varname = "u10")
dta_09_10 <- brick("2009_10.nc", varname = "u10")
dta_09_11 <- brick("2009_11.nc", varname = "u10")
dta_09_12 <- brick("2009_12.nc", varname = "u10")

#2010
dta_10_01 <- brick("2010_01.nc", varname = "u10")
dta_10_02 <- brick("2010_02.nc", varname = "u10")
dta_10_03 <- brick("2010_03.nc", varname = "u10")
dta_10_04 <- brick("2010_04.nc", varname = "u10")
dta_10_05 <- brick("2010_05.nc", varname = "u10")
dta_10_06 <- brick("2010_06.nc", varname = "u10")
dta_10_07 <- brick("2010_07.nc", varname = "u10")
dta_10_08 <- brick("2010_08.nc", varname = "u10")
dta_10_09 <- brick("2010_09.nc", varname = "u10")
dta_10_10 <- brick("2010_10.nc", varname = "u10")
dta_10_11 <- brick("2010_11.nc", varname = "u10")
dta_10_12 <- brick("2010_12.nc", varname = "u10")

#2011
dta_11_01 <- brick("2011_01.nc", varname = "u10")
dta_11_02 <- brick("2011_02.nc", varname = "u10")
dta_11_03 <- brick("2011_03.nc", varname = "u10")
dta_11_04 <- brick("2011_04.nc", varname = "u10")
dta_11_05 <- brick("2011_05.nc", varname = "u10")
dta_11_06 <- brick("2011_06.nc", varname = "u10")
dta_11_07 <- brick("2011_07.nc", varname = "u10")
dta_11_08 <- brick("2011_08.nc", varname = "u10")
dta_11_09 <- brick("2011_09.nc", varname = "u10")
dta_11_10 <- brick("2011_10.nc", varname = "u10")
dta_11_11 <- brick("2011_11.nc", varname = "u10")
dta_11_12 <- brick("2011_12.nc", varname = "u10")

#2012
dta_12_01 <- brick("2012_01.nc", varname = "u10")
dta_12_02 <- brick("2012_02.nc", varname = "u10")
dta_12_03 <- brick("2012_03.nc", varname = "u10")
dta_12_04 <- brick("2012_04.nc", varname = "u10")
dta_12_05 <- brick("2012_05.nc", varname = "u10")
dta_12_06 <- brick("2012_06.nc", varname = "u10")
dta_12_07 <- brick("2012_07.nc", varname = "u10")
dta_12_08 <- brick("2012_08.nc", varname = "u10")
dta_12_09 <- brick("2012_09.nc", varname = "u10")
dta_12_10 <- brick("2012_10.nc", varname = "u10")
dta_12_11 <- brick("2012_11.nc", varname = "u10")
dta_12_12 <- brick("2012_12.nc", varname = "u10")

#2013
dta_13_01 <- brick("2013_01.nc", varname = "u10")
dta_13_02 <- brick("2013_02.nc", varname = "u10")
dta_13_03 <- brick("2013_03.nc", varname = "u10")
dta_13_04 <- brick("2013_04.nc", varname = "u10")
dta_13_05 <- brick("2013_05.nc", varname = "u10")
dta_13_06 <- brick("2013_06.nc", varname = "u10")
dta_13_07 <- brick("2013_07.nc", varname = "u10")
dta_13_08 <- brick("2013_08.nc", varname = "u10")
dta_13_09 <- brick("2013_09.nc", varname = "u10")
dta_13_10 <- brick("2013_10.nc", varname = "u10")
dta_13_11 <- brick("2013_11.nc", varname = "u10")
dta_13_12 <- brick("2013_12.nc", varname = "u10")

#2014
dta_14_01 <- brick("2014_01.nc", varname = "u10")
dta_14_02 <- brick("2014_02.nc", varname = "u10")
dta_14_03 <- brick("2014_03.nc", varname = "u10")
dta_14_04 <- brick("2014_04.nc", varname = "u10")
dta_14_05 <- brick("2014_05.nc", varname = "u10")
dta_14_06 <- brick("2014_06.nc", varname = "u10")
dta_14_07 <- brick("2014_07.nc", varname = "u10")
dta_14_08 <- brick("2014_08.nc", varname = "u10")
dta_14_09 <- brick("2014_09.nc", varname = "u10")
dta_14_10 <- brick("2014_10.nc", varname = "u10")
dta_14_11 <- brick("2014_11.nc", varname = "u10")
dta_14_12 <- brick("2014_12.nc", varname = "u10")

#2015
dta_15_01 <- brick("2015_01.nc", varname = "u10")
dta_15_02 <- brick("2015_02.nc", varname = "u10")
dta_15_03 <- brick("2015_03.nc", varname = "u10")
dta_15_04 <- brick("2015_04.nc", varname = "u10")
dta_15_05 <- brick("2015_05.nc", varname = "u10")
dta_15_06 <- brick("2015_06.nc", varname = "u10")
dta_15_07 <- brick("2015_07.nc", varname = "u10")
dta_15_08 <- brick("2015_08.nc", varname = "u10")
dta_15_09 <- brick("2015_09.nc", varname = "u10")
dta_15_10 <- brick("2015_10.nc", varname = "u10")
dta_15_11 <- brick("2015_11.nc", varname = "u10")
dta_15_12 <- brick("2015_12.nc", varname = "u10")

#2016
dta_16_01 <- brick("2016_01.nc", varname = "u10")
dta_16_02 <- brick("2016_02.nc", varname = "u10")
dta_16_03 <- brick("2016_03.nc", varname = "u10")
dta_16_04 <- brick("2016_04.nc", varname = "u10")
dta_16_05 <- brick("2016_05.nc", varname = "u10")
dta_16_06 <- brick("2016_06.nc", varname = "u10")
dta_16_07 <- brick("2016_07.nc", varname = "u10")
dta_16_08 <- brick("2016_08.nc", varname = "u10")
dta_16_09 <- brick("2016_09.nc", varname = "u10")
dta_16_10 <- brick("2016_10.nc", varname = "u10")
dta_16_11 <- brick("2016_11.nc", varname = "u10")
dta_16_12 <- brick("2016_12.nc", varname = "u10")

#2017
dta_17_01 <- brick("2017_01.nc", varname = "u10")
dta_17_02 <- brick("2017_02.nc", varname = "u10")
dta_17_03 <- brick("2017_03.nc", varname = "u10")
dta_17_04 <- brick("2017_04.nc", varname = "u10")
dta_17_05 <- brick("2017_05.nc", varname = "u10")
dta_17_06 <- brick("2017_06.nc", varname = "u10")
dta_17_07 <- brick("2017_07.nc", varname = "u10")
dta_17_08 <- brick("2017_08.nc", varname = "u10")
dta_17_09 <- brick("2017_09.nc", varname = "u10")
dta_17_10 <- brick("2017_10.nc", varname = "u10")
dta_17_11 <- brick("2017_11.nc", varname = "u10")
dta_17_12 <- brick("2017_12.nc", varname = "u10")

#2018
dta_18_01 <- brick("2018_01.nc", varname = "u10")
dta_18_02 <- brick("2018_02.nc", varname = "u10")
dta_18_03 <- brick("2018_03.nc", varname = "u10")
dta_18_04 <- brick("2018_04.nc", varname = "u10")
dta_18_05 <- brick("2018_05.nc", varname = "u10")
dta_18_06 <- brick("2018_06.nc", varname = "u10")
dta_18_07 <- brick("2018_07.nc", varname = "u10")
dta_18_08 <- brick("2018_08.nc", varname = "u10")
dta_18_09 <- brick("2018_09.nc", varname = "u10")
dta_18_10 <- brick("2018_10.nc", varname = "u10")
dta_18_11 <- brick("2018_11.nc", varname = "u10")
dta_18_12 <- brick("2018_12.nc", varname = "u10")

#2019
dta_19_01 <- brick("2019_01.nc", varname = "u10")
dta_19_02 <- brick("2019_02.nc", varname = "u10")
dta_19_03 <- brick("2019_03.nc", varname = "u10")
dta_19_04 <- brick("2019_04.nc", varname = "u10")
dta_19_05 <- brick("2019_05.nc", varname = "u10")
dta_19_06 <- brick("2019_06.nc", varname = "u10")
dta_19_07 <- brick("2019_07.nc", varname = "u10")
dta_19_08 <- brick("2019_08.nc", varname = "u10")
dta_19_09 <- brick("2019_09.nc", varname = "u10")
dta_19_10 <- brick("2019_10.nc", varname = "u10")
dta_19_11 <- brick("2019_11.nc", varname = "u10")
dta_19_12 <- brick("2019_12.nc", varname = "u10")

#2020
dta_20_01 <- brick("2020_01.nc", varname = "u10")
dta_20_02 <- brick("2020_02.nc", varname = "u10")
dta_20_03 <- brick("2020_03.nc", varname = "u10")
dta_20_04 <- brick("2020_04.nc", varname = "u10")
dta_20_05 <- brick("2020_05.nc", varname = "u10")
dta_20_06 <- brick("2020_06.nc", varname = "u10")
dta_20_07 <- brick("2020_07.nc", varname = "u10")
dta_20_08 <- brick("2020_08.nc", varname = "u10")
dta_20_09 <- brick("2020_09.nc", varname = "u10")
dta_20_10 <- brick("2020_10.nc", varname = "u10")
dta_20_11 <- brick("2020_11.nc", varname = "u10")
dta_20_12 <- brick("2020_12.nc", varname = "u10")

#2021
dta_21_01 <- brick("2021_01.nc", varname = "u10")
dta_21_02 <- brick("2021_02.nc", varname = "u10")
dta_21_03 <- brick("2021_03.nc", varname = "u10")
dta_21_04 <- brick("2021_04.nc", varname = "u10")
dta_21_05 <- brick("2021_05.nc", varname = "u10")
dta_21_06 <- brick("2021_06.nc", varname = "u10")
dta_21_07 <- brick("2021_07.nc", varname = "u10")
dta_21_08 <- brick("2021_08.nc", varname = "u10")
dta_21_09 <- brick("2021_09.nc", varname = "u10")
dta_21_10 <- brick("2021_10.nc", varname = "u10")
dta_21_11 <- brick("2021_11.nc", varname = "u10")
dta_21_12 <- brick("2021_12.nc", varname = "u10")

#2022
dta_22_01 <- brick("2022_01.nc", varname = "u10")
dta_22_02 <- brick("2022_02.nc", varname = "u10")
dta_22_03 <- brick("2022_03.nc", varname = "u10")
dta_22_04 <- brick("2022_04.nc", varname = "u10")
dta_22_05 <- brick("2022_05.nc", varname = "u10")
dta_22_06 <- brick("2022_06.nc", varname = "u10")
dta_22_07 <- brick("2022_07.nc", varname = "u10")
dta_22_08 <- brick("2022_08.nc", varname = "u10")
dta_22_09 <- brick("2022_09.nc", varname = "u10")
dta_22_10 <- brick("2022_10.nc", varname = "u10")
dta_22_11 <- brick("2022_11.nc", varname = "u10")
dta_22_12 <- brick("2022_12.nc", varname = "u10")

#Stack by year
dta_04 <- stack(dta_04_10, dta_04_11, dta_04_12)
dta_05 <- stack(dta_05_01, dta_05_02, dta_05_03, dta_05_04,
                dta_05_05, dta_05_06, dta_05_07, dta_05_08,
                dta_05_09, dta_05_10, dta_05_11, dta_05_12)
dta_06 <- stack(dta_06_01, dta_06_02, dta_06_03, dta_06_04,
                dta_06_05, dta_06_06, dta_06_07, dta_06_08,
                dta_06_09, dta_06_10, dta_06_11, dta_06_12)
dta_07 <- stack(dta_07_01, dta_07_02, dta_07_03, dta_07_04,
                dta_07_05, dta_07_06, dta_07_07, dta_07_08,
                dta_07_09, dta_07_10, dta_07_11, dta_07_12)
dta_08 <- stack(dta_08_01, dta_08_02, dta_08_03, dta_08_04,
                dta_08_05, dta_08_06, dta_08_07, dta_08_08,
                dta_08_09, dta_08_10, dta_08_11, dta_08_12)
dta_09 <- stack(dta_09_01, dta_09_02, dta_09_03, dta_09_04,
                dta_09_05, dta_09_06, dta_09_07, dta_09_08,
                dta_09_09, dta_09_10, dta_09_11, dta_09_12)
dta_10 <- stack(dta_10_01, dta_10_02, dta_10_03, dta_10_04,
                dta_10_05, dta_10_06, dta_10_07, dta_10_08,
                dta_10_09, dta_10_10, dta_10_11, dta_10_12)
dta_11 <- stack(dta_11_01, dta_11_02, dta_11_03, dta_11_04,
                dta_11_05, dta_11_06, dta_11_07, dta_11_08,
                dta_11_09, dta_11_10, dta_11_11, dta_11_12)
dta_12 <- stack(dta_12_01, dta_12_02, dta_12_03, dta_12_04,
                dta_12_05, dta_12_06, dta_12_07, dta_12_08,
                dta_12_09, dta_12_10, dta_12_11, dta_12_12)
dta_13 <- stack(dta_13_01, dta_13_02, dta_13_03, dta_13_04,
                dta_13_05, dta_13_06, dta_13_07, dta_13_08,
                dta_13_09, dta_13_10, dta_13_11, dta_13_12)
dta_14 <- stack(dta_14_01, dta_14_02, dta_14_03, dta_14_04,
                dta_14_05, dta_14_06, dta_14_07, dta_14_08,
                dta_14_09, dta_14_10, dta_14_11, dta_14_12)
dta_15 <- stack(dta_15_01, dta_15_02, dta_15_03, dta_15_04,
                dta_15_05, dta_15_06, dta_15_07, dta_15_08,
                dta_15_09, dta_15_10, dta_15_11, dta_15_12)
dta_16 <- stack(dta_16_01, dta_16_02, dta_16_03, dta_16_04,
                dta_16_05, dta_16_06, dta_16_07, dta_16_08,
                dta_16_09, dta_16_10, dta_16_11, dta_16_12)
dta_17 <- stack(dta_17_01, dta_17_02, dta_17_03, dta_17_04,
                dta_17_05, dta_17_06, dta_17_07, dta_17_08,
                dta_17_09, dta_17_10, dta_17_11, dta_17_12)
dta_18 <- stack(dta_18_01, dta_18_02, dta_18_03, dta_18_04,
                dta_18_05, dta_18_06, dta_18_07, dta_18_08,
                dta_18_09, dta_18_10, dta_18_11, dta_18_12)
dta_19 <- stack(dta_19_01, dta_19_02, dta_19_03, dta_19_04,
                dta_19_05, dta_19_06, dta_19_07, dta_19_08,
                dta_19_09, dta_19_10, dta_19_11, dta_19_12)
dta_20 <- stack(dta_20_01, dta_20_02, dta_20_03, dta_20_04,
                dta_20_05, dta_20_06, dta_20_07, dta_20_08,
                dta_20_09, dta_20_10, dta_20_11, dta_20_12)
dta_21 <- stack(dta_21_01, dta_21_02, dta_21_03, dta_21_04,
                dta_21_05, dta_21_06, dta_21_07, dta_21_08,
                dta_21_09, dta_21_10, dta_21_11, dta_21_12)
dta_22 <- stack(dta_22_01, dta_22_02, dta_22_03, dta_22_04,
                dta_22_05, dta_22_06, dta_22_07, dta_22_08,
                dta_22_09, dta_22_10, dta_22_11, dta_22_12)

## try one full stack...and it works!
dta <- stack(dta_04, dta_05, dta_06, dta_07,
             dta_08, dta_09, dta_10, dta_11,
             dta_12, dta_13, dta_14, dta_15,
             dta_16, dta_17, dta_18, dta_19,
             dta_20, dta_21, dta_22)

## Generate indexes for subsetting
## 159984 total entries (6666 days * 24)
index_1 <- seq(1, 159984, 24)
index_2 <- seq(2, 159984, 24)
index_3 <- seq(3, 159984, 24)
index_4 <- seq(4, 159984, 24)
index_5 <- seq(5, 159984, 24)
index_6 <- seq(6, 159984, 24)
index_7 <- seq(7, 159984, 24)
index_8 <- seq(8, 159984, 24)
index_9 <- seq(9, 159984, 24)
index_10 <- seq(10, 159984, 24)
index_11 <- seq(11, 159984, 24)
index_12 <- seq(12, 159984, 24)
index_13 <- seq(13, 159984, 24)
index_14 <- seq(14, 159984, 24)
index_15 <- seq(15, 159984, 24)
index_16 <- seq(16, 159984, 24)
index_17 <- seq(17, 159984, 24)
index_18 <- seq(18, 159984, 24)
index_19 <- seq(19, 159984, 24)
index_20 <- seq(20, 159984, 24)
index_21 <- seq(21, 159984, 24)
index_22 <- seq(22, 159984, 24)
index_23 <- seq(23, 159984, 24)
index_24 <- seq(24, 159984, 24)

## Subset
sub_00 <- brick(subset(dta, index_1))
sub_01 <- brick(subset(dta, index_2))
sub_02 <- brick(subset(dta, index_3))
sub_03 <- brick(subset(dta, index_4))
sub_04 <- brick(subset(dta, index_5))
sub_05 <- brick(subset(dta, index_6))
sub_06 <- brick(subset(dta, index_7))
sub_07 <- brick(subset(dta, index_8))
sub_08 <- brick(subset(dta, index_9))
sub_09 <- brick(subset(dta, index_10))
sub_10 <- brick(subset(dta, index_11))
sub_11 <- brick(subset(dta, index_12))
sub_12 <- brick(subset(dta, index_13))
sub_13 <- brick(subset(dta, index_14))
sub_14 <- brick(subset(dta, index_15))
sub_15 <- brick(subset(dta, index_16))
sub_16 <- brick(subset(dta, index_17))
sub_17 <- brick(subset(dta, index_18))
sub_18 <- brick(subset(dta, index_19))
sub_19 <- brick(subset(dta, index_20))
sub_20 <- brick(subset(dta, index_21))
sub_21 <- brick(subset(dta, index_22))
sub_22 <- brick(subset(dta, index_23))
sub_23 <- brick(subset(dta, index_24))

## Average across the raster bricks (and preserve names and date/time)
u10 <- mosaic(sub_00, sub_01, sub_02, sub_03, sub_04, sub_05,
              sub_06, sub_07, sub_08, sub_09, sub_10, sub_11,
              sub_12, sub_13, sub_14, sub_15, sub_16, sub_17,
              sub_18, sub_19, sub_20, sub_21, sub_22, sub_23, fun = mean)
names(u10) <- names(sub_00)



#### Processing V-Wind component data ####
## Naming convention is dta_year_month
#2004
dta_04_10 <- brick("2004_10.nc", varname = "v10")
dta_04_11 <- brick("2004_11.nc", varname = "v10")
dta_04_12 <- brick("2004_12.nc", varname = "v10")

#2005
dta_05_01 <- brick("2005_01.nc", varname = "v10")
dta_05_02 <- brick("2005_02.nc", varname = "v10")
dta_05_03 <- brick("2005_03.nc", varname = "v10")
dta_05_04 <- brick("2005_04.nc", varname = "v10")
dta_05_05 <- brick("2005_05.nc", varname = "v10")
dta_05_06 <- brick("2005_06.nc", varname = "v10")
dta_05_07 <- brick("2005_07.nc", varname = "v10")
dta_05_08 <- brick("2005_08.nc", varname = "v10")
dta_05_09 <- brick("2005_09.nc", varname = "v10")
dta_05_10 <- brick("2005_10.nc", varname = "v10")
dta_05_11 <- brick("2005_11.nc", varname = "v10")
dta_05_12 <- brick("2005_12.nc", varname = "v10")

#2006
dta_06_01 <- brick("2006_01.nc", varname = "v10")
dta_06_02 <- brick("2006_02.nc", varname = "v10")
dta_06_03 <- brick("2006_03.nc", varname = "v10")
dta_06_04 <- brick("2006_04.nc", varname = "v10")
dta_06_05 <- brick("2006_05.nc", varname = "v10")
dta_06_06 <- brick("2006_06.nc", varname = "v10")
dta_06_07 <- brick("2006_07.nc", varname = "v10")
dta_06_08 <- brick("2006_08.nc", varname = "v10")
dta_06_09 <- brick("2006_09.nc", varname = "v10")
dta_06_10 <- brick("2006_10.nc", varname = "v10")
dta_06_11 <- brick("2006_11.nc", varname = "v10")
dta_06_12 <- brick("2006_12.nc", varname = "v10")

#2007
dta_07_01 <- brick("2007_01.nc", varname = "v10")
dta_07_02 <- brick("2007_02.nc", varname = "v10")
dta_07_03 <- brick("2007_03.nc", varname = "v10")
dta_07_04 <- brick("2007_04.nc", varname = "v10")
dta_07_05 <- brick("2007_05.nc", varname = "v10")
dta_07_06 <- brick("2007_06.nc", varname = "v10")
dta_07_07 <- brick("2007_07.nc", varname = "v10")
dta_07_08 <- brick("2007_08.nc", varname = "v10")
dta_07_09 <- brick("2007_09.nc", varname = "v10")
dta_07_10 <- brick("2007_10.nc", varname = "v10")
dta_07_11 <- brick("2007_11.nc", varname = "v10")
dta_07_12 <- brick("2007_12.nc", varname = "v10")

#2008
dta_08_01 <- brick("2008_01.nc", varname = "v10")
dta_08_02 <- brick("2008_02.nc", varname = "v10")
dta_08_03 <- brick("2008_03.nc", varname = "v10")
dta_08_04 <- brick("2008_04.nc", varname = "v10")
dta_08_05 <- brick("2008_05.nc", varname = "v10")
dta_08_06 <- brick("2008_06.nc", varname = "v10")
dta_08_07 <- brick("2008_07.nc", varname = "v10")
dta_08_08 <- brick("2008_08.nc", varname = "v10")
dta_08_09 <- brick("2008_09.nc", varname = "v10")
dta_08_10 <- brick("2008_10.nc", varname = "v10")
dta_08_11 <- brick("2008_11.nc", varname = "v10")
dta_08_12 <- brick("2008_12.nc", varname = "v10")

#2009
dta_09_01 <- brick("2009_01.nc", varname = "v10")
dta_09_02 <- brick("2009_02.nc", varname = "v10")
dta_09_03 <- brick("2009_03.nc", varname = "v10")
dta_09_04 <- brick("2009_04.nc", varname = "v10")
dta_09_05 <- brick("2009_05.nc", varname = "v10")
dta_09_06 <- brick("2009_06.nc", varname = "v10")
dta_09_07 <- brick("2009_07.nc", varname = "v10")
dta_09_08 <- brick("2009_08.nc", varname = "v10")
dta_09_09 <- brick("2009_09.nc", varname = "v10")
dta_09_10 <- brick("2009_10.nc", varname = "v10")
dta_09_11 <- brick("2009_11.nc", varname = "v10")
dta_09_12 <- brick("2009_12.nc", varname = "v10")

#2010
dta_10_01 <- brick("2010_01.nc", varname = "v10")
dta_10_02 <- brick("2010_02.nc", varname = "v10")
dta_10_03 <- brick("2010_03.nc", varname = "v10")
dta_10_04 <- brick("2010_04.nc", varname = "v10")
dta_10_05 <- brick("2010_05.nc", varname = "v10")
dta_10_06 <- brick("2010_06.nc", varname = "v10")
dta_10_07 <- brick("2010_07.nc", varname = "v10")
dta_10_08 <- brick("2010_08.nc", varname = "v10")
dta_10_09 <- brick("2010_09.nc", varname = "v10")
dta_10_10 <- brick("2010_10.nc", varname = "v10")
dta_10_11 <- brick("2010_11.nc", varname = "v10")
dta_10_12 <- brick("2010_12.nc", varname = "v10")

#2011
dta_11_01 <- brick("2011_01.nc", varname = "v10")
dta_11_02 <- brick("2011_02.nc", varname = "v10")
dta_11_03 <- brick("2011_03.nc", varname = "v10")
dta_11_04 <- brick("2011_04.nc", varname = "v10")
dta_11_05 <- brick("2011_05.nc", varname = "v10")
dta_11_06 <- brick("2011_06.nc", varname = "v10")
dta_11_07 <- brick("2011_07.nc", varname = "v10")
dta_11_08 <- brick("2011_08.nc", varname = "v10")
dta_11_09 <- brick("2011_09.nc", varname = "v10")
dta_11_10 <- brick("2011_10.nc", varname = "v10")
dta_11_11 <- brick("2011_11.nc", varname = "v10")
dta_11_12 <- brick("2011_12.nc", varname = "v10")

#2012
dta_12_01 <- brick("2012_01.nc", varname = "v10")
dta_12_02 <- brick("2012_02.nc", varname = "v10")
dta_12_03 <- brick("2012_03.nc", varname = "v10")
dta_12_04 <- brick("2012_04.nc", varname = "v10")
dta_12_05 <- brick("2012_05.nc", varname = "v10")
dta_12_06 <- brick("2012_06.nc", varname = "v10")
dta_12_07 <- brick("2012_07.nc", varname = "v10")
dta_12_08 <- brick("2012_08.nc", varname = "v10")
dta_12_09 <- brick("2012_09.nc", varname = "v10")
dta_12_10 <- brick("2012_10.nc", varname = "v10")
dta_12_11 <- brick("2012_11.nc", varname = "v10")
dta_12_12 <- brick("2012_12.nc", varname = "v10")

#2013
dta_13_01 <- brick("2013_01.nc", varname = "v10")
dta_13_02 <- brick("2013_02.nc", varname = "v10")
dta_13_03 <- brick("2013_03.nc", varname = "v10")
dta_13_04 <- brick("2013_04.nc", varname = "v10")
dta_13_05 <- brick("2013_05.nc", varname = "v10")
dta_13_06 <- brick("2013_06.nc", varname = "v10")
dta_13_07 <- brick("2013_07.nc", varname = "v10")
dta_13_08 <- brick("2013_08.nc", varname = "v10")
dta_13_09 <- brick("2013_09.nc", varname = "v10")
dta_13_10 <- brick("2013_10.nc", varname = "v10")
dta_13_11 <- brick("2013_11.nc", varname = "v10")
dta_13_12 <- brick("2013_12.nc", varname = "v10")

#2014
dta_14_01 <- brick("2014_01.nc", varname = "v10")
dta_14_02 <- brick("2014_02.nc", varname = "v10")
dta_14_03 <- brick("2014_03.nc", varname = "v10")
dta_14_04 <- brick("2014_04.nc", varname = "v10")
dta_14_05 <- brick("2014_05.nc", varname = "v10")
dta_14_06 <- brick("2014_06.nc", varname = "v10")
dta_14_07 <- brick("2014_07.nc", varname = "v10")
dta_14_08 <- brick("2014_08.nc", varname = "v10")
dta_14_09 <- brick("2014_09.nc", varname = "v10")
dta_14_10 <- brick("2014_10.nc", varname = "v10")
dta_14_11 <- brick("2014_11.nc", varname = "v10")
dta_14_12 <- brick("2014_12.nc", varname = "v10")

#2015
dta_15_01 <- brick("2015_01.nc", varname = "v10")
dta_15_02 <- brick("2015_02.nc", varname = "v10")
dta_15_03 <- brick("2015_03.nc", varname = "v10")
dta_15_04 <- brick("2015_04.nc", varname = "v10")
dta_15_05 <- brick("2015_05.nc", varname = "v10")
dta_15_06 <- brick("2015_06.nc", varname = "v10")
dta_15_07 <- brick("2015_07.nc", varname = "v10")
dta_15_08 <- brick("2015_08.nc", varname = "v10")
dta_15_09 <- brick("2015_09.nc", varname = "v10")
dta_15_10 <- brick("2015_10.nc", varname = "v10")
dta_15_11 <- brick("2015_11.nc", varname = "v10")
dta_15_12 <- brick("2015_12.nc", varname = "v10")

#2016
dta_16_01 <- brick("2016_01.nc", varname = "v10")
dta_16_02 <- brick("2016_02.nc", varname = "v10")
dta_16_03 <- brick("2016_03.nc", varname = "v10")
dta_16_04 <- brick("2016_04.nc", varname = "v10")
dta_16_05 <- brick("2016_05.nc", varname = "v10")
dta_16_06 <- brick("2016_06.nc", varname = "v10")
dta_16_07 <- brick("2016_07.nc", varname = "v10")
dta_16_08 <- brick("2016_08.nc", varname = "v10")
dta_16_09 <- brick("2016_09.nc", varname = "v10")
dta_16_10 <- brick("2016_10.nc", varname = "v10")
dta_16_11 <- brick("2016_11.nc", varname = "v10")
dta_16_12 <- brick("2016_12.nc", varname = "v10")

#2017
dta_17_01 <- brick("2017_01.nc", varname = "v10")
dta_17_02 <- brick("2017_02.nc", varname = "v10")
dta_17_03 <- brick("2017_03.nc", varname = "v10")
dta_17_04 <- brick("2017_04.nc", varname = "v10")
dta_17_05 <- brick("2017_05.nc", varname = "v10")
dta_17_06 <- brick("2017_06.nc", varname = "v10")
dta_17_07 <- brick("2017_07.nc", varname = "v10")
dta_17_08 <- brick("2017_08.nc", varname = "v10")
dta_17_09 <- brick("2017_09.nc", varname = "v10")
dta_17_10 <- brick("2017_10.nc", varname = "v10")
dta_17_11 <- brick("2017_11.nc", varname = "v10")
dta_17_12 <- brick("2017_12.nc", varname = "v10")

#2018
dta_18_01 <- brick("2018_01.nc", varname = "v10")
dta_18_02 <- brick("2018_02.nc", varname = "v10")
dta_18_03 <- brick("2018_03.nc", varname = "v10")
dta_18_04 <- brick("2018_04.nc", varname = "v10")
dta_18_05 <- brick("2018_05.nc", varname = "v10")
dta_18_06 <- brick("2018_06.nc", varname = "v10")
dta_18_07 <- brick("2018_07.nc", varname = "v10")
dta_18_08 <- brick("2018_08.nc", varname = "v10")
dta_18_09 <- brick("2018_09.nc", varname = "v10")
dta_18_10 <- brick("2018_10.nc", varname = "v10")
dta_18_11 <- brick("2018_11.nc", varname = "v10")
dta_18_12 <- brick("2018_12.nc", varname = "v10")

#2019
dta_19_01 <- brick("2019_01.nc", varname = "v10")
dta_19_02 <- brick("2019_02.nc", varname = "v10")
dta_19_03 <- brick("2019_03.nc", varname = "v10")
dta_19_04 <- brick("2019_04.nc", varname = "v10")
dta_19_05 <- brick("2019_05.nc", varname = "v10")
dta_19_06 <- brick("2019_06.nc", varname = "v10")
dta_19_07 <- brick("2019_07.nc", varname = "v10")
dta_19_08 <- brick("2019_08.nc", varname = "v10")
dta_19_09 <- brick("2019_09.nc", varname = "v10")
dta_19_10 <- brick("2019_10.nc", varname = "v10")
dta_19_11 <- brick("2019_11.nc", varname = "v10")
dta_19_12 <- brick("2019_12.nc", varname = "v10")

#2020
dta_20_01 <- brick("2020_01.nc", varname = "v10")
dta_20_02 <- brick("2020_02.nc", varname = "v10")
dta_20_03 <- brick("2020_03.nc", varname = "v10")
dta_20_04 <- brick("2020_04.nc", varname = "v10")
dta_20_05 <- brick("2020_05.nc", varname = "v10")
dta_20_06 <- brick("2020_06.nc", varname = "v10")
dta_20_07 <- brick("2020_07.nc", varname = "v10")
dta_20_08 <- brick("2020_08.nc", varname = "v10")
dta_20_09 <- brick("2020_09.nc", varname = "v10")
dta_20_10 <- brick("2020_10.nc", varname = "v10")
dta_20_11 <- brick("2020_11.nc", varname = "v10")
dta_20_12 <- brick("2020_12.nc", varname = "v10")

#2021
dta_21_01 <- brick("2021_01.nc", varname = "v10")
dta_21_02 <- brick("2021_02.nc", varname = "v10")
dta_21_03 <- brick("2021_03.nc", varname = "v10")
dta_21_04 <- brick("2021_04.nc", varname = "v10")
dta_21_05 <- brick("2021_05.nc", varname = "v10")
dta_21_06 <- brick("2021_06.nc", varname = "v10")
dta_21_07 <- brick("2021_07.nc", varname = "v10")
dta_21_08 <- brick("2021_08.nc", varname = "v10")
dta_21_09 <- brick("2021_09.nc", varname = "v10")
dta_21_10 <- brick("2021_10.nc", varname = "v10")
dta_21_11 <- brick("2021_11.nc", varname = "v10")
dta_21_12 <- brick("2021_12.nc", varname = "v10")

#2022
dta_22_01 <- brick("2022_01.nc", varname = "v10")
dta_22_02 <- brick("2022_02.nc", varname = "v10")
dta_22_03 <- brick("2022_03.nc", varname = "v10")
dta_22_04 <- brick("2022_04.nc", varname = "v10")
dta_22_05 <- brick("2022_05.nc", varname = "v10")
dta_22_06 <- brick("2022_06.nc", varname = "v10")
dta_22_07 <- brick("2022_07.nc", varname = "v10")
dta_22_08 <- brick("2022_08.nc", varname = "v10")
dta_22_09 <- brick("2022_09.nc", varname = "v10")
dta_22_10 <- brick("2022_10.nc", varname = "v10")
dta_22_11 <- brick("2022_11.nc", varname = "v10")
dta_22_12 <- brick("2022_12.nc", varname = "v10")

#Stack by year
dta_04 <- stack(dta_04_10, dta_04_11, dta_04_12)
dta_05 <- stack(dta_05_01, dta_05_02, dta_05_03, dta_05_04,
                dta_05_05, dta_05_06, dta_05_07, dta_05_08,
                dta_05_09, dta_05_10, dta_05_11, dta_05_12)
dta_06 <- stack(dta_06_01, dta_06_02, dta_06_03, dta_06_04,
                dta_06_05, dta_06_06, dta_06_07, dta_06_08,
                dta_06_09, dta_06_10, dta_06_11, dta_06_12)
dta_07 <- stack(dta_07_01, dta_07_02, dta_07_03, dta_07_04,
                dta_07_05, dta_07_06, dta_07_07, dta_07_08,
                dta_07_09, dta_07_10, dta_07_11, dta_07_12)
dta_08 <- stack(dta_08_01, dta_08_02, dta_08_03, dta_08_04,
                dta_08_05, dta_08_06, dta_08_07, dta_08_08,
                dta_08_09, dta_08_10, dta_08_11, dta_08_12)
dta_09 <- stack(dta_09_01, dta_09_02, dta_09_03, dta_09_04,
                dta_09_05, dta_09_06, dta_09_07, dta_09_08,
                dta_09_09, dta_09_10, dta_09_11, dta_09_12)
dta_10 <- stack(dta_10_01, dta_10_02, dta_10_03, dta_10_04,
                dta_10_05, dta_10_06, dta_10_07, dta_10_08,
                dta_10_09, dta_10_10, dta_10_11, dta_10_12)
dta_11 <- stack(dta_11_01, dta_11_02, dta_11_03, dta_11_04,
                dta_11_05, dta_11_06, dta_11_07, dta_11_08,
                dta_11_09, dta_11_10, dta_11_11, dta_11_12)
dta_12 <- stack(dta_12_01, dta_12_02, dta_12_03, dta_12_04,
                dta_12_05, dta_12_06, dta_12_07, dta_12_08,
                dta_12_09, dta_12_10, dta_12_11, dta_12_12)
dta_13 <- stack(dta_13_01, dta_13_02, dta_13_03, dta_13_04,
                dta_13_05, dta_13_06, dta_13_07, dta_13_08,
                dta_13_09, dta_13_10, dta_13_11, dta_13_12)
dta_14 <- stack(dta_14_01, dta_14_02, dta_14_03, dta_14_04,
                dta_14_05, dta_14_06, dta_14_07, dta_14_08,
                dta_14_09, dta_14_10, dta_14_11, dta_14_12)
dta_15 <- stack(dta_15_01, dta_15_02, dta_15_03, dta_15_04,
                dta_15_05, dta_15_06, dta_15_07, dta_15_08,
                dta_15_09, dta_15_10, dta_15_11, dta_15_12)
dta_16 <- stack(dta_16_01, dta_16_02, dta_16_03, dta_16_04,
                dta_16_05, dta_16_06, dta_16_07, dta_16_08,
                dta_16_09, dta_16_10, dta_16_11, dta_16_12)
dta_17 <- stack(dta_17_01, dta_17_02, dta_17_03, dta_17_04,
                dta_17_05, dta_17_06, dta_17_07, dta_17_08,
                dta_17_09, dta_17_10, dta_17_11, dta_17_12)
dta_18 <- stack(dta_18_01, dta_18_02, dta_18_03, dta_18_04,
                dta_18_05, dta_18_06, dta_18_07, dta_18_08,
                dta_18_09, dta_18_10, dta_18_11, dta_18_12)
dta_19 <- stack(dta_19_01, dta_19_02, dta_19_03, dta_19_04,
                dta_19_05, dta_19_06, dta_19_07, dta_19_08,
                dta_19_09, dta_19_10, dta_19_11, dta_19_12)
dta_20 <- stack(dta_20_01, dta_20_02, dta_20_03, dta_20_04,
                dta_20_05, dta_20_06, dta_20_07, dta_20_08,
                dta_20_09, dta_20_10, dta_20_11, dta_20_12)
dta_21 <- stack(dta_21_01, dta_21_02, dta_21_03, dta_21_04,
                dta_21_05, dta_21_06, dta_21_07, dta_21_08,
                dta_21_09, dta_21_10, dta_21_11, dta_21_12)
dta_22 <- stack(dta_22_01, dta_22_02, dta_22_03, dta_22_04,
                dta_22_05, dta_22_06, dta_22_07, dta_22_08,
                dta_22_09, dta_22_10, dta_22_11, dta_22_12)

## try one full stack...and it works!
dta <- stack(dta_04, dta_05, dta_06, dta_07,
             dta_08, dta_09, dta_10, dta_11,
             dta_12, dta_13, dta_14, dta_15,
             dta_16, dta_17, dta_18, dta_19,
             dta_20, dta_21, dta_22)

## Subset
sub_00 <- brick(subset(dta, index_1))
sub_01 <- brick(subset(dta, index_2))
sub_02 <- brick(subset(dta, index_3))
sub_03 <- brick(subset(dta, index_4))
sub_04 <- brick(subset(dta, index_5))
sub_05 <- brick(subset(dta, index_6))
sub_06 <- brick(subset(dta, index_7))
sub_07 <- brick(subset(dta, index_8))
sub_08 <- brick(subset(dta, index_9))
sub_09 <- brick(subset(dta, index_10))
sub_10 <- brick(subset(dta, index_11))
sub_11 <- brick(subset(dta, index_12))
sub_12 <- brick(subset(dta, index_13))
sub_13 <- brick(subset(dta, index_14))
sub_14 <- brick(subset(dta, index_15))
sub_15 <- brick(subset(dta, index_16))
sub_16 <- brick(subset(dta, index_17))
sub_17 <- brick(subset(dta, index_18))
sub_18 <- brick(subset(dta, index_19))
sub_19 <- brick(subset(dta, index_20))
sub_20 <- brick(subset(dta, index_21))
sub_21 <- brick(subset(dta, index_22))
sub_22 <- brick(subset(dta, index_23))
sub_23 <- brick(subset(dta, index_24))

## Average across the raster bricks (and preserve names and date/time)
v10 <- mosaic(sub_00, sub_01, sub_02, sub_03, sub_04, sub_05,
              sub_06, sub_07, sub_08, sub_09, sub_10, sub_11,
              sub_12, sub_13, sub_14, sub_15, sub_16, sub_17,
              sub_18, sub_19, sub_20, sub_21, sub_22, sub_23, fun = mean)
names(v10) <- names(sub_00)



#### Processing 2-m temperature data ####
## Naming convention is dta_year_month
#2004
dta_04_10 <- brick("2004_10.nc", varname = "t2m")
dta_04_11 <- brick("2004_11.nc", varname = "t2m")
dta_04_12 <- brick("2004_12.nc", varname = "t2m")

#2005
dta_05_01 <- brick("2005_01.nc", varname = "t2m")
dta_05_02 <- brick("2005_02.nc", varname = "t2m")
dta_05_03 <- brick("2005_03.nc", varname = "t2m")
dta_05_04 <- brick("2005_04.nc", varname = "t2m")
dta_05_05 <- brick("2005_05.nc", varname = "t2m")
dta_05_06 <- brick("2005_06.nc", varname = "t2m")
dta_05_07 <- brick("2005_07.nc", varname = "t2m")
dta_05_08 <- brick("2005_08.nc", varname = "t2m")
dta_05_09 <- brick("2005_09.nc", varname = "t2m")
dta_05_10 <- brick("2005_10.nc", varname = "t2m")
dta_05_11 <- brick("2005_11.nc", varname = "t2m")
dta_05_12 <- brick("2005_12.nc", varname = "t2m")

#2006
dta_06_01 <- brick("2006_01.nc", varname = "t2m")
dta_06_02 <- brick("2006_02.nc", varname = "t2m")
dta_06_03 <- brick("2006_03.nc", varname = "t2m")
dta_06_04 <- brick("2006_04.nc", varname = "t2m")
dta_06_05 <- brick("2006_05.nc", varname = "t2m")
dta_06_06 <- brick("2006_06.nc", varname = "t2m")
dta_06_07 <- brick("2006_07.nc", varname = "t2m")
dta_06_08 <- brick("2006_08.nc", varname = "t2m")
dta_06_09 <- brick("2006_09.nc", varname = "t2m")
dta_06_10 <- brick("2006_10.nc", varname = "t2m")
dta_06_11 <- brick("2006_11.nc", varname = "t2m")
dta_06_12 <- brick("2006_12.nc", varname = "t2m")

#2007
dta_07_01 <- brick("2007_01.nc", varname = "t2m")
dta_07_02 <- brick("2007_02.nc", varname = "t2m")
dta_07_03 <- brick("2007_03.nc", varname = "t2m")
dta_07_04 <- brick("2007_04.nc", varname = "t2m")
dta_07_05 <- brick("2007_05.nc", varname = "t2m")
dta_07_06 <- brick("2007_06.nc", varname = "t2m")
dta_07_07 <- brick("2007_07.nc", varname = "t2m")
dta_07_08 <- brick("2007_08.nc", varname = "t2m")
dta_07_09 <- brick("2007_09.nc", varname = "t2m")
dta_07_10 <- brick("2007_10.nc", varname = "t2m")
dta_07_11 <- brick("2007_11.nc", varname = "t2m")
dta_07_12 <- brick("2007_12.nc", varname = "t2m")

#2008
dta_08_01 <- brick("2008_01.nc", varname = "t2m")
dta_08_02 <- brick("2008_02.nc", varname = "t2m")
dta_08_03 <- brick("2008_03.nc", varname = "t2m")
dta_08_04 <- brick("2008_04.nc", varname = "t2m")
dta_08_05 <- brick("2008_05.nc", varname = "t2m")
dta_08_06 <- brick("2008_06.nc", varname = "t2m")
dta_08_07 <- brick("2008_07.nc", varname = "t2m")
dta_08_08 <- brick("2008_08.nc", varname = "t2m")
dta_08_09 <- brick("2008_09.nc", varname = "t2m")
dta_08_10 <- brick("2008_10.nc", varname = "t2m")
dta_08_11 <- brick("2008_11.nc", varname = "t2m")
dta_08_12 <- brick("2008_12.nc", varname = "t2m")

#2009
dta_09_01 <- brick("2009_01.nc", varname = "t2m")
dta_09_02 <- brick("2009_02.nc", varname = "t2m")
dta_09_03 <- brick("2009_03.nc", varname = "t2m")
dta_09_04 <- brick("2009_04.nc", varname = "t2m")
dta_09_05 <- brick("2009_05.nc", varname = "t2m")
dta_09_06 <- brick("2009_06.nc", varname = "t2m")
dta_09_07 <- brick("2009_07.nc", varname = "t2m")
dta_09_08 <- brick("2009_08.nc", varname = "t2m")
dta_09_09 <- brick("2009_09.nc", varname = "t2m")
dta_09_10 <- brick("2009_10.nc", varname = "t2m")
dta_09_11 <- brick("2009_11.nc", varname = "t2m")
dta_09_12 <- brick("2009_12.nc", varname = "t2m")

#2010
dta_10_01 <- brick("2010_01.nc", varname = "t2m")
dta_10_02 <- brick("2010_02.nc", varname = "t2m")
dta_10_03 <- brick("2010_03.nc", varname = "t2m")
dta_10_04 <- brick("2010_04.nc", varname = "t2m")
dta_10_05 <- brick("2010_05.nc", varname = "t2m")
dta_10_06 <- brick("2010_06.nc", varname = "t2m")
dta_10_07 <- brick("2010_07.nc", varname = "t2m")
dta_10_08 <- brick("2010_08.nc", varname = "t2m")
dta_10_09 <- brick("2010_09.nc", varname = "t2m")
dta_10_10 <- brick("2010_10.nc", varname = "t2m")
dta_10_11 <- brick("2010_11.nc", varname = "t2m")
dta_10_12 <- brick("2010_12.nc", varname = "t2m")

#2011
dta_11_01 <- brick("2011_01.nc", varname = "t2m")
dta_11_02 <- brick("2011_02.nc", varname = "t2m")
dta_11_03 <- brick("2011_03.nc", varname = "t2m")
dta_11_04 <- brick("2011_04.nc", varname = "t2m")
dta_11_05 <- brick("2011_05.nc", varname = "t2m")
dta_11_06 <- brick("2011_06.nc", varname = "t2m")
dta_11_07 <- brick("2011_07.nc", varname = "t2m")
dta_11_08 <- brick("2011_08.nc", varname = "t2m")
dta_11_09 <- brick("2011_09.nc", varname = "t2m")
dta_11_10 <- brick("2011_10.nc", varname = "t2m")
dta_11_11 <- brick("2011_11.nc", varname = "t2m")
dta_11_12 <- brick("2011_12.nc", varname = "t2m")

#2012
dta_12_01 <- brick("2012_01.nc", varname = "t2m")
dta_12_02 <- brick("2012_02.nc", varname = "t2m")
dta_12_03 <- brick("2012_03.nc", varname = "t2m")
dta_12_04 <- brick("2012_04.nc", varname = "t2m")
dta_12_05 <- brick("2012_05.nc", varname = "t2m")
dta_12_06 <- brick("2012_06.nc", varname = "t2m")
dta_12_07 <- brick("2012_07.nc", varname = "t2m")
dta_12_08 <- brick("2012_08.nc", varname = "t2m")
dta_12_09 <- brick("2012_09.nc", varname = "t2m")
dta_12_10 <- brick("2012_10.nc", varname = "t2m")
dta_12_11 <- brick("2012_11.nc", varname = "t2m")
dta_12_12 <- brick("2012_12.nc", varname = "t2m")

#2013
dta_13_01 <- brick("2013_01.nc", varname = "t2m")
dta_13_02 <- brick("2013_02.nc", varname = "t2m")
dta_13_03 <- brick("2013_03.nc", varname = "t2m")
dta_13_04 <- brick("2013_04.nc", varname = "t2m")
dta_13_05 <- brick("2013_05.nc", varname = "t2m")
dta_13_06 <- brick("2013_06.nc", varname = "t2m")
dta_13_07 <- brick("2013_07.nc", varname = "t2m")
dta_13_08 <- brick("2013_08.nc", varname = "t2m")
dta_13_09 <- brick("2013_09.nc", varname = "t2m")
dta_13_10 <- brick("2013_10.nc", varname = "t2m")
dta_13_11 <- brick("2013_11.nc", varname = "t2m")
dta_13_12 <- brick("2013_12.nc", varname = "t2m")

#2014
dta_14_01 <- brick("2014_01.nc", varname = "t2m")
dta_14_02 <- brick("2014_02.nc", varname = "t2m")
dta_14_03 <- brick("2014_03.nc", varname = "t2m")
dta_14_04 <- brick("2014_04.nc", varname = "t2m")
dta_14_05 <- brick("2014_05.nc", varname = "t2m")
dta_14_06 <- brick("2014_06.nc", varname = "t2m")
dta_14_07 <- brick("2014_07.nc", varname = "t2m")
dta_14_08 <- brick("2014_08.nc", varname = "t2m")
dta_14_09 <- brick("2014_09.nc", varname = "t2m")
dta_14_10 <- brick("2014_10.nc", varname = "t2m")
dta_14_11 <- brick("2014_11.nc", varname = "t2m")
dta_14_12 <- brick("2014_12.nc", varname = "t2m")

#2015
dta_15_01 <- brick("2015_01.nc", varname = "t2m")
dta_15_02 <- brick("2015_02.nc", varname = "t2m")
dta_15_03 <- brick("2015_03.nc", varname = "t2m")
dta_15_04 <- brick("2015_04.nc", varname = "t2m")
dta_15_05 <- brick("2015_05.nc", varname = "t2m")
dta_15_06 <- brick("2015_06.nc", varname = "t2m")
dta_15_07 <- brick("2015_07.nc", varname = "t2m")
dta_15_08 <- brick("2015_08.nc", varname = "t2m")
dta_15_09 <- brick("2015_09.nc", varname = "t2m")
dta_15_10 <- brick("2015_10.nc", varname = "t2m")
dta_15_11 <- brick("2015_11.nc", varname = "t2m")
dta_15_12 <- brick("2015_12.nc", varname = "t2m")

#2016
dta_16_01 <- brick("2016_01.nc", varname = "t2m")
dta_16_02 <- brick("2016_02.nc", varname = "t2m")
dta_16_03 <- brick("2016_03.nc", varname = "t2m")
dta_16_04 <- brick("2016_04.nc", varname = "t2m")
dta_16_05 <- brick("2016_05.nc", varname = "t2m")
dta_16_06 <- brick("2016_06.nc", varname = "t2m")
dta_16_07 <- brick("2016_07.nc", varname = "t2m")
dta_16_08 <- brick("2016_08.nc", varname = "t2m")
dta_16_09 <- brick("2016_09.nc", varname = "t2m")
dta_16_10 <- brick("2016_10.nc", varname = "t2m")
dta_16_11 <- brick("2016_11.nc", varname = "t2m")
dta_16_12 <- brick("2016_12.nc", varname = "t2m")

#2017
dta_17_01 <- brick("2017_01.nc", varname = "t2m")
dta_17_02 <- brick("2017_02.nc", varname = "t2m")
dta_17_03 <- brick("2017_03.nc", varname = "t2m")
dta_17_04 <- brick("2017_04.nc", varname = "t2m")
dta_17_05 <- brick("2017_05.nc", varname = "t2m")
dta_17_06 <- brick("2017_06.nc", varname = "t2m")
dta_17_07 <- brick("2017_07.nc", varname = "t2m")
dta_17_08 <- brick("2017_08.nc", varname = "t2m")
dta_17_09 <- brick("2017_09.nc", varname = "t2m")
dta_17_10 <- brick("2017_10.nc", varname = "t2m")
dta_17_11 <- brick("2017_11.nc", varname = "t2m")
dta_17_12 <- brick("2017_12.nc", varname = "t2m")

#2018
dta_18_01 <- brick("2018_01.nc", varname = "t2m")
dta_18_02 <- brick("2018_02.nc", varname = "t2m")
dta_18_03 <- brick("2018_03.nc", varname = "t2m")
dta_18_04 <- brick("2018_04.nc", varname = "t2m")
dta_18_05 <- brick("2018_05.nc", varname = "t2m")
dta_18_06 <- brick("2018_06.nc", varname = "t2m")
dta_18_07 <- brick("2018_07.nc", varname = "t2m")
dta_18_08 <- brick("2018_08.nc", varname = "t2m")
dta_18_09 <- brick("2018_09.nc", varname = "t2m")
dta_18_10 <- brick("2018_10.nc", varname = "t2m")
dta_18_11 <- brick("2018_11.nc", varname = "t2m")
dta_18_12 <- brick("2018_12.nc", varname = "t2m")

#2019
dta_19_01 <- brick("2019_01.nc", varname = "t2m")
dta_19_02 <- brick("2019_02.nc", varname = "t2m")
dta_19_03 <- brick("2019_03.nc", varname = "t2m")
dta_19_04 <- brick("2019_04.nc", varname = "t2m")
dta_19_05 <- brick("2019_05.nc", varname = "t2m")
dta_19_06 <- brick("2019_06.nc", varname = "t2m")
dta_19_07 <- brick("2019_07.nc", varname = "t2m")
dta_19_08 <- brick("2019_08.nc", varname = "t2m")
dta_19_09 <- brick("2019_09.nc", varname = "t2m")
dta_19_10 <- brick("2019_10.nc", varname = "t2m")
dta_19_11 <- brick("2019_11.nc", varname = "t2m")
dta_19_12 <- brick("2019_12.nc", varname = "t2m")

#2020
dta_20_01 <- brick("2020_01.nc", varname = "t2m")
dta_20_02 <- brick("2020_02.nc", varname = "t2m")
dta_20_03 <- brick("2020_03.nc", varname = "t2m")
dta_20_04 <- brick("2020_04.nc", varname = "t2m")
dta_20_05 <- brick("2020_05.nc", varname = "t2m")
dta_20_06 <- brick("2020_06.nc", varname = "t2m")
dta_20_07 <- brick("2020_07.nc", varname = "t2m")
dta_20_08 <- brick("2020_08.nc", varname = "t2m")
dta_20_09 <- brick("2020_09.nc", varname = "t2m")
dta_20_10 <- brick("2020_10.nc", varname = "t2m")
dta_20_11 <- brick("2020_11.nc", varname = "t2m")
dta_20_12 <- brick("2020_12.nc", varname = "t2m")

#2021
dta_21_01 <- brick("2021_01.nc", varname = "t2m")
dta_21_02 <- brick("2021_02.nc", varname = "t2m")
dta_21_03 <- brick("2021_03.nc", varname = "t2m")
dta_21_04 <- brick("2021_04.nc", varname = "t2m")
dta_21_05 <- brick("2021_05.nc", varname = "t2m")
dta_21_06 <- brick("2021_06.nc", varname = "t2m")
dta_21_07 <- brick("2021_07.nc", varname = "t2m")
dta_21_08 <- brick("2021_08.nc", varname = "t2m")
dta_21_09 <- brick("2021_09.nc", varname = "t2m")
dta_21_10 <- brick("2021_10.nc", varname = "t2m")
dta_21_11 <- brick("2021_11.nc", varname = "t2m")
dta_21_12 <- brick("2021_12.nc", varname = "t2m")

#2022
dta_22_01 <- brick("2022_01.nc", varname = "t2m")
dta_22_02 <- brick("2022_02.nc", varname = "t2m")
dta_22_03 <- brick("2022_03.nc", varname = "t2m")
dta_22_04 <- brick("2022_04.nc", varname = "t2m")
dta_22_05 <- brick("2022_05.nc", varname = "t2m")
dta_22_06 <- brick("2022_06.nc", varname = "t2m")
dta_22_07 <- brick("2022_07.nc", varname = "t2m")
dta_22_08 <- brick("2022_08.nc", varname = "t2m")
dta_22_09 <- brick("2022_09.nc", varname = "t2m")
dta_22_10 <- brick("2022_10.nc", varname = "t2m")
dta_22_11 <- brick("2022_11.nc", varname = "t2m")
dta_22_12 <- brick("2022_12.nc", varname = "t2m")

#Stack by year
dta_04 <- stack(dta_04_10, dta_04_11, dta_04_12)
dta_05 <- stack(dta_05_01, dta_05_02, dta_05_03, dta_05_04,
                dta_05_05, dta_05_06, dta_05_07, dta_05_08,
                dta_05_09, dta_05_10, dta_05_11, dta_05_12)
dta_06 <- stack(dta_06_01, dta_06_02, dta_06_03, dta_06_04,
                dta_06_05, dta_06_06, dta_06_07, dta_06_08,
                dta_06_09, dta_06_10, dta_06_11, dta_06_12)
dta_07 <- stack(dta_07_01, dta_07_02, dta_07_03, dta_07_04,
                dta_07_05, dta_07_06, dta_07_07, dta_07_08,
                dta_07_09, dta_07_10, dta_07_11, dta_07_12)
dta_08 <- stack(dta_08_01, dta_08_02, dta_08_03, dta_08_04,
                dta_08_05, dta_08_06, dta_08_07, dta_08_08,
                dta_08_09, dta_08_10, dta_08_11, dta_08_12)
dta_09 <- stack(dta_09_01, dta_09_02, dta_09_03, dta_09_04,
                dta_09_05, dta_09_06, dta_09_07, dta_09_08,
                dta_09_09, dta_09_10, dta_09_11, dta_09_12)
dta_10 <- stack(dta_10_01, dta_10_02, dta_10_03, dta_10_04,
                dta_10_05, dta_10_06, dta_10_07, dta_10_08,
                dta_10_09, dta_10_10, dta_10_11, dta_10_12)
dta_11 <- stack(dta_11_01, dta_11_02, dta_11_03, dta_11_04,
                dta_11_05, dta_11_06, dta_11_07, dta_11_08,
                dta_11_09, dta_11_10, dta_11_11, dta_11_12)
dta_12 <- stack(dta_12_01, dta_12_02, dta_12_03, dta_12_04,
                dta_12_05, dta_12_06, dta_12_07, dta_12_08,
                dta_12_09, dta_12_10, dta_12_11, dta_12_12)
dta_13 <- stack(dta_13_01, dta_13_02, dta_13_03, dta_13_04,
                dta_13_05, dta_13_06, dta_13_07, dta_13_08,
                dta_13_09, dta_13_10, dta_13_11, dta_13_12)
dta_14 <- stack(dta_14_01, dta_14_02, dta_14_03, dta_14_04,
                dta_14_05, dta_14_06, dta_14_07, dta_14_08,
                dta_14_09, dta_14_10, dta_14_11, dta_14_12)
dta_15 <- stack(dta_15_01, dta_15_02, dta_15_03, dta_15_04,
                dta_15_05, dta_15_06, dta_15_07, dta_15_08,
                dta_15_09, dta_15_10, dta_15_11, dta_15_12)
dta_16 <- stack(dta_16_01, dta_16_02, dta_16_03, dta_16_04,
                dta_16_05, dta_16_06, dta_16_07, dta_16_08,
                dta_16_09, dta_16_10, dta_16_11, dta_16_12)
dta_17 <- stack(dta_17_01, dta_17_02, dta_17_03, dta_17_04,
                dta_17_05, dta_17_06, dta_17_07, dta_17_08,
                dta_17_09, dta_17_10, dta_17_11, dta_17_12)
dta_18 <- stack(dta_18_01, dta_18_02, dta_18_03, dta_18_04,
                dta_18_05, dta_18_06, dta_18_07, dta_18_08,
                dta_18_09, dta_18_10, dta_18_11, dta_18_12)
dta_19 <- stack(dta_19_01, dta_19_02, dta_19_03, dta_19_04,
                dta_19_05, dta_19_06, dta_19_07, dta_19_08,
                dta_19_09, dta_19_10, dta_19_11, dta_19_12)
dta_20 <- stack(dta_20_01, dta_20_02, dta_20_03, dta_20_04,
                dta_20_05, dta_20_06, dta_20_07, dta_20_08,
                dta_20_09, dta_20_10, dta_20_11, dta_20_12)
dta_21 <- stack(dta_21_01, dta_21_02, dta_21_03, dta_21_04,
                dta_21_05, dta_21_06, dta_21_07, dta_21_08,
                dta_21_09, dta_21_10, dta_21_11, dta_21_12)
dta_22 <- stack(dta_22_01, dta_22_02, dta_22_03, dta_22_04,
                dta_22_05, dta_22_06, dta_22_07, dta_22_08,
                dta_22_09, dta_22_10, dta_22_11, dta_22_12)

## try one full stack...and it works!
dta <- stack(dta_04, dta_05, dta_06, dta_07,
             dta_08, dta_09, dta_10, dta_11,
             dta_12, dta_13, dta_14, dta_15,
             dta_16, dta_17, dta_18, dta_19,
             dta_20, dta_21, dta_22)

## Subset
sub_00 <- brick(subset(dta, index_1))
sub_01 <- brick(subset(dta, index_2))
sub_02 <- brick(subset(dta, index_3))
sub_03 <- brick(subset(dta, index_4))
sub_04 <- brick(subset(dta, index_5))
sub_05 <- brick(subset(dta, index_6))
sub_06 <- brick(subset(dta, index_7))
sub_07 <- brick(subset(dta, index_8))
sub_08 <- brick(subset(dta, index_9))
sub_09 <- brick(subset(dta, index_10))
sub_10 <- brick(subset(dta, index_11))
sub_11 <- brick(subset(dta, index_12))
sub_12 <- brick(subset(dta, index_13))
sub_13 <- brick(subset(dta, index_14))
sub_14 <- brick(subset(dta, index_15))
sub_15 <- brick(subset(dta, index_16))
sub_16 <- brick(subset(dta, index_17))
sub_17 <- brick(subset(dta, index_18))
sub_18 <- brick(subset(dta, index_19))
sub_19 <- brick(subset(dta, index_20))
sub_20 <- brick(subset(dta, index_21))
sub_21 <- brick(subset(dta, index_22))
sub_22 <- brick(subset(dta, index_23))
sub_23 <- brick(subset(dta, index_24))

## Average across the raster bricks (and preserve names and date/time)
t2m <- mosaic(sub_00, sub_01, sub_02, sub_03, sub_04, sub_05,
              sub_06, sub_07, sub_08, sub_09, sub_10, sub_11,
              sub_12, sub_13, sub_14, sub_15, sub_16, sub_17,
              sub_18, sub_19, sub_20, sub_21, sub_22, sub_23, fun = mean)
names(t2m) <- names(sub_00)



#### Loop and output all five files (COMPLETE) ####
setwd("/media/hd/no2_israel/processed_data/era5_200m_grid_matched")

## First, double check the five output files
#blh <- blh_averaged
#cloud <- cloud_averaged

blh
cloud
## blh and cloud are from 2004/01/01, so we need to remove the top 274 days

blh <- raster::subset(blh, 275:6940)
cloud <- raster::subset(cloud, 275:6940)

blh
cloud
u10
v10
t2m

## Reformatting for a single CSV file
blh.1 <- as.data.frame(rasterToPoints(blh[[1]]))
cloud.1 <- as.data.frame(rasterToPoints(cloud[[1]]))

u10.1 <- as.data.frame(rasterToPoints(u10[[1]]))
v10.1 <- as.data.frame(rasterToPoints(v10[[1]]))
t2m.1 <- as.data.frame(rasterToPoints(t2m[[1]]))

blh.1$date <- as.Date(substr(names(blh.1)[3], 2, 11), format = "%Y.%m.%d")
u10.1$date <- as.Date(substr(names(u10.1)[3], 2, 11), format = "%Y.%m.%d")

names(blh.1)[3] <- "blh"
names(cloud.1)[3] <- "cloud"

names(u10.1)[3] <- "wind_u"
names(v10.1)[3] <- "wind_v"
names(t2m.1)[3] <- "temp_2m"

## use blh as "base", bind data together (nc)
nc.1 <- blh.1[, c(1, 2, 4, 3)]
nc.1 <- cbind(nc.1, cloud.1$cloud)

## use u10 as other "base", bind data together (nc2)
nc2.1 <- u10.1[, c(1, 2, 4, 3)]
nc2.1 <- cbind(nc2.1, v10.1$wind_v)
nc2.1 <- cbind(nc2.1, t2m.1$temp_2m)

names(nc.1)[5] <- "cloud" #need to do this again due to cbind

names(nc2.1)[5] <- "wind_v" #need to do this again due to cbind
names(nc2.1)[6] <- "temp_2m" #need to do this again due to cbind


nc.1 <- st_as_sf(nc.1, coords=c("x", "y"), crs=4326)
nc.1 <- st_join(grid, nc.1, join = st_nearest_feature)
coords <- as.data.frame(st_coordinates(nc.1))
nc.1 <- nc.1 %>%
  as.data.frame(dplyr::select(sinu_id, date, blh, cloud)) %>%
  dplyr::select(-geometry)
nc.1 <- cbind(nc.1, coords)
nc.1 <- nc.1[, c(1, 5, 6, 2, 3, 4)]

nc2.1 <- st_as_sf(nc2.1, coords=c("x", "y"), crs=4326)
nc2.1 <- st_join(grid, nc2.1, join = st_nearest_feature)
coords <- as.data.frame(st_coordinates(nc2.1))
nc2.1 <- nc2.1 %>%
  as.data.frame(dplyr::select(grid_id, date, wind_u, wind_v, temp_2m)) %>%
  dplyr::select(-geometry)

## Bind the two
nc.1 <- cbind(nc.1, nc2.1)
nc.1 <- nc.1[, c(1, 2, 3, 4, 5, 6, 9, 10, 11)] #get rid of the repeated grid_id and date



## Looping procedure
setwd("/media/hd/no2_israel/processed_data/era5_200m_grid_matched")
files.length <- dim(blh)[3]
dates <- as.data.frame(seq(as.Date("2004-10-01"), as.Date("2022-12-31"), by = 1))
names(dates)[1] <- "date"

# i in  1:files.length
for (i in  1:files.length){
  ## data frame all variables
  ## different from earlier scripts, we need to have two "bases" and cbind
  ## the era_single_level and era_land data separately (since they are different dims)
  blh.i <- as.data.frame(rasterToPoints(blh[[i]]))
  cloud.i <- as.data.frame(rasterToPoints(cloud[[i]]))
  
  u10.i <- as.data.frame(rasterToPoints(u10[[i]]))
  v10.i <- as.data.frame(rasterToPoints(v10[[i]]))
  t2m.i <- as.data.frame(rasterToPoints(t2m[[i]]))
  
  ## date (blh is "base" in one, u10 is "base" in the other)
  blh.i$date <- as.Date(substr(names(blh.i)[3], 2, 11), format = "%Y.%m.%d")
  u10.i$date <- as.Date(substr(names(u10.i)[3], 2, 11), format = "%Y.%m.%d")
  
  ## change names
  names(blh.i)[3] <- "blh"
  names(cloud.i)[3] <- "cloud"
  
  names(u10.i)[3] <- "wind_u"
  names(v10.i)[3] <- "wind_v"
  names(t2m.i)[3] <- "temp_2m"
  
  ## use blh as "base", bind data together (nc)
  nc.i <- blh.i[, c(1, 2, 4, 3)]
  nc.i <- cbind(nc.i, cloud.i$cloud)
  
  ## use u10 as other "base", bind data together (nc2)
  nc2.i <- u10.i[, c(1, 2, 4, 3)]
  nc2.i <- cbind(nc2.i, v10.i$wind_v)
  nc2.i <- cbind(nc2.i, t2m.i$temp_2m)
  
  names(nc.i)[5] <- "cloud" #need to do this again due to cbind
  
  names(nc2.i)[5] <- "wind_v" #need to do this again due to cbind
  names(nc2.i)[6] <- "temp_2m" #need to do this again due to cbind

  nc.i <- st_as_sf(nc.i, coords=c("x", "y"), crs=4326)
  nc.i <- st_join(grid, nc.i, join = st_nearest_feature)
  coords <- as.data.frame(st_coordinates(nc.i))
  nc.i <- nc.i %>%
    as.data.frame(dplyr::select(grid_id, date, blh, cloud)) %>%
    dplyr::select(-geometry)
  nc.i <- cbind(nc.i, coords)
  nc.i <- nc.i[, c(1, 5, 6, 2, 3, 4)]
  
  nc2.i <- st_as_sf(nc2.i, coords=c("x", "y"), crs=4326)
  nc2.i <- st_join(grid, nc2.i, join = st_nearest_feature)
  coords <- as.data.frame(st_coordinates(nc2.i))
  nc2.i <- nc2.i %>%
    as.data.frame(dplyr::select(grid_id, date, wind_u, wind_v, temp_2m)) %>%
    dplyr::select(-geometry)
  
  ## Bind the two
  nc.i <- cbind(nc.i, nc2.i)
  nc.i <- nc.i[, c(1, 2, 3, 4, 5, 6, 9, 10, 11)] #get rid of the repeated grid_id and date
  
  ## output
  nm1 <- paste("era5_", dates$date[i], ".csv", sep="")
  write.csv(nc.i, file = nm1 ,row.names = FALSE)
}



#### Process Elevation Data (COMPLETE) ####
#Load grids first above
#setwd("/media/hd/no2_israel/split/132.72.155.230:3838/qnap_share/P70.no2.o3.IL/raw/spatial_data/DEM")
#ele <- read_csv("dem_200m.csv")

## Create X and Y variables from string
#ele_x_y <- strsplit(ele$X_Y, split = "-")
#ele_x_y <- as.data.frame(str_split_fixed(ele$X_Y, "-", 2))

#ele <- cbind(ele, ele_x_y)

#ele <- ele %>%
#  dplyr::select(V1, V2, MEAN) %>%
#  rename(x_itm = V1,
#         y_itm = V2,
#         ele = MEAN)

#ele <- st_as_sf(ele, coords=c("x_itm", "y_itm"), crs=2039)
#ele <- st_transform(ele, crs=4326)


## Double checking 1km file as well
#ele_1km <- read_csv("dem_1km.csv")
#ele_x_y_1km <- as.data.frame(str_split_fixed(ele_1km$AODID, "-", 2))

#ele_1km <- cbind(ele_1km, ele_x_y_1km)

#ele_1km <- ele_1km %>%
#  dplyr::select(V1, V2, MEAN) %>%
#  rename(x_itm = V1,
#         y_itm = V2,
#         ele = MEAN)

#ele_1km <- st_as_sf(ele_1km, coords=c("x_itm", "y_itm"), crs=4326)
## this actually looks right...which means the 200m projected CSV values are wrong
## this needs to be redone

## Check original downloaded data
#setwd("/media/hd/no2_israel/split/132.72.155.230:3838/qnap_share/P70.no2.o3.IL/raw/spatial_data/DEM")
#point_ele <- st_read("point_elavition_shp.shp")
#point_ele <- read_sf(dsn=".", layer="point_elavition_shp")
# nothing loads...just going to redownload the files from scratch

## try using the elevatr package
#install.packages("elevatr")
library(elevatr)

## Vignette example
# Create an example data.frame
#set.seed(65.7)
#examp_df <- data.frame(x = runif(3, min = -73, max = -72.5), y = runif(3, min = 42,
#                                                                       max = 43))
#crs_dd <- 4326
#df_elev_aws <- get_elev_point(examp_df, prj = crs_dd, src = "aws") #this works, but aws makes it not work
#elevation_df <- get_elev_raster(examp_df, prj = crs_dd, z = 5) #same for this

#ele <- get_elev_point(grid, prj = 4326, src = "aws") #this doesn't work
#ele <- get_elev_point(grid, prj = 4326) #this works, but since not in US, all NAs

#grid_subset <- grid %>%
#  filter(grid_id < 10)
#ele_subset <- get_elev_point(grid_subset, prj = 4326, src = "aws") #just trying on subset, doesn't worko
#ele_subset <- get_elev_raster(grid_subset, prj = 4326, z = 5) #this works though...so I need to specify area

ele <- get_elev_raster(grid, prj = 4326, z = 9) #9 seems reasonably appropriate

elevation <- as.data.frame(rasterToPoints(ele[[1]]))
names(elevation)[3] <- "elev"

elevation <- st_as_sf(elevation, coords=c("x", "y"), crs=4326)
elevation <- st_join(grid, elevation, join = st_nearest_feature)

coords <- as.data.frame(st_coordinates(elevation))
elevation <- elevation %>%
  as.data.frame(elevation) %>%
  dplyr::select(-geometry)
elevation <- cbind(elevation, coords)
elevation <- elevation[, c(1, 3, 4, 2)]

setwd("/media/hd/no2_israel/processed_data")
write_csv(elevation, "elevation_200m_grid_matched.csv")



#### Process OSM Data (COMPLETE) ####
## Michael did this, so we are just using his finished product
## Try Major roads
#setwd("/media/hd/no2_israel/split/132.72.155.230:3838/qnap_share/P70.no2.o3.IL/raw/spatial_data/Roads/Major_Roads")
#roads <- st_read("maj_roads.shp")
#roads <- st_transform(roads, crs=4326)

#Bounding box:  xmin: 34.12497 ymin: 30.82833 xmax: 36.3402 ymax: 33.305
# Area of interest
#p1 = st_point(c(34.0, 30.0))
#p2 = st_point(c(36.0, 34.0))
#p = c(p1, p2)
#aoi = st_bbox(p)
#aoi = st_as_sfc(aoi)
#st_crs(aoi) = 4326

# Create grid
#library(stars)
#setwd("/media/hd/no2_israel/processed_data")
#grid <- read_stars('template_200m_cropped_masked.tif')
#grid <- st_as_sf(grid)
#grid <- st_transform(grid, crs=4326)
#grid$id = 1:nrow(grid)

# Grid to polygons
#grid_pol = st_as_sf(grid)
#grid_pol = grid_pol[aoi, ]
#grid_pol$id = 1:nrow(grid_pol)
#grid_pol$values = NULL

# Calculate road length per pixel
#result <- st_intersection(roads, grid_pol) #this step takes a while...1.5 days+?
#result$length_m <- st_length(result)

setwd("/media/hd/no2_israel/raw_data/Road")
road <- raster("road_length_m.tif")

## Get the coordinates of the centroid of each cell in the study area
road <- rasterToPoints(road, spatial = TRUE) %>%
  st_as_sf() %>%
  st_transform(crs = 4326)

road <- st_join(grid, road, join = st_nearest_feature)

coords <- as.data.frame(st_coordinates(road))
road <- road %>%
  as.data.frame(road) %>%
  dplyr::select(-geometry)
road <- cbind(road, coords)
road <- road[, c(1, 3, 4, 2)]

setwd("/media/hd/no2_israel/processed_data")
write_csv(road, "road_200m_grid_matched.csv")



#### Process Monitoring Data (COMPLETE) ####
## This is done in 20230930_monitor_no2_data.R
## Check script there
## Actually, can do this just through the processing of the residual data below



#### Process Residual Data (COMPLETE) ####
dta <- read_rds("prediction_3a_final.rds")
## Process data and calculate residuals
resid <- dta %>%
  dplyr::select(lon, lat, date, monitor_no2, pred.gam) %>%
  rename(ensemble_no2 = pred.gam) %>%
  mutate(resid_no2 = monitor_no2 - ensemble_no2) %>%
  drop_na(resid_no2) #n=470410; slight missing from full monitor dataset of s1 (n=470472)

resid <- resid %>%
  dplyr::select(-ensemble_no2)

resid <- st_as_sf(resid, coords = c("lon", "lat"), crs = 4326)
resid <- st_join(resid, grid, join = st_nearest_feature)

coords <- as.data.frame(st_coordinates(resid))
resid <- resid %>%
  as.data.frame(resid) %>%
  dplyr::select(-geometry)
resid <- cbind(resid, coords)
resid <- resid[, c(1, 4, 5, 6, 2, 3)]

setwd("/media/hd/no2_israel/processed_data")
write_csv(resid, "resid_200m_grid_matched.csv")



#### Create Grids by Date (2.9b entries) ####
setwd("/media/hd/no2_israel/processed_data")
grid <- read_csv("grid_200m.csv")
grid <- grid %>%
  dplyr::select(grid_id, lon, lat)

## Dates
## Dataset is way too big...breaking it down into three to facilitate processing
dates_1 <- as.data.frame(seq(as.Date("2004-10-01"), as.Date("2010-12-31"), by = 1))
dates_2 <- as.data.frame(seq(as.Date("2011-01-01"), as.Date("2016-12-31"), by = 1))
dates_3 <- as.data.frame(seq(as.Date("2017-01-01"), as.Date("2022-12-31"), by = 1))

names(dates_1)[1] <- "date"
names(dates_2)[1] <- "date"
names(dates_3)[1] <- "date"

#2,916,148,356 obs, let's see how it works by breaking it down...
grid_date_1 <- merge(grid, dates_1)
grid_date_2 <- merge(grid, dates_2)
grid_date_3 <- merge(grid, dates_3)

#saveRDS(grid_date_1, "grid_200m_04_10.rds")
#saveRDS(grid_date_2, "grid_200m_11_16.rds")
#saveRDS(grid_date_3, "grid_200m_17_22.rds")



#### Process Time-Varying (ERA5 Data) ####
setwd("/media/hd/no2_israel/processed_data/era5_200m_grid_matched/2004-2010")
file.list <- list.files(pattern='*.csv')
df.list <- lapply(file.list, read_csv)
cams_1 <- bind_rows(df.list)
#setwd("/media/hd/no2_israel/processed_data")
#saveRDS(cams_1, "era5_200m_04_10.rds")

setwd("/media/hd/no2_israel/processed_data/era5_200m_grid_matched/2011-2016")
file.list <- list.files(pattern='*.csv')
df.list <- lapply(file.list, read_csv)
cams_2 <- bind_rows(df.list)
#setwd("/media/hd/no2_israel/processed_data")
#saveRDS(cams_2, "era5_200m_11_16.rds")

setwd("/media/hd/no2_israel/processed_data/era5_200m_grid_matched/2017-2022")
file.list <- list.files(pattern='*.csv')
df.list <- lapply(file.list, read_csv)
cams_3 <- bind_rows(df.list)
#setwd("/media/hd/no2_israel/processed_data")
#saveRDS(cams_3, "era5_200m_17_22.rds")

setwd("/media/hd/no2_israel/processed_data")
saveRDS(cams_1, "era5_200m_04_10.rds")
saveRDS(cams_2, "era5_200m_11_16.rds")
saveRDS(cams_3, "era5_200m_17_22.rds")




#### Merge Residuals and Subset Monitors Only Data ####
setwd("/media/hd/no2_israel/processed_data")
resid <- read_csv("resid_200m_grid_matched.csv") %>%
  dplyr::select(-X, -Y)

cams_1 <- left_join(cams_1, resid, by = c("grid_id", "date"))
cams_2 <- left_join(cams_2, resid, by = c("grid_id", "date"))
cams_3 <- left_join(cams_3, resid, by = c("grid_id", "date"))

monitor_1 <- cams_1 %>%
  drop_na(resid_no2) #n=160487
monitor_2 <- cams_2 %>%
  drop_na(resid_no2) #n=193106
monitor_3 <- cams_3 %>%
  drop_na(resid_no2) #n=116817
#n's from 3 monitors add up to 470410, which is the n for resid (passes sanity test)

monitor <- rbind(monitor_1, monitor_2, monitor_3)

setwd("/media/hd/no2_israel/processed_data")
write_csv(monitor, "fourth_stage_monitors_only.csv") ## this still needs to be joined with the time-fixed data
