#### Cleaning OMI Data ####
#### August 8, 2023 ####


## The purpose of this script is to process the downloaded OMI data
## Code here is based on the 20210127_cleaning_omi_data.R script
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


#### Try exporting for a single file ####
setwd("/media/hd/no2_israel/raw_data/OMNO2d")

## Read in nc file

nc <- raster("OMI-Aura_L3-OMNO2d_2004m1001_v003-2019m1121t082956.he5.SUB.nc4", 
             varname = "ColumnAmountNO2TropCloudScreened")
crs(nc) <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"

## Read as points
nc.points <- as.data.frame(rasterToPoints(nc))
names(nc.points)[3] <- "omi_no2"

## Add date information
name <- "OMI-Aura_L3-OMNO2d_2004m1001_v003-2019m1121t082956.he5.SUB.nc4"
date <- sub("m", "", str_split_fixed(name, "\\_",4)[3])
nc.points$date <- as.Date(date, format = "%Y%m%d")
nc.1 <- nc.points[, c(1, 2, 4, 3)]


nc.1 <- st_as_sf(nc.1, coords=c("x", "y"), crs=4326)
nc.1 <- st_join(grid, nc.1, join = st_nearest_feature)
coords <- as.data.frame(st_coordinates(nc.1))
nc.1 <- nc.1 %>%
  as.data.frame(dplyr::select(sinu_id, date, omi_no2)) %>%
  dplyr::select(-geometry)
nc.1 <- cbind(nc.1, coords)
nc.1 <- nc.1[, c(1, 4, 5, 2, 3)]
dim(grid_file)


#### Looping the procedure ####
setwd("/media/hd/no2_israel/raw_data/OMNO2d")
files <- dir(pattern=".nc4")
files.length <- length(files)

for (i in  1:files.length){
  nc.i <- raster(files[i],
                 varname = "ColumnAmountNO2TropCloudScreened")
  crs(nc.i) <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
  nc.i <- as.data.frame(rasterToPoints(nc.i))
  names(nc.i)[3] <- "omi_no2"
  
  if(nrow(nc.i) != 0){
    nc.i$date <- sub("m", "", str_split_fixed(files[i], "\\_",4)[3])
    nc.i$date <- as.Date(nc.i$date, format = "%Y%m%d")
    nc.i <- nc.i[, c(1, 2, 4, 3)]
    
    nc.i <- st_as_sf(nc.i, coords=c("x", "y"), crs=4326)
    nc.i <- st_join(grid, nc.i, join = st_nearest_feature)
    coords <- as.data.frame(st_coordinates(nc.i))
    nc.i <- nc.i %>%
      as.data.frame(dplyr::select(sinu_id, date, omi_no2)) %>%
      dplyr::select(-geometry)
    nc.i <- cbind(nc.i, coords)
    nc.i <- nc.i[, c(1, 4, 5, 2, 3)]
    nm1 <- paste(files[i], ".csv", sep="")
    write.csv(nc.i, file = nm1 ,row.names = FALSE)
  }
}