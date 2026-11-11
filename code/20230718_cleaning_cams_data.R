#### Cleaning CAMS global reanalysis Data ####.
#### July 18, 2023 (updated 8/1/23) ####

## The purpose of this script is to process the CAMS NO2 data
## Code here is based on the 20210129_cleaning_cams_data.R script
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

setwd("/media/hd/no2_israel/raw_data/CAMS/era5_no2")
## output a text file about the metadata (only need to do once)
#nc <- nc_open("no2.nc")
#{
#  sink("no2.nc.txt")
#  print(nc)
#  sink()
#}

## Output as a brick
no2 <- brick("no2.nc", varname = "tcno2")


## Data is all stored in the same file, taken every 3 hours
## Needs to be split first so that it is averaged properly

## Generate 8 indexes
index1 <- seq(1, 53328, 8)
index2 <- seq(2, 53328, 8)
index3 <- seq(3, 53328, 8)
index4 <- seq(4, 53328, 8)
index5 <- seq(5, 53328, 8)
index6 <- seq(6, 53328, 8)
index7 <- seq(7, 53328, 8)
index8 <- seq(8, 53328, 8)

no2_1 <- brick(subset(no2, index1))
no2_2 <- brick(subset(no2, index2))
no2_3 <- brick(subset(no2, index3))
no2_4 <- brick(subset(no2, index4))
no2_5 <- brick(subset(no2, index5))
no2_6 <- brick(subset(no2, index6))
no2_7 <- brick(subset(no2, index7))
no2_8 <- brick(subset(no2, index8))

## Average across the raster bricks (and preserve names and date/time)
no2_averaged <- mosaic(no2_1, no2_2, no2_3, no2_4, no2_5, no2_6, no2_7, no2_8, fun = mean)
names(no2_averaged) <- names(no2_1)

no2 <- no2_averaged

## Reformatting for a single CSV file
nc.1 <- as.data.frame(rasterToPoints(no2[[1]]))
nc.1$date <- as.Date(substr(names(nc.1)[3], 2, 11), format = "%Y.%m.%d")
names(nc.1)[3] <- "cams_no2"
nc.1 <- st_as_sf(nc.1, coords=c("x", "y"), crs=4326)
nc.1 <- st_join(grid, nc.1, join = st_nearest_feature) #since the NO2 grids are 0.75x0.75, makes sense that we get repeat values
coords <- as.data.frame(st_coordinates(nc.1))
nc.1 <- nc.1 %>%
  as.data.frame(dplyr::select(sinu_id, date, cams_no2)) %>%
  dplyr::select(-geometry)
nc.1 <- cbind(nc.1, coords)
nc.1 <- nc.1[, c(1, 4, 5, 3, 2)]

## Looping procedure
files.length <- dim(no2)[3]
dates <- as.data.frame(seq(as.Date("2004-10-01"), as.Date("2022-12-31"), by = 1))
names(dates)[1] <- "date"

for (i in  1:files.length){
  nc.i <- as.data.frame(rasterToPoints(no2[[i]]))
  nc.i$date <- as.Date(substr(names(nc.i)[3], 2, 11), format = "%Y.%m.%d")
  names(nc.i)[3] <- "cams_no2"
  nc.i <- st_as_sf(nc.i, coords=c("x", "y"), crs=4326)
  nc.i <- st_join(grid, nc.i, join = st_nearest_feature)
  coords <- as.data.frame(st_coordinates(nc.i))
  nc.i <- nc.i %>%
    as.data.frame(dplyr::select(sinu_id, date, cams_no2)) %>%
    dplyr::select(-geometry)
  nc.i <- cbind(nc.i, coords)
  nc.i <- nc.i[, c(1, 4, 5, 3, 2)]
  nm1 <- paste("cams_no2_", dates$date[i], ".csv", sep="")
  write.csv(nc.i, file = nm1 ,row.names = FALSE)
}
