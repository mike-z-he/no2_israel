#### NO2 Monitoring Data Cleaning ####
#### September 30, 2023 ####


## The goal of this script is to match the monitor NO2 data with
## the Stage 1 dataset to prep for Stage 2 modeling
## updated on 1/1: with 200m gridded data


#### Load Packages ####
library(tidyverse)
library(lubridate)
library(sf)
library(ncdf4)
library(stars)
library(raster)

setwd("/media/hd/no2_israel/processed_data")

monitor <- read_rds("final_no2_df.rds")
#monitor_2 <- read_rds("NO2_daily_mean.rds") #these are the unjoined raw file



#### Processing Monitoring Data ####
## Newly added dates are in Julian date, so need to separate and convert
## first before joining dataset back together

monitor_1 <- monitor[1:1020180,]
monitor_2 <- monitor[1020181:1075828,]
monitor_1$DATE <- as.Date(monitor_1$DATE, format = "%Y-%m-%d")
monitor_2$DATE <- as.numeric(monitor_2$DATE)
monitor_2$DATE <- as.Date(monitor_2$DATE, origin=as.Date("1970-01-01")) #this worked
monitor <- rbind(monitor_1, monitor_2)

rm(monitor_1)
rm(monitor_2)

## Continuing with processing
monitor$NO2 <- as.numeric(monitor$NO2)
monitor$X_ITM <- as.numeric(monitor$X_ITM)
monitor$Y_ITM <- as.numeric(monitor$Y_ITM)

monitor <- monitor %>%
  dplyr::select(STN, DATE, NO2, X_ITM, Y_ITM) %>%
  rename(station = STN,
         date = DATE,
         no2 = NO2,
         x_itm = X_ITM,
         y_itm = Y_ITM,) %>%
  drop_na(no2, x_itm, y_itm) %>%
  filter(date >= "2004-10-01")

## Convert monitoring dataset to sf
monitor <- st_as_sf(monitor, coords=c("x_itm", "y_itm"), crs=2039)
#monitor <- st_transform(monitor, crs=4326)

stations <- as.data.frame(st_coordinates(monitor))
stations <- cbind(monitor$station, stations)

stations <- stations %>%
  rename(station = "monitor$station") %>%
  dplyr::select(station, X, Y) %>%
  distinct()
## 143 unique stations with X/Y's on the list...now time to filter and match

## Load in grid data
#grid <- read_csv("grids_new.csv")
grid <- read_csv("grid_200m.csv")

#grid <- grid %>%
#  dplyr::select(grid_id, x, y)
grid <- grid %>%
  dplyr::select(grid_id, lon, lat)

#grid <- st_as_sf(grid, coords=c("x", "y"), crs=2039)
grid <- st_as_sf(grid, coords=c("lon", "lat"), crs=4326)
grid <- st_transform(grid, crs=2039)

## Default is 4326
## x: (130749.2, 267835.7)
## y: (527423.6, 800141.1)

## First, filter out stations that fall outside this area
stations_used <- stations %>%
  filter(X>=130749.2 & X<= 267835.7 & Y>=527423.6 & Y<=800141.1) #IEC was taken out
## We end up with 142 stations

## Remove IEC from monitoring list
monitor <- monitor %>%
  filter(station != "IEC") #sample size of 486565

## Match monitoring station to closest grid
stations_used_sf <- st_as_sf(stations_used, coords=c("X", "Y"), crs=2039)
stations_used_sf <- st_join(stations_used_sf, grid, join = st_nearest_feature)
stations_used_sf <- as.data.frame(stations_used_sf)
stations_used_sf$geometry <- NULL

## Match with Stage 1 data
coords <- as.data.frame(st_coordinates(monitor))
monitor <- as.data.frame(monitor)
monitor$geometry <- NULL
monitor <- cbind(monitor, coords)
rm(coords)

monitor <- left_join(monitor, stations_used_sf, by = "station")
monitor_final <- monitor %>%
  dplyr::select(grid_id, station, date, no2)
unique(monitor_final$station) #142 stations
unique(monitor_final$grid_id) #133 unique grids...which means some are being averaged or replaced
# the above turns to 141 unique grids for the 142 stations...makes sense since there are finer grids now



#### Check grids with overlapping info ####
#Grid ID: 6610 OFE and RTV
#Grid ID: 8245 DAL and KMN
#Grid ID: 10036 KV4 and MEC
#Grid ID: 10711 AGR and KIH and KLL and YMY
#Grid ID: 12042 AHT and AHU
#Grid ID: 12128 IZR and ROM
#Grid ID: 12189 NSH and NYO

## Subset out the data for the relevant stations
dta1 <- monitor_final %>%
  filter(station == "OFE" | station == "RTV")
dta2 <- monitor_final %>%
  filter(station == "DAL" | station == "KMN")
dta3 <- monitor_final %>%
  filter(station == "KV4" | station == "MEC")
dta4 <- monitor_final %>%
  filter(station == "AGR" | station == "KIH" | station == "KLL" | station == "YMY")
dta5 <- monitor_final %>%
  filter(station == "AHT" | station == "AHU")
dta6 <- monitor_final %>%
  filter(station == "IZR" | station == "ROM")
dta7 <- monitor_final %>%
  filter(station == "NSH" | station == "NYO")

## Visual inspection of all the datasets
#dta1: no overlaps
#dta2: overlap starting 2015/04/21 to 2018/12/31
#dta3: overlap starting 2007/08/04 to 2017/12/31
#dta4: overlap between KLL/AGR from 2011/03/17 to 2012/08/14
      #overlap between KLL/KIH from 2012/11/26 to 2014/01/28
      #overlap between KIH/AGR/YMY from 2021/02/01 to 2022/12/31; but can just keep YMY
#dta5: overlap between AHT/AHU from 2004/10/01 to 2008/12/31; 2013/12/31 to 2014/12/31; 2015/12/31 to 2017/11/06
#dta6: overlap between IZR/ROM from 2006/03/01 to 2018/12/28
#dta7: overlap between NSH/NYO from 2006/03/01 to 2008/12/31; 2014/01/31 to 2017/07/31

monitor_avg <- monitor_final %>%
  group_by(grid_id, date) %>%
  summarize(
    no2 = mean(no2, na.rm = TRUE)
  )
## This worked? I think?

## Save this dataset, to be used for building Stage 2 data
write_csv(monitor_avg, "monitor_avg.csv")
#write_csv(monitor_avg, "monitor_avg_200m_grid_matched.csv")
