#### Cleaning ERA5 Meteorological Data ####
#### August 3, 2023 ####

## The purpose of this script is to process the CAMS NO2 data
## Code here is based on the 20210204_cleaning_era5_data.R script
## from the Mexico model

## Update 7/8/2024: found coding bug in compiling all data
## Line 4760 and on: date extraction should be __.i instead of __


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

setwd("/media/hd/no2_israel/raw_data/CAMS/era5_land")

## output a text file about the metadata (only need to do once)
#nc <- nc_open("2004_10.nc")
#{
#  sink("2004_10.nc.txt")
#  print(nc)
#  sink()
#}

## 13 variables total: u10, v10, d2m, t2m, fal, src, skt, stl1, str, sp, sshf, strd, tp
## u10: 10m u-component of wind
## v10: 10m v-component of wind
## d2m: 2m dewpoint temperature
## t2m: 2m temperature
## fal: forecast albedo
## src: skin reservoir content
## skt: skin temperature
## stl1: soil temperature level 1
## str: surface net thermal radiation
## sp: surface pressure
## sshf: surface sensible heat flux
## strd: surface thermal radiation downwards
## tp: total precipitation



#### Wind-U ####
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



#### Wind-V ####
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



#### 2m dewpoint temperature ####
## Naming convention is dta_year_month
#2004
dta_04_10 <- brick("2004_10.nc", varname = "d2m")
dta_04_11 <- brick("2004_11.nc", varname = "d2m")
dta_04_12 <- brick("2004_12.nc", varname = "d2m")

#2005
dta_05_01 <- brick("2005_01.nc", varname = "d2m")
dta_05_02 <- brick("2005_02.nc", varname = "d2m")
dta_05_03 <- brick("2005_03.nc", varname = "d2m")
dta_05_04 <- brick("2005_04.nc", varname = "d2m")
dta_05_05 <- brick("2005_05.nc", varname = "d2m")
dta_05_06 <- brick("2005_06.nc", varname = "d2m")
dta_05_07 <- brick("2005_07.nc", varname = "d2m")
dta_05_08 <- brick("2005_08.nc", varname = "d2m")
dta_05_09 <- brick("2005_09.nc", varname = "d2m")
dta_05_10 <- brick("2005_10.nc", varname = "d2m")
dta_05_11 <- brick("2005_11.nc", varname = "d2m")
dta_05_12 <- brick("2005_12.nc", varname = "d2m")

#2006
dta_06_01 <- brick("2006_01.nc", varname = "d2m")
dta_06_02 <- brick("2006_02.nc", varname = "d2m")
dta_06_03 <- brick("2006_03.nc", varname = "d2m")
dta_06_04 <- brick("2006_04.nc", varname = "d2m")
dta_06_05 <- brick("2006_05.nc", varname = "d2m")
dta_06_06 <- brick("2006_06.nc", varname = "d2m")
dta_06_07 <- brick("2006_07.nc", varname = "d2m")
dta_06_08 <- brick("2006_08.nc", varname = "d2m")
dta_06_09 <- brick("2006_09.nc", varname = "d2m")
dta_06_10 <- brick("2006_10.nc", varname = "d2m")
dta_06_11 <- brick("2006_11.nc", varname = "d2m")
dta_06_12 <- brick("2006_12.nc", varname = "d2m")

#2007
dta_07_01 <- brick("2007_01.nc", varname = "d2m")
dta_07_02 <- brick("2007_02.nc", varname = "d2m")
dta_07_03 <- brick("2007_03.nc", varname = "d2m")
dta_07_04 <- brick("2007_04.nc", varname = "d2m")
dta_07_05 <- brick("2007_05.nc", varname = "d2m")
dta_07_06 <- brick("2007_06.nc", varname = "d2m")
dta_07_07 <- brick("2007_07.nc", varname = "d2m")
dta_07_08 <- brick("2007_08.nc", varname = "d2m")
dta_07_09 <- brick("2007_09.nc", varname = "d2m")
dta_07_10 <- brick("2007_10.nc", varname = "d2m")
dta_07_11 <- brick("2007_11.nc", varname = "d2m")
dta_07_12 <- brick("2007_12.nc", varname = "d2m")

#2008
dta_08_01 <- brick("2008_01.nc", varname = "d2m")
dta_08_02 <- brick("2008_02.nc", varname = "d2m")
dta_08_03 <- brick("2008_03.nc", varname = "d2m")
dta_08_04 <- brick("2008_04.nc", varname = "d2m")
dta_08_05 <- brick("2008_05.nc", varname = "d2m")
dta_08_06 <- brick("2008_06.nc", varname = "d2m")
dta_08_07 <- brick("2008_07.nc", varname = "d2m")
dta_08_08 <- brick("2008_08.nc", varname = "d2m")
dta_08_09 <- brick("2008_09.nc", varname = "d2m")
dta_08_10 <- brick("2008_10.nc", varname = "d2m")
dta_08_11 <- brick("2008_11.nc", varname = "d2m")
dta_08_12 <- brick("2008_12.nc", varname = "d2m")

#2009
dta_09_01 <- brick("2009_01.nc", varname = "d2m")
dta_09_02 <- brick("2009_02.nc", varname = "d2m")
dta_09_03 <- brick("2009_03.nc", varname = "d2m")
dta_09_04 <- brick("2009_04.nc", varname = "d2m")
dta_09_05 <- brick("2009_05.nc", varname = "d2m")
dta_09_06 <- brick("2009_06.nc", varname = "d2m")
dta_09_07 <- brick("2009_07.nc", varname = "d2m")
dta_09_08 <- brick("2009_08.nc", varname = "d2m")
dta_09_09 <- brick("2009_09.nc", varname = "d2m")
dta_09_10 <- brick("2009_10.nc", varname = "d2m")
dta_09_11 <- brick("2009_11.nc", varname = "d2m")
dta_09_12 <- brick("2009_12.nc", varname = "d2m")

#2010
dta_10_01 <- brick("2010_01.nc", varname = "d2m")
dta_10_02 <- brick("2010_02.nc", varname = "d2m")
dta_10_03 <- brick("2010_03.nc", varname = "d2m")
dta_10_04 <- brick("2010_04.nc", varname = "d2m")
dta_10_05 <- brick("2010_05.nc", varname = "d2m")
dta_10_06 <- brick("2010_06.nc", varname = "d2m")
dta_10_07 <- brick("2010_07.nc", varname = "d2m")
dta_10_08 <- brick("2010_08.nc", varname = "d2m")
dta_10_09 <- brick("2010_09.nc", varname = "d2m")
dta_10_10 <- brick("2010_10.nc", varname = "d2m")
dta_10_11 <- brick("2010_11.nc", varname = "d2m")
dta_10_12 <- brick("2010_12.nc", varname = "d2m")

#2011
dta_11_01 <- brick("2011_01.nc", varname = "d2m")
dta_11_02 <- brick("2011_02.nc", varname = "d2m")
dta_11_03 <- brick("2011_03.nc", varname = "d2m")
dta_11_04 <- brick("2011_04.nc", varname = "d2m")
dta_11_05 <- brick("2011_05.nc", varname = "d2m")
dta_11_06 <- brick("2011_06.nc", varname = "d2m")
dta_11_07 <- brick("2011_07.nc", varname = "d2m")
dta_11_08 <- brick("2011_08.nc", varname = "d2m")
dta_11_09 <- brick("2011_09.nc", varname = "d2m")
dta_11_10 <- brick("2011_10.nc", varname = "d2m")
dta_11_11 <- brick("2011_11.nc", varname = "d2m")
dta_11_12 <- brick("2011_12.nc", varname = "d2m")

#2012
dta_12_01 <- brick("2012_01.nc", varname = "d2m")
dta_12_02 <- brick("2012_02.nc", varname = "d2m")
dta_12_03 <- brick("2012_03.nc", varname = "d2m")
dta_12_04 <- brick("2012_04.nc", varname = "d2m")
dta_12_05 <- brick("2012_05.nc", varname = "d2m")
dta_12_06 <- brick("2012_06.nc", varname = "d2m")
dta_12_07 <- brick("2012_07.nc", varname = "d2m")
dta_12_08 <- brick("2012_08.nc", varname = "d2m")
dta_12_09 <- brick("2012_09.nc", varname = "d2m")
dta_12_10 <- brick("2012_10.nc", varname = "d2m")
dta_12_11 <- brick("2012_11.nc", varname = "d2m")
dta_12_12 <- brick("2012_12.nc", varname = "d2m")

#2013
dta_13_01 <- brick("2013_01.nc", varname = "d2m")
dta_13_02 <- brick("2013_02.nc", varname = "d2m")
dta_13_03 <- brick("2013_03.nc", varname = "d2m")
dta_13_04 <- brick("2013_04.nc", varname = "d2m")
dta_13_05 <- brick("2013_05.nc", varname = "d2m")
dta_13_06 <- brick("2013_06.nc", varname = "d2m")
dta_13_07 <- brick("2013_07.nc", varname = "d2m")
dta_13_08 <- brick("2013_08.nc", varname = "d2m")
dta_13_09 <- brick("2013_09.nc", varname = "d2m")
dta_13_10 <- brick("2013_10.nc", varname = "d2m")
dta_13_11 <- brick("2013_11.nc", varname = "d2m")
dta_13_12 <- brick("2013_12.nc", varname = "d2m")

#2014
dta_14_01 <- brick("2014_01.nc", varname = "d2m")
dta_14_02 <- brick("2014_02.nc", varname = "d2m")
dta_14_03 <- brick("2014_03.nc", varname = "d2m")
dta_14_04 <- brick("2014_04.nc", varname = "d2m")
dta_14_05 <- brick("2014_05.nc", varname = "d2m")
dta_14_06 <- brick("2014_06.nc", varname = "d2m")
dta_14_07 <- brick("2014_07.nc", varname = "d2m")
dta_14_08 <- brick("2014_08.nc", varname = "d2m")
dta_14_09 <- brick("2014_09.nc", varname = "d2m")
dta_14_10 <- brick("2014_10.nc", varname = "d2m")
dta_14_11 <- brick("2014_11.nc", varname = "d2m")
dta_14_12 <- brick("2014_12.nc", varname = "d2m")

#2015
dta_15_01 <- brick("2015_01.nc", varname = "d2m")
dta_15_02 <- brick("2015_02.nc", varname = "d2m")
dta_15_03 <- brick("2015_03.nc", varname = "d2m")
dta_15_04 <- brick("2015_04.nc", varname = "d2m")
dta_15_05 <- brick("2015_05.nc", varname = "d2m")
dta_15_06 <- brick("2015_06.nc", varname = "d2m")
dta_15_07 <- brick("2015_07.nc", varname = "d2m")
dta_15_08 <- brick("2015_08.nc", varname = "d2m")
dta_15_09 <- brick("2015_09.nc", varname = "d2m")
dta_15_10 <- brick("2015_10.nc", varname = "d2m")
dta_15_11 <- brick("2015_11.nc", varname = "d2m")
dta_15_12 <- brick("2015_12.nc", varname = "d2m")

#2016
dta_16_01 <- brick("2016_01.nc", varname = "d2m")
dta_16_02 <- brick("2016_02.nc", varname = "d2m")
dta_16_03 <- brick("2016_03.nc", varname = "d2m")
dta_16_04 <- brick("2016_04.nc", varname = "d2m")
dta_16_05 <- brick("2016_05.nc", varname = "d2m")
dta_16_06 <- brick("2016_06.nc", varname = "d2m")
dta_16_07 <- brick("2016_07.nc", varname = "d2m")
dta_16_08 <- brick("2016_08.nc", varname = "d2m")
dta_16_09 <- brick("2016_09.nc", varname = "d2m")
dta_16_10 <- brick("2016_10.nc", varname = "d2m")
dta_16_11 <- brick("2016_11.nc", varname = "d2m")
dta_16_12 <- brick("2016_12.nc", varname = "d2m")

#2017
dta_17_01 <- brick("2017_01.nc", varname = "d2m")
dta_17_02 <- brick("2017_02.nc", varname = "d2m")
dta_17_03 <- brick("2017_03.nc", varname = "d2m")
dta_17_04 <- brick("2017_04.nc", varname = "d2m")
dta_17_05 <- brick("2017_05.nc", varname = "d2m")
dta_17_06 <- brick("2017_06.nc", varname = "d2m")
dta_17_07 <- brick("2017_07.nc", varname = "d2m")
dta_17_08 <- brick("2017_08.nc", varname = "d2m")
dta_17_09 <- brick("2017_09.nc", varname = "d2m")
dta_17_10 <- brick("2017_10.nc", varname = "d2m")
dta_17_11 <- brick("2017_11.nc", varname = "d2m")
dta_17_12 <- brick("2017_12.nc", varname = "d2m")

#2018
dta_18_01 <- brick("2018_01.nc", varname = "d2m")
dta_18_02 <- brick("2018_02.nc", varname = "d2m")
dta_18_03 <- brick("2018_03.nc", varname = "d2m")
dta_18_04 <- brick("2018_04.nc", varname = "d2m")
dta_18_05 <- brick("2018_05.nc", varname = "d2m")
dta_18_06 <- brick("2018_06.nc", varname = "d2m")
dta_18_07 <- brick("2018_07.nc", varname = "d2m")
dta_18_08 <- brick("2018_08.nc", varname = "d2m")
dta_18_09 <- brick("2018_09.nc", varname = "d2m")
dta_18_10 <- brick("2018_10.nc", varname = "d2m")
dta_18_11 <- brick("2018_11.nc", varname = "d2m")
dta_18_12 <- brick("2018_12.nc", varname = "d2m")

#2019
dta_19_01 <- brick("2019_01.nc", varname = "d2m")
dta_19_02 <- brick("2019_02.nc", varname = "d2m")
dta_19_03 <- brick("2019_03.nc", varname = "d2m")
dta_19_04 <- brick("2019_04.nc", varname = "d2m")
dta_19_05 <- brick("2019_05.nc", varname = "d2m")
dta_19_06 <- brick("2019_06.nc", varname = "d2m")
dta_19_07 <- brick("2019_07.nc", varname = "d2m")
dta_19_08 <- brick("2019_08.nc", varname = "d2m")
dta_19_09 <- brick("2019_09.nc", varname = "d2m")
dta_19_10 <- brick("2019_10.nc", varname = "d2m")
dta_19_11 <- brick("2019_11.nc", varname = "d2m")
dta_19_12 <- brick("2019_12.nc", varname = "d2m")

#2020
dta_20_01 <- brick("2020_01.nc", varname = "d2m")
dta_20_02 <- brick("2020_02.nc", varname = "d2m")
dta_20_03 <- brick("2020_03.nc", varname = "d2m")
dta_20_04 <- brick("2020_04.nc", varname = "d2m")
dta_20_05 <- brick("2020_05.nc", varname = "d2m")
dta_20_06 <- brick("2020_06.nc", varname = "d2m")
dta_20_07 <- brick("2020_07.nc", varname = "d2m")
dta_20_08 <- brick("2020_08.nc", varname = "d2m")
dta_20_09 <- brick("2020_09.nc", varname = "d2m")
dta_20_10 <- brick("2020_10.nc", varname = "d2m")
dta_20_11 <- brick("2020_11.nc", varname = "d2m")
dta_20_12 <- brick("2020_12.nc", varname = "d2m")

#2021
dta_21_01 <- brick("2021_01.nc", varname = "d2m")
dta_21_02 <- brick("2021_02.nc", varname = "d2m")
dta_21_03 <- brick("2021_03.nc", varname = "d2m")
dta_21_04 <- brick("2021_04.nc", varname = "d2m")
dta_21_05 <- brick("2021_05.nc", varname = "d2m")
dta_21_06 <- brick("2021_06.nc", varname = "d2m")
dta_21_07 <- brick("2021_07.nc", varname = "d2m")
dta_21_08 <- brick("2021_08.nc", varname = "d2m")
dta_21_09 <- brick("2021_09.nc", varname = "d2m")
dta_21_10 <- brick("2021_10.nc", varname = "d2m")
dta_21_11 <- brick("2021_11.nc", varname = "d2m")
dta_21_12 <- brick("2021_12.nc", varname = "d2m")

#2022
dta_22_01 <- brick("2022_01.nc", varname = "d2m")
dta_22_02 <- brick("2022_02.nc", varname = "d2m")
dta_22_03 <- brick("2022_03.nc", varname = "d2m")
dta_22_04 <- brick("2022_04.nc", varname = "d2m")
dta_22_05 <- brick("2022_05.nc", varname = "d2m")
dta_22_06 <- brick("2022_06.nc", varname = "d2m")
dta_22_07 <- brick("2022_07.nc", varname = "d2m")
dta_22_08 <- brick("2022_08.nc", varname = "d2m")
dta_22_09 <- brick("2022_09.nc", varname = "d2m")
dta_22_10 <- brick("2022_10.nc", varname = "d2m")
dta_22_11 <- brick("2022_11.nc", varname = "d2m")
dta_22_12 <- brick("2022_12.nc", varname = "d2m")

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
d2m <- mosaic(sub_00, sub_01, sub_02, sub_03, sub_04, sub_05,
              sub_06, sub_07, sub_08, sub_09, sub_10, sub_11,
              sub_12, sub_13, sub_14, sub_15, sub_16, sub_17,
              sub_18, sub_19, sub_20, sub_21, sub_22, sub_23, fun = mean)
names(d2m) <- names(sub_00)



#### 2m temperature ####
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



#### Forecast albedo ####
## Naming convention is dta_year_month
#2004
dta_04_10 <- brick("2004_10.nc", varname = "fal")
dta_04_11 <- brick("2004_11.nc", varname = "fal")
dta_04_12 <- brick("2004_12.nc", varname = "fal")

#2005
dta_05_01 <- brick("2005_01.nc", varname = "fal")
dta_05_02 <- brick("2005_02.nc", varname = "fal")
dta_05_03 <- brick("2005_03.nc", varname = "fal")
dta_05_04 <- brick("2005_04.nc", varname = "fal")
dta_05_05 <- brick("2005_05.nc", varname = "fal")
dta_05_06 <- brick("2005_06.nc", varname = "fal")
dta_05_07 <- brick("2005_07.nc", varname = "fal")
dta_05_08 <- brick("2005_08.nc", varname = "fal")
dta_05_09 <- brick("2005_09.nc", varname = "fal")
dta_05_10 <- brick("2005_10.nc", varname = "fal")
dta_05_11 <- brick("2005_11.nc", varname = "fal")
dta_05_12 <- brick("2005_12.nc", varname = "fal")

#2006
dta_06_01 <- brick("2006_01.nc", varname = "fal")
dta_06_02 <- brick("2006_02.nc", varname = "fal")
dta_06_03 <- brick("2006_03.nc", varname = "fal")
dta_06_04 <- brick("2006_04.nc", varname = "fal")
dta_06_05 <- brick("2006_05.nc", varname = "fal")
dta_06_06 <- brick("2006_06.nc", varname = "fal")
dta_06_07 <- brick("2006_07.nc", varname = "fal")
dta_06_08 <- brick("2006_08.nc", varname = "fal")
dta_06_09 <- brick("2006_09.nc", varname = "fal")
dta_06_10 <- brick("2006_10.nc", varname = "fal")
dta_06_11 <- brick("2006_11.nc", varname = "fal")
dta_06_12 <- brick("2006_12.nc", varname = "fal")

#2007
dta_07_01 <- brick("2007_01.nc", varname = "fal")
dta_07_02 <- brick("2007_02.nc", varname = "fal")
dta_07_03 <- brick("2007_03.nc", varname = "fal")
dta_07_04 <- brick("2007_04.nc", varname = "fal")
dta_07_05 <- brick("2007_05.nc", varname = "fal")
dta_07_06 <- brick("2007_06.nc", varname = "fal")
dta_07_07 <- brick("2007_07.nc", varname = "fal")
dta_07_08 <- brick("2007_08.nc", varname = "fal")
dta_07_09 <- brick("2007_09.nc", varname = "fal")
dta_07_10 <- brick("2007_10.nc", varname = "fal")
dta_07_11 <- brick("2007_11.nc", varname = "fal")
dta_07_12 <- brick("2007_12.nc", varname = "fal")

#2008
dta_08_01 <- brick("2008_01.nc", varname = "fal")
dta_08_02 <- brick("2008_02.nc", varname = "fal")
dta_08_03 <- brick("2008_03.nc", varname = "fal")
dta_08_04 <- brick("2008_04.nc", varname = "fal")
dta_08_05 <- brick("2008_05.nc", varname = "fal")
dta_08_06 <- brick("2008_06.nc", varname = "fal")
dta_08_07 <- brick("2008_07.nc", varname = "fal")
dta_08_08 <- brick("2008_08.nc", varname = "fal")
dta_08_09 <- brick("2008_09.nc", varname = "fal")
dta_08_10 <- brick("2008_10.nc", varname = "fal")
dta_08_11 <- brick("2008_11.nc", varname = "fal")
dta_08_12 <- brick("2008_12.nc", varname = "fal")

#2009
dta_09_01 <- brick("2009_01.nc", varname = "fal")
dta_09_02 <- brick("2009_02.nc", varname = "fal")
dta_09_03 <- brick("2009_03.nc", varname = "fal")
dta_09_04 <- brick("2009_04.nc", varname = "fal")
dta_09_05 <- brick("2009_05.nc", varname = "fal")
dta_09_06 <- brick("2009_06.nc", varname = "fal")
dta_09_07 <- brick("2009_07.nc", varname = "fal")
dta_09_08 <- brick("2009_08.nc", varname = "fal")
dta_09_09 <- brick("2009_09.nc", varname = "fal")
dta_09_10 <- brick("2009_10.nc", varname = "fal")
dta_09_11 <- brick("2009_11.nc", varname = "fal")
dta_09_12 <- brick("2009_12.nc", varname = "fal")

#2010
dta_10_01 <- brick("2010_01.nc", varname = "fal")
dta_10_02 <- brick("2010_02.nc", varname = "fal")
dta_10_03 <- brick("2010_03.nc", varname = "fal")
dta_10_04 <- brick("2010_04.nc", varname = "fal")
dta_10_05 <- brick("2010_05.nc", varname = "fal")
dta_10_06 <- brick("2010_06.nc", varname = "fal")
dta_10_07 <- brick("2010_07.nc", varname = "fal")
dta_10_08 <- brick("2010_08.nc", varname = "fal")
dta_10_09 <- brick("2010_09.nc", varname = "fal")
dta_10_10 <- brick("2010_10.nc", varname = "fal")
dta_10_11 <- brick("2010_11.nc", varname = "fal")
dta_10_12 <- brick("2010_12.nc", varname = "fal")

#2011
dta_11_01 <- brick("2011_01.nc", varname = "fal")
dta_11_02 <- brick("2011_02.nc", varname = "fal")
dta_11_03 <- brick("2011_03.nc", varname = "fal")
dta_11_04 <- brick("2011_04.nc", varname = "fal")
dta_11_05 <- brick("2011_05.nc", varname = "fal")
dta_11_06 <- brick("2011_06.nc", varname = "fal")
dta_11_07 <- brick("2011_07.nc", varname = "fal")
dta_11_08 <- brick("2011_08.nc", varname = "fal")
dta_11_09 <- brick("2011_09.nc", varname = "fal")
dta_11_10 <- brick("2011_10.nc", varname = "fal")
dta_11_11 <- brick("2011_11.nc", varname = "fal")
dta_11_12 <- brick("2011_12.nc", varname = "fal")

#2012
dta_12_01 <- brick("2012_01.nc", varname = "fal")
dta_12_02 <- brick("2012_02.nc", varname = "fal")
dta_12_03 <- brick("2012_03.nc", varname = "fal")
dta_12_04 <- brick("2012_04.nc", varname = "fal")
dta_12_05 <- brick("2012_05.nc", varname = "fal")
dta_12_06 <- brick("2012_06.nc", varname = "fal")
dta_12_07 <- brick("2012_07.nc", varname = "fal")
dta_12_08 <- brick("2012_08.nc", varname = "fal")
dta_12_09 <- brick("2012_09.nc", varname = "fal")
dta_12_10 <- brick("2012_10.nc", varname = "fal")
dta_12_11 <- brick("2012_11.nc", varname = "fal")
dta_12_12 <- brick("2012_12.nc", varname = "fal")

#2013
dta_13_01 <- brick("2013_01.nc", varname = "fal")
dta_13_02 <- brick("2013_02.nc", varname = "fal")
dta_13_03 <- brick("2013_03.nc", varname = "fal")
dta_13_04 <- brick("2013_04.nc", varname = "fal")
dta_13_05 <- brick("2013_05.nc", varname = "fal")
dta_13_06 <- brick("2013_06.nc", varname = "fal")
dta_13_07 <- brick("2013_07.nc", varname = "fal")
dta_13_08 <- brick("2013_08.nc", varname = "fal")
dta_13_09 <- brick("2013_09.nc", varname = "fal")
dta_13_10 <- brick("2013_10.nc", varname = "fal")
dta_13_11 <- brick("2013_11.nc", varname = "fal")
dta_13_12 <- brick("2013_12.nc", varname = "fal")

#2014
dta_14_01 <- brick("2014_01.nc", varname = "fal")
dta_14_02 <- brick("2014_02.nc", varname = "fal")
dta_14_03 <- brick("2014_03.nc", varname = "fal")
dta_14_04 <- brick("2014_04.nc", varname = "fal")
dta_14_05 <- brick("2014_05.nc", varname = "fal")
dta_14_06 <- brick("2014_06.nc", varname = "fal")
dta_14_07 <- brick("2014_07.nc", varname = "fal")
dta_14_08 <- brick("2014_08.nc", varname = "fal")
dta_14_09 <- brick("2014_09.nc", varname = "fal")
dta_14_10 <- brick("2014_10.nc", varname = "fal")
dta_14_11 <- brick("2014_11.nc", varname = "fal")
dta_14_12 <- brick("2014_12.nc", varname = "fal")

#2015
dta_15_01 <- brick("2015_01.nc", varname = "fal")
dta_15_02 <- brick("2015_02.nc", varname = "fal")
dta_15_03 <- brick("2015_03.nc", varname = "fal")
dta_15_04 <- brick("2015_04.nc", varname = "fal")
dta_15_05 <- brick("2015_05.nc", varname = "fal")
dta_15_06 <- brick("2015_06.nc", varname = "fal")
dta_15_07 <- brick("2015_07.nc", varname = "fal")
dta_15_08 <- brick("2015_08.nc", varname = "fal")
dta_15_09 <- brick("2015_09.nc", varname = "fal")
dta_15_10 <- brick("2015_10.nc", varname = "fal")
dta_15_11 <- brick("2015_11.nc", varname = "fal")
dta_15_12 <- brick("2015_12.nc", varname = "fal")

#2016
dta_16_01 <- brick("2016_01.nc", varname = "fal")
dta_16_02 <- brick("2016_02.nc", varname = "fal")
dta_16_03 <- brick("2016_03.nc", varname = "fal")
dta_16_04 <- brick("2016_04.nc", varname = "fal")
dta_16_05 <- brick("2016_05.nc", varname = "fal")
dta_16_06 <- brick("2016_06.nc", varname = "fal")
dta_16_07 <- brick("2016_07.nc", varname = "fal")
dta_16_08 <- brick("2016_08.nc", varname = "fal")
dta_16_09 <- brick("2016_09.nc", varname = "fal")
dta_16_10 <- brick("2016_10.nc", varname = "fal")
dta_16_11 <- brick("2016_11.nc", varname = "fal")
dta_16_12 <- brick("2016_12.nc", varname = "fal")

#2017
dta_17_01 <- brick("2017_01.nc", varname = "fal")
dta_17_02 <- brick("2017_02.nc", varname = "fal")
dta_17_03 <- brick("2017_03.nc", varname = "fal")
dta_17_04 <- brick("2017_04.nc", varname = "fal")
dta_17_05 <- brick("2017_05.nc", varname = "fal")
dta_17_06 <- brick("2017_06.nc", varname = "fal")
dta_17_07 <- brick("2017_07.nc", varname = "fal")
dta_17_08 <- brick("2017_08.nc", varname = "fal")
dta_17_09 <- brick("2017_09.nc", varname = "fal")
dta_17_10 <- brick("2017_10.nc", varname = "fal")
dta_17_11 <- brick("2017_11.nc", varname = "fal")
dta_17_12 <- brick("2017_12.nc", varname = "fal")

#2018
dta_18_01 <- brick("2018_01.nc", varname = "fal")
dta_18_02 <- brick("2018_02.nc", varname = "fal")
dta_18_03 <- brick("2018_03.nc", varname = "fal")
dta_18_04 <- brick("2018_04.nc", varname = "fal")
dta_18_05 <- brick("2018_05.nc", varname = "fal")
dta_18_06 <- brick("2018_06.nc", varname = "fal")
dta_18_07 <- brick("2018_07.nc", varname = "fal")
dta_18_08 <- brick("2018_08.nc", varname = "fal")
dta_18_09 <- brick("2018_09.nc", varname = "fal")
dta_18_10 <- brick("2018_10.nc", varname = "fal")
dta_18_11 <- brick("2018_11.nc", varname = "fal")
dta_18_12 <- brick("2018_12.nc", varname = "fal")

#2019
dta_19_01 <- brick("2019_01.nc", varname = "fal")
dta_19_02 <- brick("2019_02.nc", varname = "fal")
dta_19_03 <- brick("2019_03.nc", varname = "fal")
dta_19_04 <- brick("2019_04.nc", varname = "fal")
dta_19_05 <- brick("2019_05.nc", varname = "fal")
dta_19_06 <- brick("2019_06.nc", varname = "fal")
dta_19_07 <- brick("2019_07.nc", varname = "fal")
dta_19_08 <- brick("2019_08.nc", varname = "fal")
dta_19_09 <- brick("2019_09.nc", varname = "fal")
dta_19_10 <- brick("2019_10.nc", varname = "fal")
dta_19_11 <- brick("2019_11.nc", varname = "fal")
dta_19_12 <- brick("2019_12.nc", varname = "fal")

#2020
dta_20_01 <- brick("2020_01.nc", varname = "fal")
dta_20_02 <- brick("2020_02.nc", varname = "fal")
dta_20_03 <- brick("2020_03.nc", varname = "fal")
dta_20_04 <- brick("2020_04.nc", varname = "fal")
dta_20_05 <- brick("2020_05.nc", varname = "fal")
dta_20_06 <- brick("2020_06.nc", varname = "fal")
dta_20_07 <- brick("2020_07.nc", varname = "fal")
dta_20_08 <- brick("2020_08.nc", varname = "fal")
dta_20_09 <- brick("2020_09.nc", varname = "fal")
dta_20_10 <- brick("2020_10.nc", varname = "fal")
dta_20_11 <- brick("2020_11.nc", varname = "fal")
dta_20_12 <- brick("2020_12.nc", varname = "fal")

#2021
dta_21_01 <- brick("2021_01.nc", varname = "fal")
dta_21_02 <- brick("2021_02.nc", varname = "fal")
dta_21_03 <- brick("2021_03.nc", varname = "fal")
dta_21_04 <- brick("2021_04.nc", varname = "fal")
dta_21_05 <- brick("2021_05.nc", varname = "fal")
dta_21_06 <- brick("2021_06.nc", varname = "fal")
dta_21_07 <- brick("2021_07.nc", varname = "fal")
dta_21_08 <- brick("2021_08.nc", varname = "fal")
dta_21_09 <- brick("2021_09.nc", varname = "fal")
dta_21_10 <- brick("2021_10.nc", varname = "fal")
dta_21_11 <- brick("2021_11.nc", varname = "fal")
dta_21_12 <- brick("2021_12.nc", varname = "fal")

#2022
dta_22_01 <- brick("2022_01.nc", varname = "fal")
dta_22_02 <- brick("2022_02.nc", varname = "fal")
dta_22_03 <- brick("2022_03.nc", varname = "fal")
dta_22_04 <- brick("2022_04.nc", varname = "fal")
dta_22_05 <- brick("2022_05.nc", varname = "fal")
dta_22_06 <- brick("2022_06.nc", varname = "fal")
dta_22_07 <- brick("2022_07.nc", varname = "fal")
dta_22_08 <- brick("2022_08.nc", varname = "fal")
dta_22_09 <- brick("2022_09.nc", varname = "fal")
dta_22_10 <- brick("2022_10.nc", varname = "fal")
dta_22_11 <- brick("2022_11.nc", varname = "fal")
dta_22_12 <- brick("2022_12.nc", varname = "fal")

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
fal <- mosaic(sub_00, sub_01, sub_02, sub_03, sub_04, sub_05,
              sub_06, sub_07, sub_08, sub_09, sub_10, sub_11,
              sub_12, sub_13, sub_14, sub_15, sub_16, sub_17,
              sub_18, sub_19, sub_20, sub_21, sub_22, sub_23, fun = mean)
names(fal) <- names(sub_00)


#### Skin reservoir content ####
## Naming convention is dta_year_month
#2004
dta_04_10 <- brick("2004_10.nc", varname = "src")
dta_04_11 <- brick("2004_11.nc", varname = "src")
dta_04_12 <- brick("2004_12.nc", varname = "src")

#2005
dta_05_01 <- brick("2005_01.nc", varname = "src")
dta_05_02 <- brick("2005_02.nc", varname = "src")
dta_05_03 <- brick("2005_03.nc", varname = "src")
dta_05_04 <- brick("2005_04.nc", varname = "src")
dta_05_05 <- brick("2005_05.nc", varname = "src")
dta_05_06 <- brick("2005_06.nc", varname = "src")
dta_05_07 <- brick("2005_07.nc", varname = "src")
dta_05_08 <- brick("2005_08.nc", varname = "src")
dta_05_09 <- brick("2005_09.nc", varname = "src")
dta_05_10 <- brick("2005_10.nc", varname = "src")
dta_05_11 <- brick("2005_11.nc", varname = "src")
dta_05_12 <- brick("2005_12.nc", varname = "src")

#2006
dta_06_01 <- brick("2006_01.nc", varname = "src")
dta_06_02 <- brick("2006_02.nc", varname = "src")
dta_06_03 <- brick("2006_03.nc", varname = "src")
dta_06_04 <- brick("2006_04.nc", varname = "src")
dta_06_05 <- brick("2006_05.nc", varname = "src")
dta_06_06 <- brick("2006_06.nc", varname = "src")
dta_06_07 <- brick("2006_07.nc", varname = "src")
dta_06_08 <- brick("2006_08.nc", varname = "src")
dta_06_09 <- brick("2006_09.nc", varname = "src")
dta_06_10 <- brick("2006_10.nc", varname = "src")
dta_06_11 <- brick("2006_11.nc", varname = "src")
dta_06_12 <- brick("2006_12.nc", varname = "src")

#2007
dta_07_01 <- brick("2007_01.nc", varname = "src")
dta_07_02 <- brick("2007_02.nc", varname = "src")
dta_07_03 <- brick("2007_03.nc", varname = "src")
dta_07_04 <- brick("2007_04.nc", varname = "src")
dta_07_05 <- brick("2007_05.nc", varname = "src")
dta_07_06 <- brick("2007_06.nc", varname = "src")
dta_07_07 <- brick("2007_07.nc", varname = "src")
dta_07_08 <- brick("2007_08.nc", varname = "src")
dta_07_09 <- brick("2007_09.nc", varname = "src")
dta_07_10 <- brick("2007_10.nc", varname = "src")
dta_07_11 <- brick("2007_11.nc", varname = "src")
dta_07_12 <- brick("2007_12.nc", varname = "src")

#2008
dta_08_01 <- brick("2008_01.nc", varname = "src")
dta_08_02 <- brick("2008_02.nc", varname = "src")
dta_08_03 <- brick("2008_03.nc", varname = "src")
dta_08_04 <- brick("2008_04.nc", varname = "src")
dta_08_05 <- brick("2008_05.nc", varname = "src")
dta_08_06 <- brick("2008_06.nc", varname = "src")
dta_08_07 <- brick("2008_07.nc", varname = "src")
dta_08_08 <- brick("2008_08.nc", varname = "src")
dta_08_09 <- brick("2008_09.nc", varname = "src")
dta_08_10 <- brick("2008_10.nc", varname = "src")
dta_08_11 <- brick("2008_11.nc", varname = "src")
dta_08_12 <- brick("2008_12.nc", varname = "src")

#2009
dta_09_01 <- brick("2009_01.nc", varname = "src")
dta_09_02 <- brick("2009_02.nc", varname = "src")
dta_09_03 <- brick("2009_03.nc", varname = "src")
dta_09_04 <- brick("2009_04.nc", varname = "src")
dta_09_05 <- brick("2009_05.nc", varname = "src")
dta_09_06 <- brick("2009_06.nc", varname = "src")
dta_09_07 <- brick("2009_07.nc", varname = "src")
dta_09_08 <- brick("2009_08.nc", varname = "src")
dta_09_09 <- brick("2009_09.nc", varname = "src")
dta_09_10 <- brick("2009_10.nc", varname = "src")
dta_09_11 <- brick("2009_11.nc", varname = "src")
dta_09_12 <- brick("2009_12.nc", varname = "src")

#2010
dta_10_01 <- brick("2010_01.nc", varname = "src")
dta_10_02 <- brick("2010_02.nc", varname = "src")
dta_10_03 <- brick("2010_03.nc", varname = "src")
dta_10_04 <- brick("2010_04.nc", varname = "src")
dta_10_05 <- brick("2010_05.nc", varname = "src")
dta_10_06 <- brick("2010_06.nc", varname = "src")
dta_10_07 <- brick("2010_07.nc", varname = "src")
dta_10_08 <- brick("2010_08.nc", varname = "src")
dta_10_09 <- brick("2010_09.nc", varname = "src")
dta_10_10 <- brick("2010_10.nc", varname = "src")
dta_10_11 <- brick("2010_11.nc", varname = "src")
dta_10_12 <- brick("2010_12.nc", varname = "src")

#2011
dta_11_01 <- brick("2011_01.nc", varname = "src")
dta_11_02 <- brick("2011_02.nc", varname = "src")
dta_11_03 <- brick("2011_03.nc", varname = "src")
dta_11_04 <- brick("2011_04.nc", varname = "src")
dta_11_05 <- brick("2011_05.nc", varname = "src")
dta_11_06 <- brick("2011_06.nc", varname = "src")
dta_11_07 <- brick("2011_07.nc", varname = "src")
dta_11_08 <- brick("2011_08.nc", varname = "src")
dta_11_09 <- brick("2011_09.nc", varname = "src")
dta_11_10 <- brick("2011_10.nc", varname = "src")
dta_11_11 <- brick("2011_11.nc", varname = "src")
dta_11_12 <- brick("2011_12.nc", varname = "src")

#2012
dta_12_01 <- brick("2012_01.nc", varname = "src")
dta_12_02 <- brick("2012_02.nc", varname = "src")
dta_12_03 <- brick("2012_03.nc", varname = "src")
dta_12_04 <- brick("2012_04.nc", varname = "src")
dta_12_05 <- brick("2012_05.nc", varname = "src")
dta_12_06 <- brick("2012_06.nc", varname = "src")
dta_12_07 <- brick("2012_07.nc", varname = "src")
dta_12_08 <- brick("2012_08.nc", varname = "src")
dta_12_09 <- brick("2012_09.nc", varname = "src")
dta_12_10 <- brick("2012_10.nc", varname = "src")
dta_12_11 <- brick("2012_11.nc", varname = "src")
dta_12_12 <- brick("2012_12.nc", varname = "src")

#2013
dta_13_01 <- brick("2013_01.nc", varname = "src")
dta_13_02 <- brick("2013_02.nc", varname = "src")
dta_13_03 <- brick("2013_03.nc", varname = "src")
dta_13_04 <- brick("2013_04.nc", varname = "src")
dta_13_05 <- brick("2013_05.nc", varname = "src")
dta_13_06 <- brick("2013_06.nc", varname = "src")
dta_13_07 <- brick("2013_07.nc", varname = "src")
dta_13_08 <- brick("2013_08.nc", varname = "src")
dta_13_09 <- brick("2013_09.nc", varname = "src")
dta_13_10 <- brick("2013_10.nc", varname = "src")
dta_13_11 <- brick("2013_11.nc", varname = "src")
dta_13_12 <- brick("2013_12.nc", varname = "src")

#2014
dta_14_01 <- brick("2014_01.nc", varname = "src")
dta_14_02 <- brick("2014_02.nc", varname = "src")
dta_14_03 <- brick("2014_03.nc", varname = "src")
dta_14_04 <- brick("2014_04.nc", varname = "src")
dta_14_05 <- brick("2014_05.nc", varname = "src")
dta_14_06 <- brick("2014_06.nc", varname = "src")
dta_14_07 <- brick("2014_07.nc", varname = "src")
dta_14_08 <- brick("2014_08.nc", varname = "src")
dta_14_09 <- brick("2014_09.nc", varname = "src")
dta_14_10 <- brick("2014_10.nc", varname = "src")
dta_14_11 <- brick("2014_11.nc", varname = "src")
dta_14_12 <- brick("2014_12.nc", varname = "src")

#2015
dta_15_01 <- brick("2015_01.nc", varname = "src")
dta_15_02 <- brick("2015_02.nc", varname = "src")
dta_15_03 <- brick("2015_03.nc", varname = "src")
dta_15_04 <- brick("2015_04.nc", varname = "src")
dta_15_05 <- brick("2015_05.nc", varname = "src")
dta_15_06 <- brick("2015_06.nc", varname = "src")
dta_15_07 <- brick("2015_07.nc", varname = "src")
dta_15_08 <- brick("2015_08.nc", varname = "src")
dta_15_09 <- brick("2015_09.nc", varname = "src")
dta_15_10 <- brick("2015_10.nc", varname = "src")
dta_15_11 <- brick("2015_11.nc", varname = "src")
dta_15_12 <- brick("2015_12.nc", varname = "src")

#2016
dta_16_01 <- brick("2016_01.nc", varname = "src")
dta_16_02 <- brick("2016_02.nc", varname = "src")
dta_16_03 <- brick("2016_03.nc", varname = "src")
dta_16_04 <- brick("2016_04.nc", varname = "src")
dta_16_05 <- brick("2016_05.nc", varname = "src")
dta_16_06 <- brick("2016_06.nc", varname = "src")
dta_16_07 <- brick("2016_07.nc", varname = "src")
dta_16_08 <- brick("2016_08.nc", varname = "src")
dta_16_09 <- brick("2016_09.nc", varname = "src")
dta_16_10 <- brick("2016_10.nc", varname = "src")
dta_16_11 <- brick("2016_11.nc", varname = "src")
dta_16_12 <- brick("2016_12.nc", varname = "src")

#2017
dta_17_01 <- brick("2017_01.nc", varname = "src")
dta_17_02 <- brick("2017_02.nc", varname = "src")
dta_17_03 <- brick("2017_03.nc", varname = "src")
dta_17_04 <- brick("2017_04.nc", varname = "src")
dta_17_05 <- brick("2017_05.nc", varname = "src")
dta_17_06 <- brick("2017_06.nc", varname = "src")
dta_17_07 <- brick("2017_07.nc", varname = "src")
dta_17_08 <- brick("2017_08.nc", varname = "src")
dta_17_09 <- brick("2017_09.nc", varname = "src")
dta_17_10 <- brick("2017_10.nc", varname = "src")
dta_17_11 <- brick("2017_11.nc", varname = "src")
dta_17_12 <- brick("2017_12.nc", varname = "src")

#2018
dta_18_01 <- brick("2018_01.nc", varname = "src")
dta_18_02 <- brick("2018_02.nc", varname = "src")
dta_18_03 <- brick("2018_03.nc", varname = "src")
dta_18_04 <- brick("2018_04.nc", varname = "src")
dta_18_05 <- brick("2018_05.nc", varname = "src")
dta_18_06 <- brick("2018_06.nc", varname = "src")
dta_18_07 <- brick("2018_07.nc", varname = "src")
dta_18_08 <- brick("2018_08.nc", varname = "src")
dta_18_09 <- brick("2018_09.nc", varname = "src")
dta_18_10 <- brick("2018_10.nc", varname = "src")
dta_18_11 <- brick("2018_11.nc", varname = "src")
dta_18_12 <- brick("2018_12.nc", varname = "src")

#2019
dta_19_01 <- brick("2019_01.nc", varname = "src")
dta_19_02 <- brick("2019_02.nc", varname = "src")
dta_19_03 <- brick("2019_03.nc", varname = "src")
dta_19_04 <- brick("2019_04.nc", varname = "src")
dta_19_05 <- brick("2019_05.nc", varname = "src")
dta_19_06 <- brick("2019_06.nc", varname = "src")
dta_19_07 <- brick("2019_07.nc", varname = "src")
dta_19_08 <- brick("2019_08.nc", varname = "src")
dta_19_09 <- brick("2019_09.nc", varname = "src")
dta_19_10 <- brick("2019_10.nc", varname = "src")
dta_19_11 <- brick("2019_11.nc", varname = "src")
dta_19_12 <- brick("2019_12.nc", varname = "src")

#2020
dta_20_01 <- brick("2020_01.nc", varname = "src")
dta_20_02 <- brick("2020_02.nc", varname = "src")
dta_20_03 <- brick("2020_03.nc", varname = "src")
dta_20_04 <- brick("2020_04.nc", varname = "src")
dta_20_05 <- brick("2020_05.nc", varname = "src")
dta_20_06 <- brick("2020_06.nc", varname = "src")
dta_20_07 <- brick("2020_07.nc", varname = "src")
dta_20_08 <- brick("2020_08.nc", varname = "src")
dta_20_09 <- brick("2020_09.nc", varname = "src")
dta_20_10 <- brick("2020_10.nc", varname = "src")
dta_20_11 <- brick("2020_11.nc", varname = "src")
dta_20_12 <- brick("2020_12.nc", varname = "src")

#2021
dta_21_01 <- brick("2021_01.nc", varname = "src")
dta_21_02 <- brick("2021_02.nc", varname = "src")
dta_21_03 <- brick("2021_03.nc", varname = "src")
dta_21_04 <- brick("2021_04.nc", varname = "src")
dta_21_05 <- brick("2021_05.nc", varname = "src")
dta_21_06 <- brick("2021_06.nc", varname = "src")
dta_21_07 <- brick("2021_07.nc", varname = "src")
dta_21_08 <- brick("2021_08.nc", varname = "src")
dta_21_09 <- brick("2021_09.nc", varname = "src")
dta_21_10 <- brick("2021_10.nc", varname = "src")
dta_21_11 <- brick("2021_11.nc", varname = "src")
dta_21_12 <- brick("2021_12.nc", varname = "src")

#2022
dta_22_01 <- brick("2022_01.nc", varname = "src")
dta_22_02 <- brick("2022_02.nc", varname = "src")
dta_22_03 <- brick("2022_03.nc", varname = "src")
dta_22_04 <- brick("2022_04.nc", varname = "src")
dta_22_05 <- brick("2022_05.nc", varname = "src")
dta_22_06 <- brick("2022_06.nc", varname = "src")
dta_22_07 <- brick("2022_07.nc", varname = "src")
dta_22_08 <- brick("2022_08.nc", varname = "src")
dta_22_09 <- brick("2022_09.nc", varname = "src")
dta_22_10 <- brick("2022_10.nc", varname = "src")
dta_22_11 <- brick("2022_11.nc", varname = "src")
dta_22_12 <- brick("2022_12.nc", varname = "src")

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
src <- mosaic(sub_00, sub_01, sub_02, sub_03, sub_04, sub_05,
              sub_06, sub_07, sub_08, sub_09, sub_10, sub_11,
              sub_12, sub_13, sub_14, sub_15, sub_16, sub_17,
              sub_18, sub_19, sub_20, sub_21, sub_22, sub_23, fun = mean)
names(src) <- names(sub_00)



#### Skin temperature ####
#2004
dta_04_10 <- brick("2004_10.nc", varname = "skt")
dta_04_11 <- brick("2004_11.nc", varname = "skt")
dta_04_12 <- brick("2004_12.nc", varname = "skt")

#2005
dta_05_01 <- brick("2005_01.nc", varname = "skt")
dta_05_02 <- brick("2005_02.nc", varname = "skt")
dta_05_03 <- brick("2005_03.nc", varname = "skt")
dta_05_04 <- brick("2005_04.nc", varname = "skt")
dta_05_05 <- brick("2005_05.nc", varname = "skt")
dta_05_06 <- brick("2005_06.nc", varname = "skt")
dta_05_07 <- brick("2005_07.nc", varname = "skt")
dta_05_08 <- brick("2005_08.nc", varname = "skt")
dta_05_09 <- brick("2005_09.nc", varname = "skt")
dta_05_10 <- brick("2005_10.nc", varname = "skt")
dta_05_11 <- brick("2005_11.nc", varname = "skt")
dta_05_12 <- brick("2005_12.nc", varname = "skt")

#2006
dta_06_01 <- brick("2006_01.nc", varname = "skt")
dta_06_02 <- brick("2006_02.nc", varname = "skt")
dta_06_03 <- brick("2006_03.nc", varname = "skt")
dta_06_04 <- brick("2006_04.nc", varname = "skt")
dta_06_05 <- brick("2006_05.nc", varname = "skt")
dta_06_06 <- brick("2006_06.nc", varname = "skt")
dta_06_07 <- brick("2006_07.nc", varname = "skt")
dta_06_08 <- brick("2006_08.nc", varname = "skt")
dta_06_09 <- brick("2006_09.nc", varname = "skt")
dta_06_10 <- brick("2006_10.nc", varname = "skt")
dta_06_11 <- brick("2006_11.nc", varname = "skt")
dta_06_12 <- brick("2006_12.nc", varname = "skt")

#2007
dta_07_01 <- brick("2007_01.nc", varname = "skt")
dta_07_02 <- brick("2007_02.nc", varname = "skt")
dta_07_03 <- brick("2007_03.nc", varname = "skt")
dta_07_04 <- brick("2007_04.nc", varname = "skt")
dta_07_05 <- brick("2007_05.nc", varname = "skt")
dta_07_06 <- brick("2007_06.nc", varname = "skt")
dta_07_07 <- brick("2007_07.nc", varname = "skt")
dta_07_08 <- brick("2007_08.nc", varname = "skt")
dta_07_09 <- brick("2007_09.nc", varname = "skt")
dta_07_10 <- brick("2007_10.nc", varname = "skt")
dta_07_11 <- brick("2007_11.nc", varname = "skt")
dta_07_12 <- brick("2007_12.nc", varname = "skt")

#2008
dta_08_01 <- brick("2008_01.nc", varname = "skt")
dta_08_02 <- brick("2008_02.nc", varname = "skt")
dta_08_03 <- brick("2008_03.nc", varname = "skt")
dta_08_04 <- brick("2008_04.nc", varname = "skt")
dta_08_05 <- brick("2008_05.nc", varname = "skt")
dta_08_06 <- brick("2008_06.nc", varname = "skt")
dta_08_07 <- brick("2008_07.nc", varname = "skt")
dta_08_08 <- brick("2008_08.nc", varname = "skt")
dta_08_09 <- brick("2008_09.nc", varname = "skt")
dta_08_10 <- brick("2008_10.nc", varname = "skt")
dta_08_11 <- brick("2008_11.nc", varname = "skt")
dta_08_12 <- brick("2008_12.nc", varname = "skt")

#2009
dta_09_01 <- brick("2009_01.nc", varname = "skt")
dta_09_02 <- brick("2009_02.nc", varname = "skt")
dta_09_03 <- brick("2009_03.nc", varname = "skt")
dta_09_04 <- brick("2009_04.nc", varname = "skt")
dta_09_05 <- brick("2009_05.nc", varname = "skt")
dta_09_06 <- brick("2009_06.nc", varname = "skt")
dta_09_07 <- brick("2009_07.nc", varname = "skt")
dta_09_08 <- brick("2009_08.nc", varname = "skt")
dta_09_09 <- brick("2009_09.nc", varname = "skt")
dta_09_10 <- brick("2009_10.nc", varname = "skt")
dta_09_11 <- brick("2009_11.nc", varname = "skt")
dta_09_12 <- brick("2009_12.nc", varname = "skt")

#2010
dta_10_01 <- brick("2010_01.nc", varname = "skt")
dta_10_02 <- brick("2010_02.nc", varname = "skt")
dta_10_03 <- brick("2010_03.nc", varname = "skt")
dta_10_04 <- brick("2010_04.nc", varname = "skt")
dta_10_05 <- brick("2010_05.nc", varname = "skt")
dta_10_06 <- brick("2010_06.nc", varname = "skt")
dta_10_07 <- brick("2010_07.nc", varname = "skt")
dta_10_08 <- brick("2010_08.nc", varname = "skt")
dta_10_09 <- brick("2010_09.nc", varname = "skt")
dta_10_10 <- brick("2010_10.nc", varname = "skt")
dta_10_11 <- brick("2010_11.nc", varname = "skt")
dta_10_12 <- brick("2010_12.nc", varname = "skt")

#2011
dta_11_01 <- brick("2011_01.nc", varname = "skt")
dta_11_02 <- brick("2011_02.nc", varname = "skt")
dta_11_03 <- brick("2011_03.nc", varname = "skt")
dta_11_04 <- brick("2011_04.nc", varname = "skt")
dta_11_05 <- brick("2011_05.nc", varname = "skt")
dta_11_06 <- brick("2011_06.nc", varname = "skt")
dta_11_07 <- brick("2011_07.nc", varname = "skt")
dta_11_08 <- brick("2011_08.nc", varname = "skt")
dta_11_09 <- brick("2011_09.nc", varname = "skt")
dta_11_10 <- brick("2011_10.nc", varname = "skt")
dta_11_11 <- brick("2011_11.nc", varname = "skt")
dta_11_12 <- brick("2011_12.nc", varname = "skt")

#2012
dta_12_01 <- brick("2012_01.nc", varname = "skt")
dta_12_02 <- brick("2012_02.nc", varname = "skt")
dta_12_03 <- brick("2012_03.nc", varname = "skt")
dta_12_04 <- brick("2012_04.nc", varname = "skt")
dta_12_05 <- brick("2012_05.nc", varname = "skt")
dta_12_06 <- brick("2012_06.nc", varname = "skt")
dta_12_07 <- brick("2012_07.nc", varname = "skt")
dta_12_08 <- brick("2012_08.nc", varname = "skt")
dta_12_09 <- brick("2012_09.nc", varname = "skt")
dta_12_10 <- brick("2012_10.nc", varname = "skt")
dta_12_11 <- brick("2012_11.nc", varname = "skt")
dta_12_12 <- brick("2012_12.nc", varname = "skt")

#2013
dta_13_01 <- brick("2013_01.nc", varname = "skt")
dta_13_02 <- brick("2013_02.nc", varname = "skt")
dta_13_03 <- brick("2013_03.nc", varname = "skt")
dta_13_04 <- brick("2013_04.nc", varname = "skt")
dta_13_05 <- brick("2013_05.nc", varname = "skt")
dta_13_06 <- brick("2013_06.nc", varname = "skt")
dta_13_07 <- brick("2013_07.nc", varname = "skt")
dta_13_08 <- brick("2013_08.nc", varname = "skt")
dta_13_09 <- brick("2013_09.nc", varname = "skt")
dta_13_10 <- brick("2013_10.nc", varname = "skt")
dta_13_11 <- brick("2013_11.nc", varname = "skt")
dta_13_12 <- brick("2013_12.nc", varname = "skt")

#2014
dta_14_01 <- brick("2014_01.nc", varname = "skt")
dta_14_02 <- brick("2014_02.nc", varname = "skt")
dta_14_03 <- brick("2014_03.nc", varname = "skt")
dta_14_04 <- brick("2014_04.nc", varname = "skt")
dta_14_05 <- brick("2014_05.nc", varname = "skt")
dta_14_06 <- brick("2014_06.nc", varname = "skt")
dta_14_07 <- brick("2014_07.nc", varname = "skt")
dta_14_08 <- brick("2014_08.nc", varname = "skt")
dta_14_09 <- brick("2014_09.nc", varname = "skt")
dta_14_10 <- brick("2014_10.nc", varname = "skt")
dta_14_11 <- brick("2014_11.nc", varname = "skt")
dta_14_12 <- brick("2014_12.nc", varname = "skt")

#2015
dta_15_01 <- brick("2015_01.nc", varname = "skt")
dta_15_02 <- brick("2015_02.nc", varname = "skt")
dta_15_03 <- brick("2015_03.nc", varname = "skt")
dta_15_04 <- brick("2015_04.nc", varname = "skt")
dta_15_05 <- brick("2015_05.nc", varname = "skt")
dta_15_06 <- brick("2015_06.nc", varname = "skt")
dta_15_07 <- brick("2015_07.nc", varname = "skt")
dta_15_08 <- brick("2015_08.nc", varname = "skt")
dta_15_09 <- brick("2015_09.nc", varname = "skt")
dta_15_10 <- brick("2015_10.nc", varname = "skt")
dta_15_11 <- brick("2015_11.nc", varname = "skt")
dta_15_12 <- brick("2015_12.nc", varname = "skt")

#2016
dta_16_01 <- brick("2016_01.nc", varname = "skt")
dta_16_02 <- brick("2016_02.nc", varname = "skt")
dta_16_03 <- brick("2016_03.nc", varname = "skt")
dta_16_04 <- brick("2016_04.nc", varname = "skt")
dta_16_05 <- brick("2016_05.nc", varname = "skt")
dta_16_06 <- brick("2016_06.nc", varname = "skt")
dta_16_07 <- brick("2016_07.nc", varname = "skt")
dta_16_08 <- brick("2016_08.nc", varname = "skt")
dta_16_09 <- brick("2016_09.nc", varname = "skt")
dta_16_10 <- brick("2016_10.nc", varname = "skt")
dta_16_11 <- brick("2016_11.nc", varname = "skt")
dta_16_12 <- brick("2016_12.nc", varname = "skt")

#2017
dta_17_01 <- brick("2017_01.nc", varname = "skt")
dta_17_02 <- brick("2017_02.nc", varname = "skt")
dta_17_03 <- brick("2017_03.nc", varname = "skt")
dta_17_04 <- brick("2017_04.nc", varname = "skt")
dta_17_05 <- brick("2017_05.nc", varname = "skt")
dta_17_06 <- brick("2017_06.nc", varname = "skt")
dta_17_07 <- brick("2017_07.nc", varname = "skt")
dta_17_08 <- brick("2017_08.nc", varname = "skt")
dta_17_09 <- brick("2017_09.nc", varname = "skt")
dta_17_10 <- brick("2017_10.nc", varname = "skt")
dta_17_11 <- brick("2017_11.nc", varname = "skt")
dta_17_12 <- brick("2017_12.nc", varname = "skt")

#2018
dta_18_01 <- brick("2018_01.nc", varname = "skt")
dta_18_02 <- brick("2018_02.nc", varname = "skt")
dta_18_03 <- brick("2018_03.nc", varname = "skt")
dta_18_04 <- brick("2018_04.nc", varname = "skt")
dta_18_05 <- brick("2018_05.nc", varname = "skt")
dta_18_06 <- brick("2018_06.nc", varname = "skt")
dta_18_07 <- brick("2018_07.nc", varname = "skt")
dta_18_08 <- brick("2018_08.nc", varname = "skt")
dta_18_09 <- brick("2018_09.nc", varname = "skt")
dta_18_10 <- brick("2018_10.nc", varname = "skt")
dta_18_11 <- brick("2018_11.nc", varname = "skt")
dta_18_12 <- brick("2018_12.nc", varname = "skt")

#2019
dta_19_01 <- brick("2019_01.nc", varname = "skt")
dta_19_02 <- brick("2019_02.nc", varname = "skt")
dta_19_03 <- brick("2019_03.nc", varname = "skt")
dta_19_04 <- brick("2019_04.nc", varname = "skt")
dta_19_05 <- brick("2019_05.nc", varname = "skt")
dta_19_06 <- brick("2019_06.nc", varname = "skt")
dta_19_07 <- brick("2019_07.nc", varname = "skt")
dta_19_08 <- brick("2019_08.nc", varname = "skt")
dta_19_09 <- brick("2019_09.nc", varname = "skt")
dta_19_10 <- brick("2019_10.nc", varname = "skt")
dta_19_11 <- brick("2019_11.nc", varname = "skt")
dta_19_12 <- brick("2019_12.nc", varname = "skt")

#2020
dta_20_01 <- brick("2020_01.nc", varname = "skt")
dta_20_02 <- brick("2020_02.nc", varname = "skt")
dta_20_03 <- brick("2020_03.nc", varname = "skt")
dta_20_04 <- brick("2020_04.nc", varname = "skt")
dta_20_05 <- brick("2020_05.nc", varname = "skt")
dta_20_06 <- brick("2020_06.nc", varname = "skt")
dta_20_07 <- brick("2020_07.nc", varname = "skt")
dta_20_08 <- brick("2020_08.nc", varname = "skt")
dta_20_09 <- brick("2020_09.nc", varname = "skt")
dta_20_10 <- brick("2020_10.nc", varname = "skt")
dta_20_11 <- brick("2020_11.nc", varname = "skt")
dta_20_12 <- brick("2020_12.nc", varname = "skt")

#2021
dta_21_01 <- brick("2021_01.nc", varname = "skt")
dta_21_02 <- brick("2021_02.nc", varname = "skt")
dta_21_03 <- brick("2021_03.nc", varname = "skt")
dta_21_04 <- brick("2021_04.nc", varname = "skt")
dta_21_05 <- brick("2021_05.nc", varname = "skt")
dta_21_06 <- brick("2021_06.nc", varname = "skt")
dta_21_07 <- brick("2021_07.nc", varname = "skt")
dta_21_08 <- brick("2021_08.nc", varname = "skt")
dta_21_09 <- brick("2021_09.nc", varname = "skt")
dta_21_10 <- brick("2021_10.nc", varname = "skt")
dta_21_11 <- brick("2021_11.nc", varname = "skt")
dta_21_12 <- brick("2021_12.nc", varname = "skt")

#2022
dta_22_01 <- brick("2022_01.nc", varname = "skt")
dta_22_02 <- brick("2022_02.nc", varname = "skt")
dta_22_03 <- brick("2022_03.nc", varname = "skt")
dta_22_04 <- brick("2022_04.nc", varname = "skt")
dta_22_05 <- brick("2022_05.nc", varname = "skt")
dta_22_06 <- brick("2022_06.nc", varname = "skt")
dta_22_07 <- brick("2022_07.nc", varname = "skt")
dta_22_08 <- brick("2022_08.nc", varname = "skt")
dta_22_09 <- brick("2022_09.nc", varname = "skt")
dta_22_10 <- brick("2022_10.nc", varname = "skt")
dta_22_11 <- brick("2022_11.nc", varname = "skt")
dta_22_12 <- brick("2022_12.nc", varname = "skt")

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
skt <- mosaic(sub_00, sub_01, sub_02, sub_03, sub_04, sub_05,
              sub_06, sub_07, sub_08, sub_09, sub_10, sub_11,
              sub_12, sub_13, sub_14, sub_15, sub_16, sub_17,
              sub_18, sub_19, sub_20, sub_21, sub_22, sub_23, fun = mean)
names(skt) <- names(sub_00)



#### Soil temperature level 1 ####
#2004
dta_04_10 <- brick("2004_10.nc", varname = "stl1")
dta_04_11 <- brick("2004_11.nc", varname = "stl1")
dta_04_12 <- brick("2004_12.nc", varname = "stl1")

#2005
dta_05_01 <- brick("2005_01.nc", varname = "stl1")
dta_05_02 <- brick("2005_02.nc", varname = "stl1")
dta_05_03 <- brick("2005_03.nc", varname = "stl1")
dta_05_04 <- brick("2005_04.nc", varname = "stl1")
dta_05_05 <- brick("2005_05.nc", varname = "stl1")
dta_05_06 <- brick("2005_06.nc", varname = "stl1")
dta_05_07 <- brick("2005_07.nc", varname = "stl1")
dta_05_08 <- brick("2005_08.nc", varname = "stl1")
dta_05_09 <- brick("2005_09.nc", varname = "stl1")
dta_05_10 <- brick("2005_10.nc", varname = "stl1")
dta_05_11 <- brick("2005_11.nc", varname = "stl1")
dta_05_12 <- brick("2005_12.nc", varname = "stl1")

#2006
dta_06_01 <- brick("2006_01.nc", varname = "stl1")
dta_06_02 <- brick("2006_02.nc", varname = "stl1")
dta_06_03 <- brick("2006_03.nc", varname = "stl1")
dta_06_04 <- brick("2006_04.nc", varname = "stl1")
dta_06_05 <- brick("2006_05.nc", varname = "stl1")
dta_06_06 <- brick("2006_06.nc", varname = "stl1")
dta_06_07 <- brick("2006_07.nc", varname = "stl1")
dta_06_08 <- brick("2006_08.nc", varname = "stl1")
dta_06_09 <- brick("2006_09.nc", varname = "stl1")
dta_06_10 <- brick("2006_10.nc", varname = "stl1")
dta_06_11 <- brick("2006_11.nc", varname = "stl1")
dta_06_12 <- brick("2006_12.nc", varname = "stl1")

#2007
dta_07_01 <- brick("2007_01.nc", varname = "stl1")
dta_07_02 <- brick("2007_02.nc", varname = "stl1")
dta_07_03 <- brick("2007_03.nc", varname = "stl1")
dta_07_04 <- brick("2007_04.nc", varname = "stl1")
dta_07_05 <- brick("2007_05.nc", varname = "stl1")
dta_07_06 <- brick("2007_06.nc", varname = "stl1")
dta_07_07 <- brick("2007_07.nc", varname = "stl1")
dta_07_08 <- brick("2007_08.nc", varname = "stl1")
dta_07_09 <- brick("2007_09.nc", varname = "stl1")
dta_07_10 <- brick("2007_10.nc", varname = "stl1")
dta_07_11 <- brick("2007_11.nc", varname = "stl1")
dta_07_12 <- brick("2007_12.nc", varname = "stl1")

#2008
dta_08_01 <- brick("2008_01.nc", varname = "stl1")
dta_08_02 <- brick("2008_02.nc", varname = "stl1")
dta_08_03 <- brick("2008_03.nc", varname = "stl1")
dta_08_04 <- brick("2008_04.nc", varname = "stl1")
dta_08_05 <- brick("2008_05.nc", varname = "stl1")
dta_08_06 <- brick("2008_06.nc", varname = "stl1")
dta_08_07 <- brick("2008_07.nc", varname = "stl1")
dta_08_08 <- brick("2008_08.nc", varname = "stl1")
dta_08_09 <- brick("2008_09.nc", varname = "stl1")
dta_08_10 <- brick("2008_10.nc", varname = "stl1")
dta_08_11 <- brick("2008_11.nc", varname = "stl1")
dta_08_12 <- brick("2008_12.nc", varname = "stl1")

#2009
dta_09_01 <- brick("2009_01.nc", varname = "stl1")
dta_09_02 <- brick("2009_02.nc", varname = "stl1")
dta_09_03 <- brick("2009_03.nc", varname = "stl1")
dta_09_04 <- brick("2009_04.nc", varname = "stl1")
dta_09_05 <- brick("2009_05.nc", varname = "stl1")
dta_09_06 <- brick("2009_06.nc", varname = "stl1")
dta_09_07 <- brick("2009_07.nc", varname = "stl1")
dta_09_08 <- brick("2009_08.nc", varname = "stl1")
dta_09_09 <- brick("2009_09.nc", varname = "stl1")
dta_09_10 <- brick("2009_10.nc", varname = "stl1")
dta_09_11 <- brick("2009_11.nc", varname = "stl1")
dta_09_12 <- brick("2009_12.nc", varname = "stl1")

#2010
dta_10_01 <- brick("2010_01.nc", varname = "stl1")
dta_10_02 <- brick("2010_02.nc", varname = "stl1")
dta_10_03 <- brick("2010_03.nc", varname = "stl1")
dta_10_04 <- brick("2010_04.nc", varname = "stl1")
dta_10_05 <- brick("2010_05.nc", varname = "stl1")
dta_10_06 <- brick("2010_06.nc", varname = "stl1")
dta_10_07 <- brick("2010_07.nc", varname = "stl1")
dta_10_08 <- brick("2010_08.nc", varname = "stl1")
dta_10_09 <- brick("2010_09.nc", varname = "stl1")
dta_10_10 <- brick("2010_10.nc", varname = "stl1")
dta_10_11 <- brick("2010_11.nc", varname = "stl1")
dta_10_12 <- brick("2010_12.nc", varname = "stl1")

#2011
dta_11_01 <- brick("2011_01.nc", varname = "stl1")
dta_11_02 <- brick("2011_02.nc", varname = "stl1")
dta_11_03 <- brick("2011_03.nc", varname = "stl1")
dta_11_04 <- brick("2011_04.nc", varname = "stl1")
dta_11_05 <- brick("2011_05.nc", varname = "stl1")
dta_11_06 <- brick("2011_06.nc", varname = "stl1")
dta_11_07 <- brick("2011_07.nc", varname = "stl1")
dta_11_08 <- brick("2011_08.nc", varname = "stl1")
dta_11_09 <- brick("2011_09.nc", varname = "stl1")
dta_11_10 <- brick("2011_10.nc", varname = "stl1")
dta_11_11 <- brick("2011_11.nc", varname = "stl1")
dta_11_12 <- brick("2011_12.nc", varname = "stl1")

#2012
dta_12_01 <- brick("2012_01.nc", varname = "stl1")
dta_12_02 <- brick("2012_02.nc", varname = "stl1")
dta_12_03 <- brick("2012_03.nc", varname = "stl1")
dta_12_04 <- brick("2012_04.nc", varname = "stl1")
dta_12_05 <- brick("2012_05.nc", varname = "stl1")
dta_12_06 <- brick("2012_06.nc", varname = "stl1")
dta_12_07 <- brick("2012_07.nc", varname = "stl1")
dta_12_08 <- brick("2012_08.nc", varname = "stl1")
dta_12_09 <- brick("2012_09.nc", varname = "stl1")
dta_12_10 <- brick("2012_10.nc", varname = "stl1")
dta_12_11 <- brick("2012_11.nc", varname = "stl1")
dta_12_12 <- brick("2012_12.nc", varname = "stl1")

#2013
dta_13_01 <- brick("2013_01.nc", varname = "stl1")
dta_13_02 <- brick("2013_02.nc", varname = "stl1")
dta_13_03 <- brick("2013_03.nc", varname = "stl1")
dta_13_04 <- brick("2013_04.nc", varname = "stl1")
dta_13_05 <- brick("2013_05.nc", varname = "stl1")
dta_13_06 <- brick("2013_06.nc", varname = "stl1")
dta_13_07 <- brick("2013_07.nc", varname = "stl1")
dta_13_08 <- brick("2013_08.nc", varname = "stl1")
dta_13_09 <- brick("2013_09.nc", varname = "stl1")
dta_13_10 <- brick("2013_10.nc", varname = "stl1")
dta_13_11 <- brick("2013_11.nc", varname = "stl1")
dta_13_12 <- brick("2013_12.nc", varname = "stl1")

#2014
dta_14_01 <- brick("2014_01.nc", varname = "stl1")
dta_14_02 <- brick("2014_02.nc", varname = "stl1")
dta_14_03 <- brick("2014_03.nc", varname = "stl1")
dta_14_04 <- brick("2014_04.nc", varname = "stl1")
dta_14_05 <- brick("2014_05.nc", varname = "stl1")
dta_14_06 <- brick("2014_06.nc", varname = "stl1")
dta_14_07 <- brick("2014_07.nc", varname = "stl1")
dta_14_08 <- brick("2014_08.nc", varname = "stl1")
dta_14_09 <- brick("2014_09.nc", varname = "stl1")
dta_14_10 <- brick("2014_10.nc", varname = "stl1")
dta_14_11 <- brick("2014_11.nc", varname = "stl1")
dta_14_12 <- brick("2014_12.nc", varname = "stl1")

#2015
dta_15_01 <- brick("2015_01.nc", varname = "stl1")
dta_15_02 <- brick("2015_02.nc", varname = "stl1")
dta_15_03 <- brick("2015_03.nc", varname = "stl1")
dta_15_04 <- brick("2015_04.nc", varname = "stl1")
dta_15_05 <- brick("2015_05.nc", varname = "stl1")
dta_15_06 <- brick("2015_06.nc", varname = "stl1")
dta_15_07 <- brick("2015_07.nc", varname = "stl1")
dta_15_08 <- brick("2015_08.nc", varname = "stl1")
dta_15_09 <- brick("2015_09.nc", varname = "stl1")
dta_15_10 <- brick("2015_10.nc", varname = "stl1")
dta_15_11 <- brick("2015_11.nc", varname = "stl1")
dta_15_12 <- brick("2015_12.nc", varname = "stl1")

#2016
dta_16_01 <- brick("2016_01.nc", varname = "stl1")
dta_16_02 <- brick("2016_02.nc", varname = "stl1")
dta_16_03 <- brick("2016_03.nc", varname = "stl1")
dta_16_04 <- brick("2016_04.nc", varname = "stl1")
dta_16_05 <- brick("2016_05.nc", varname = "stl1")
dta_16_06 <- brick("2016_06.nc", varname = "stl1")
dta_16_07 <- brick("2016_07.nc", varname = "stl1")
dta_16_08 <- brick("2016_08.nc", varname = "stl1")
dta_16_09 <- brick("2016_09.nc", varname = "stl1")
dta_16_10 <- brick("2016_10.nc", varname = "stl1")
dta_16_11 <- brick("2016_11.nc", varname = "stl1")
dta_16_12 <- brick("2016_12.nc", varname = "stl1")

#2017
dta_17_01 <- brick("2017_01.nc", varname = "stl1")
dta_17_02 <- brick("2017_02.nc", varname = "stl1")
dta_17_03 <- brick("2017_03.nc", varname = "stl1")
dta_17_04 <- brick("2017_04.nc", varname = "stl1")
dta_17_05 <- brick("2017_05.nc", varname = "stl1")
dta_17_06 <- brick("2017_06.nc", varname = "stl1")
dta_17_07 <- brick("2017_07.nc", varname = "stl1")
dta_17_08 <- brick("2017_08.nc", varname = "stl1")
dta_17_09 <- brick("2017_09.nc", varname = "stl1")
dta_17_10 <- brick("2017_10.nc", varname = "stl1")
dta_17_11 <- brick("2017_11.nc", varname = "stl1")
dta_17_12 <- brick("2017_12.nc", varname = "stl1")

#2018
dta_18_01 <- brick("2018_01.nc", varname = "stl1")
dta_18_02 <- brick("2018_02.nc", varname = "stl1")
dta_18_03 <- brick("2018_03.nc", varname = "stl1")
dta_18_04 <- brick("2018_04.nc", varname = "stl1")
dta_18_05 <- brick("2018_05.nc", varname = "stl1")
dta_18_06 <- brick("2018_06.nc", varname = "stl1")
dta_18_07 <- brick("2018_07.nc", varname = "stl1")
dta_18_08 <- brick("2018_08.nc", varname = "stl1")
dta_18_09 <- brick("2018_09.nc", varname = "stl1")
dta_18_10 <- brick("2018_10.nc", varname = "stl1")
dta_18_11 <- brick("2018_11.nc", varname = "stl1")
dta_18_12 <- brick("2018_12.nc", varname = "stl1")

#2019
dta_19_01 <- brick("2019_01.nc", varname = "stl1")
dta_19_02 <- brick("2019_02.nc", varname = "stl1")
dta_19_03 <- brick("2019_03.nc", varname = "stl1")
dta_19_04 <- brick("2019_04.nc", varname = "stl1")
dta_19_05 <- brick("2019_05.nc", varname = "stl1")
dta_19_06 <- brick("2019_06.nc", varname = "stl1")
dta_19_07 <- brick("2019_07.nc", varname = "stl1")
dta_19_08 <- brick("2019_08.nc", varname = "stl1")
dta_19_09 <- brick("2019_09.nc", varname = "stl1")
dta_19_10 <- brick("2019_10.nc", varname = "stl1")
dta_19_11 <- brick("2019_11.nc", varname = "stl1")
dta_19_12 <- brick("2019_12.nc", varname = "stl1")

#2020
dta_20_01 <- brick("2020_01.nc", varname = "stl1")
dta_20_02 <- brick("2020_02.nc", varname = "stl1")
dta_20_03 <- brick("2020_03.nc", varname = "stl1")
dta_20_04 <- brick("2020_04.nc", varname = "stl1")
dta_20_05 <- brick("2020_05.nc", varname = "stl1")
dta_20_06 <- brick("2020_06.nc", varname = "stl1")
dta_20_07 <- brick("2020_07.nc", varname = "stl1")
dta_20_08 <- brick("2020_08.nc", varname = "stl1")
dta_20_09 <- brick("2020_09.nc", varname = "stl1")
dta_20_10 <- brick("2020_10.nc", varname = "stl1")
dta_20_11 <- brick("2020_11.nc", varname = "stl1")
dta_20_12 <- brick("2020_12.nc", varname = "stl1")

#2021
dta_21_01 <- brick("2021_01.nc", varname = "stl1")
dta_21_02 <- brick("2021_02.nc", varname = "stl1")
dta_21_03 <- brick("2021_03.nc", varname = "stl1")
dta_21_04 <- brick("2021_04.nc", varname = "stl1")
dta_21_05 <- brick("2021_05.nc", varname = "stl1")
dta_21_06 <- brick("2021_06.nc", varname = "stl1")
dta_21_07 <- brick("2021_07.nc", varname = "stl1")
dta_21_08 <- brick("2021_08.nc", varname = "stl1")
dta_21_09 <- brick("2021_09.nc", varname = "stl1")
dta_21_10 <- brick("2021_10.nc", varname = "stl1")
dta_21_11 <- brick("2021_11.nc", varname = "stl1")
dta_21_12 <- brick("2021_12.nc", varname = "stl1")

#2022
dta_22_01 <- brick("2022_01.nc", varname = "stl1")
dta_22_02 <- brick("2022_02.nc", varname = "stl1")
dta_22_03 <- brick("2022_03.nc", varname = "stl1")
dta_22_04 <- brick("2022_04.nc", varname = "stl1")
dta_22_05 <- brick("2022_05.nc", varname = "stl1")
dta_22_06 <- brick("2022_06.nc", varname = "stl1")
dta_22_07 <- brick("2022_07.nc", varname = "stl1")
dta_22_08 <- brick("2022_08.nc", varname = "stl1")
dta_22_09 <- brick("2022_09.nc", varname = "stl1")
dta_22_10 <- brick("2022_10.nc", varname = "stl1")
dta_22_11 <- brick("2022_11.nc", varname = "stl1")
dta_22_12 <- brick("2022_12.nc", varname = "stl1")

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
stl1 <- mosaic(sub_00, sub_01, sub_02, sub_03, sub_04, sub_05,
              sub_06, sub_07, sub_08, sub_09, sub_10, sub_11,
              sub_12, sub_13, sub_14, sub_15, sub_16, sub_17,
              sub_18, sub_19, sub_20, sub_21, sub_22, sub_23, fun = mean)
names(stl1) <- names(sub_00)



#### Surface net thermal radiation ####
#2004
dta_04_10 <- brick("2004_10.nc", varname = "str")
dta_04_11 <- brick("2004_11.nc", varname = "str")
dta_04_12 <- brick("2004_12.nc", varname = "str")

#2005
dta_05_01 <- brick("2005_01.nc", varname = "str")
dta_05_02 <- brick("2005_02.nc", varname = "str")
dta_05_03 <- brick("2005_03.nc", varname = "str")
dta_05_04 <- brick("2005_04.nc", varname = "str")
dta_05_05 <- brick("2005_05.nc", varname = "str")
dta_05_06 <- brick("2005_06.nc", varname = "str")
dta_05_07 <- brick("2005_07.nc", varname = "str")
dta_05_08 <- brick("2005_08.nc", varname = "str")
dta_05_09 <- brick("2005_09.nc", varname = "str")
dta_05_10 <- brick("2005_10.nc", varname = "str")
dta_05_11 <- brick("2005_11.nc", varname = "str")
dta_05_12 <- brick("2005_12.nc", varname = "str")

#2006
dta_06_01 <- brick("2006_01.nc", varname = "str")
dta_06_02 <- brick("2006_02.nc", varname = "str")
dta_06_03 <- brick("2006_03.nc", varname = "str")
dta_06_04 <- brick("2006_04.nc", varname = "str")
dta_06_05 <- brick("2006_05.nc", varname = "str")
dta_06_06 <- brick("2006_06.nc", varname = "str")
dta_06_07 <- brick("2006_07.nc", varname = "str")
dta_06_08 <- brick("2006_08.nc", varname = "str")
dta_06_09 <- brick("2006_09.nc", varname = "str")
dta_06_10 <- brick("2006_10.nc", varname = "str")
dta_06_11 <- brick("2006_11.nc", varname = "str")
dta_06_12 <- brick("2006_12.nc", varname = "str")

#2007
dta_07_01 <- brick("2007_01.nc", varname = "str")
dta_07_02 <- brick("2007_02.nc", varname = "str")
dta_07_03 <- brick("2007_03.nc", varname = "str")
dta_07_04 <- brick("2007_04.nc", varname = "str")
dta_07_05 <- brick("2007_05.nc", varname = "str")
dta_07_06 <- brick("2007_06.nc", varname = "str")
dta_07_07 <- brick("2007_07.nc", varname = "str")
dta_07_08 <- brick("2007_08.nc", varname = "str")
dta_07_09 <- brick("2007_09.nc", varname = "str")
dta_07_10 <- brick("2007_10.nc", varname = "str")
dta_07_11 <- brick("2007_11.nc", varname = "str")
dta_07_12 <- brick("2007_12.nc", varname = "str")

#2008
dta_08_01 <- brick("2008_01.nc", varname = "str")
dta_08_02 <- brick("2008_02.nc", varname = "str")
dta_08_03 <- brick("2008_03.nc", varname = "str")
dta_08_04 <- brick("2008_04.nc", varname = "str")
dta_08_05 <- brick("2008_05.nc", varname = "str")
dta_08_06 <- brick("2008_06.nc", varname = "str")
dta_08_07 <- brick("2008_07.nc", varname = "str")
dta_08_08 <- brick("2008_08.nc", varname = "str")
dta_08_09 <- brick("2008_09.nc", varname = "str")
dta_08_10 <- brick("2008_10.nc", varname = "str")
dta_08_11 <- brick("2008_11.nc", varname = "str")
dta_08_12 <- brick("2008_12.nc", varname = "str")

#2009
dta_09_01 <- brick("2009_01.nc", varname = "str")
dta_09_02 <- brick("2009_02.nc", varname = "str")
dta_09_03 <- brick("2009_03.nc", varname = "str")
dta_09_04 <- brick("2009_04.nc", varname = "str")
dta_09_05 <- brick("2009_05.nc", varname = "str")
dta_09_06 <- brick("2009_06.nc", varname = "str")
dta_09_07 <- brick("2009_07.nc", varname = "str")
dta_09_08 <- brick("2009_08.nc", varname = "str")
dta_09_09 <- brick("2009_09.nc", varname = "str")
dta_09_10 <- brick("2009_10.nc", varname = "str")
dta_09_11 <- brick("2009_11.nc", varname = "str")
dta_09_12 <- brick("2009_12.nc", varname = "str")

#2010
dta_10_01 <- brick("2010_01.nc", varname = "str")
dta_10_02 <- brick("2010_02.nc", varname = "str")
dta_10_03 <- brick("2010_03.nc", varname = "str")
dta_10_04 <- brick("2010_04.nc", varname = "str")
dta_10_05 <- brick("2010_05.nc", varname = "str")
dta_10_06 <- brick("2010_06.nc", varname = "str")
dta_10_07 <- brick("2010_07.nc", varname = "str")
dta_10_08 <- brick("2010_08.nc", varname = "str")
dta_10_09 <- brick("2010_09.nc", varname = "str")
dta_10_10 <- brick("2010_10.nc", varname = "str")
dta_10_11 <- brick("2010_11.nc", varname = "str")
dta_10_12 <- brick("2010_12.nc", varname = "str")

#2011
dta_11_01 <- brick("2011_01.nc", varname = "str")
dta_11_02 <- brick("2011_02.nc", varname = "str")
dta_11_03 <- brick("2011_03.nc", varname = "str")
dta_11_04 <- brick("2011_04.nc", varname = "str")
dta_11_05 <- brick("2011_05.nc", varname = "str")
dta_11_06 <- brick("2011_06.nc", varname = "str")
dta_11_07 <- brick("2011_07.nc", varname = "str")
dta_11_08 <- brick("2011_08.nc", varname = "str")
dta_11_09 <- brick("2011_09.nc", varname = "str")
dta_11_10 <- brick("2011_10.nc", varname = "str")
dta_11_11 <- brick("2011_11.nc", varname = "str")
dta_11_12 <- brick("2011_12.nc", varname = "str")

#2012
dta_12_01 <- brick("2012_01.nc", varname = "str")
dta_12_02 <- brick("2012_02.nc", varname = "str")
dta_12_03 <- brick("2012_03.nc", varname = "str")
dta_12_04 <- brick("2012_04.nc", varname = "str")
dta_12_05 <- brick("2012_05.nc", varname = "str")
dta_12_06 <- brick("2012_06.nc", varname = "str")
dta_12_07 <- brick("2012_07.nc", varname = "str")
dta_12_08 <- brick("2012_08.nc", varname = "str")
dta_12_09 <- brick("2012_09.nc", varname = "str")
dta_12_10 <- brick("2012_10.nc", varname = "str")
dta_12_11 <- brick("2012_11.nc", varname = "str")
dta_12_12 <- brick("2012_12.nc", varname = "str")

#2013
dta_13_01 <- brick("2013_01.nc", varname = "str")
dta_13_02 <- brick("2013_02.nc", varname = "str")
dta_13_03 <- brick("2013_03.nc", varname = "str")
dta_13_04 <- brick("2013_04.nc", varname = "str")
dta_13_05 <- brick("2013_05.nc", varname = "str")
dta_13_06 <- brick("2013_06.nc", varname = "str")
dta_13_07 <- brick("2013_07.nc", varname = "str")
dta_13_08 <- brick("2013_08.nc", varname = "str")
dta_13_09 <- brick("2013_09.nc", varname = "str")
dta_13_10 <- brick("2013_10.nc", varname = "str")
dta_13_11 <- brick("2013_11.nc", varname = "str")
dta_13_12 <- brick("2013_12.nc", varname = "str")

#2014
dta_14_01 <- brick("2014_01.nc", varname = "str")
dta_14_02 <- brick("2014_02.nc", varname = "str")
dta_14_03 <- brick("2014_03.nc", varname = "str")
dta_14_04 <- brick("2014_04.nc", varname = "str")
dta_14_05 <- brick("2014_05.nc", varname = "str")
dta_14_06 <- brick("2014_06.nc", varname = "str")
dta_14_07 <- brick("2014_07.nc", varname = "str")
dta_14_08 <- brick("2014_08.nc", varname = "str")
dta_14_09 <- brick("2014_09.nc", varname = "str")
dta_14_10 <- brick("2014_10.nc", varname = "str")
dta_14_11 <- brick("2014_11.nc", varname = "str")
dta_14_12 <- brick("2014_12.nc", varname = "str")

#2015
dta_15_01 <- brick("2015_01.nc", varname = "str")
dta_15_02 <- brick("2015_02.nc", varname = "str")
dta_15_03 <- brick("2015_03.nc", varname = "str")
dta_15_04 <- brick("2015_04.nc", varname = "str")
dta_15_05 <- brick("2015_05.nc", varname = "str")
dta_15_06 <- brick("2015_06.nc", varname = "str")
dta_15_07 <- brick("2015_07.nc", varname = "str")
dta_15_08 <- brick("2015_08.nc", varname = "str")
dta_15_09 <- brick("2015_09.nc", varname = "str")
dta_15_10 <- brick("2015_10.nc", varname = "str")
dta_15_11 <- brick("2015_11.nc", varname = "str")
dta_15_12 <- brick("2015_12.nc", varname = "str")

#2016
dta_16_01 <- brick("2016_01.nc", varname = "str")
dta_16_02 <- brick("2016_02.nc", varname = "str")
dta_16_03 <- brick("2016_03.nc", varname = "str")
dta_16_04 <- brick("2016_04.nc", varname = "str")
dta_16_05 <- brick("2016_05.nc", varname = "str")
dta_16_06 <- brick("2016_06.nc", varname = "str")
dta_16_07 <- brick("2016_07.nc", varname = "str")
dta_16_08 <- brick("2016_08.nc", varname = "str")
dta_16_09 <- brick("2016_09.nc", varname = "str")
dta_16_10 <- brick("2016_10.nc", varname = "str")
dta_16_11 <- brick("2016_11.nc", varname = "str")
dta_16_12 <- brick("2016_12.nc", varname = "str")

#2017
dta_17_01 <- brick("2017_01.nc", varname = "str")
dta_17_02 <- brick("2017_02.nc", varname = "str")
dta_17_03 <- brick("2017_03.nc", varname = "str")
dta_17_04 <- brick("2017_04.nc", varname = "str")
dta_17_05 <- brick("2017_05.nc", varname = "str")
dta_17_06 <- brick("2017_06.nc", varname = "str")
dta_17_07 <- brick("2017_07.nc", varname = "str")
dta_17_08 <- brick("2017_08.nc", varname = "str")
dta_17_09 <- brick("2017_09.nc", varname = "str")
dta_17_10 <- brick("2017_10.nc", varname = "str")
dta_17_11 <- brick("2017_11.nc", varname = "str")
dta_17_12 <- brick("2017_12.nc", varname = "str")

#2018
dta_18_01 <- brick("2018_01.nc", varname = "str")
dta_18_02 <- brick("2018_02.nc", varname = "str")
dta_18_03 <- brick("2018_03.nc", varname = "str")
dta_18_04 <- brick("2018_04.nc", varname = "str")
dta_18_05 <- brick("2018_05.nc", varname = "str")
dta_18_06 <- brick("2018_06.nc", varname = "str")
dta_18_07 <- brick("2018_07.nc", varname = "str")
dta_18_08 <- brick("2018_08.nc", varname = "str")
dta_18_09 <- brick("2018_09.nc", varname = "str")
dta_18_10 <- brick("2018_10.nc", varname = "str")
dta_18_11 <- brick("2018_11.nc", varname = "str")
dta_18_12 <- brick("2018_12.nc", varname = "str")

#2019
dta_19_01 <- brick("2019_01.nc", varname = "str")
dta_19_02 <- brick("2019_02.nc", varname = "str")
dta_19_03 <- brick("2019_03.nc", varname = "str")
dta_19_04 <- brick("2019_04.nc", varname = "str")
dta_19_05 <- brick("2019_05.nc", varname = "str")
dta_19_06 <- brick("2019_06.nc", varname = "str")
dta_19_07 <- brick("2019_07.nc", varname = "str")
dta_19_08 <- brick("2019_08.nc", varname = "str")
dta_19_09 <- brick("2019_09.nc", varname = "str")
dta_19_10 <- brick("2019_10.nc", varname = "str")
dta_19_11 <- brick("2019_11.nc", varname = "str")
dta_19_12 <- brick("2019_12.nc", varname = "str")

#2020
dta_20_01 <- brick("2020_01.nc", varname = "str")
dta_20_02 <- brick("2020_02.nc", varname = "str")
dta_20_03 <- brick("2020_03.nc", varname = "str")
dta_20_04 <- brick("2020_04.nc", varname = "str")
dta_20_05 <- brick("2020_05.nc", varname = "str")
dta_20_06 <- brick("2020_06.nc", varname = "str")
dta_20_07 <- brick("2020_07.nc", varname = "str")
dta_20_08 <- brick("2020_08.nc", varname = "str")
dta_20_09 <- brick("2020_09.nc", varname = "str")
dta_20_10 <- brick("2020_10.nc", varname = "str")
dta_20_11 <- brick("2020_11.nc", varname = "str")
dta_20_12 <- brick("2020_12.nc", varname = "str")

#2021
dta_21_01 <- brick("2021_01.nc", varname = "str")
dta_21_02 <- brick("2021_02.nc", varname = "str")
dta_21_03 <- brick("2021_03.nc", varname = "str")
dta_21_04 <- brick("2021_04.nc", varname = "str")
dta_21_05 <- brick("2021_05.nc", varname = "str")
dta_21_06 <- brick("2021_06.nc", varname = "str")
dta_21_07 <- brick("2021_07.nc", varname = "str")
dta_21_08 <- brick("2021_08.nc", varname = "str")
dta_21_09 <- brick("2021_09.nc", varname = "str")
dta_21_10 <- brick("2021_10.nc", varname = "str")
dta_21_11 <- brick("2021_11.nc", varname = "str")
dta_21_12 <- brick("2021_12.nc", varname = "str")

#2022
dta_22_01 <- brick("2022_01.nc", varname = "str")
dta_22_02 <- brick("2022_02.nc", varname = "str")
dta_22_03 <- brick("2022_03.nc", varname = "str")
dta_22_04 <- brick("2022_04.nc", varname = "str")
dta_22_05 <- brick("2022_05.nc", varname = "str")
dta_22_06 <- brick("2022_06.nc", varname = "str")
dta_22_07 <- brick("2022_07.nc", varname = "str")
dta_22_08 <- brick("2022_08.nc", varname = "str")
dta_22_09 <- brick("2022_09.nc", varname = "str")
dta_22_10 <- brick("2022_10.nc", varname = "str")
dta_22_11 <- brick("2022_11.nc", varname = "str")
dta_22_12 <- brick("2022_12.nc", varname = "str")

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
str <- mosaic(sub_00, sub_01, sub_02, sub_03, sub_04, sub_05,
               sub_06, sub_07, sub_08, sub_09, sub_10, sub_11,
               sub_12, sub_13, sub_14, sub_15, sub_16, sub_17,
               sub_18, sub_19, sub_20, sub_21, sub_22, sub_23, fun = mean)
names(str) <- names(sub_00)



#### Surface pressure ####
#2004
dta_04_10 <- brick("2004_10.nc", varname = "sp")
dta_04_11 <- brick("2004_11.nc", varname = "sp")
dta_04_12 <- brick("2004_12.nc", varname = "sp")

#2005
dta_05_01 <- brick("2005_01.nc", varname = "sp")
dta_05_02 <- brick("2005_02.nc", varname = "sp")
dta_05_03 <- brick("2005_03.nc", varname = "sp")
dta_05_04 <- brick("2005_04.nc", varname = "sp")
dta_05_05 <- brick("2005_05.nc", varname = "sp")
dta_05_06 <- brick("2005_06.nc", varname = "sp")
dta_05_07 <- brick("2005_07.nc", varname = "sp")
dta_05_08 <- brick("2005_08.nc", varname = "sp")
dta_05_09 <- brick("2005_09.nc", varname = "sp")
dta_05_10 <- brick("2005_10.nc", varname = "sp")
dta_05_11 <- brick("2005_11.nc", varname = "sp")
dta_05_12 <- brick("2005_12.nc", varname = "sp")

#2006
dta_06_01 <- brick("2006_01.nc", varname = "sp")
dta_06_02 <- brick("2006_02.nc", varname = "sp")
dta_06_03 <- brick("2006_03.nc", varname = "sp")
dta_06_04 <- brick("2006_04.nc", varname = "sp")
dta_06_05 <- brick("2006_05.nc", varname = "sp")
dta_06_06 <- brick("2006_06.nc", varname = "sp")
dta_06_07 <- brick("2006_07.nc", varname = "sp")
dta_06_08 <- brick("2006_08.nc", varname = "sp")
dta_06_09 <- brick("2006_09.nc", varname = "sp")
dta_06_10 <- brick("2006_10.nc", varname = "sp")
dta_06_11 <- brick("2006_11.nc", varname = "sp")
dta_06_12 <- brick("2006_12.nc", varname = "sp")

#2007
dta_07_01 <- brick("2007_01.nc", varname = "sp")
dta_07_02 <- brick("2007_02.nc", varname = "sp")
dta_07_03 <- brick("2007_03.nc", varname = "sp")
dta_07_04 <- brick("2007_04.nc", varname = "sp")
dta_07_05 <- brick("2007_05.nc", varname = "sp")
dta_07_06 <- brick("2007_06.nc", varname = "sp")
dta_07_07 <- brick("2007_07.nc", varname = "sp")
dta_07_08 <- brick("2007_08.nc", varname = "sp")
dta_07_09 <- brick("2007_09.nc", varname = "sp")
dta_07_10 <- brick("2007_10.nc", varname = "sp")
dta_07_11 <- brick("2007_11.nc", varname = "sp")
dta_07_12 <- brick("2007_12.nc", varname = "sp")

#2008
dta_08_01 <- brick("2008_01.nc", varname = "sp")
dta_08_02 <- brick("2008_02.nc", varname = "sp")
dta_08_03 <- brick("2008_03.nc", varname = "sp")
dta_08_04 <- brick("2008_04.nc", varname = "sp")
dta_08_05 <- brick("2008_05.nc", varname = "sp")
dta_08_06 <- brick("2008_06.nc", varname = "sp")
dta_08_07 <- brick("2008_07.nc", varname = "sp")
dta_08_08 <- brick("2008_08.nc", varname = "sp")
dta_08_09 <- brick("2008_09.nc", varname = "sp")
dta_08_10 <- brick("2008_10.nc", varname = "sp")
dta_08_11 <- brick("2008_11.nc", varname = "sp")
dta_08_12 <- brick("2008_12.nc", varname = "sp")

#2009
dta_09_01 <- brick("2009_01.nc", varname = "sp")
dta_09_02 <- brick("2009_02.nc", varname = "sp")
dta_09_03 <- brick("2009_03.nc", varname = "sp")
dta_09_04 <- brick("2009_04.nc", varname = "sp")
dta_09_05 <- brick("2009_05.nc", varname = "sp")
dta_09_06 <- brick("2009_06.nc", varname = "sp")
dta_09_07 <- brick("2009_07.nc", varname = "sp")
dta_09_08 <- brick("2009_08.nc", varname = "sp")
dta_09_09 <- brick("2009_09.nc", varname = "sp")
dta_09_10 <- brick("2009_10.nc", varname = "sp")
dta_09_11 <- brick("2009_11.nc", varname = "sp")
dta_09_12 <- brick("2009_12.nc", varname = "sp")

#2010
dta_10_01 <- brick("2010_01.nc", varname = "sp")
dta_10_02 <- brick("2010_02.nc", varname = "sp")
dta_10_03 <- brick("2010_03.nc", varname = "sp")
dta_10_04 <- brick("2010_04.nc", varname = "sp")
dta_10_05 <- brick("2010_05.nc", varname = "sp")
dta_10_06 <- brick("2010_06.nc", varname = "sp")
dta_10_07 <- brick("2010_07.nc", varname = "sp")
dta_10_08 <- brick("2010_08.nc", varname = "sp")
dta_10_09 <- brick("2010_09.nc", varname = "sp")
dta_10_10 <- brick("2010_10.nc", varname = "sp")
dta_10_11 <- brick("2010_11.nc", varname = "sp")
dta_10_12 <- brick("2010_12.nc", varname = "sp")

#2011
dta_11_01 <- brick("2011_01.nc", varname = "sp")
dta_11_02 <- brick("2011_02.nc", varname = "sp")
dta_11_03 <- brick("2011_03.nc", varname = "sp")
dta_11_04 <- brick("2011_04.nc", varname = "sp")
dta_11_05 <- brick("2011_05.nc", varname = "sp")
dta_11_06 <- brick("2011_06.nc", varname = "sp")
dta_11_07 <- brick("2011_07.nc", varname = "sp")
dta_11_08 <- brick("2011_08.nc", varname = "sp")
dta_11_09 <- brick("2011_09.nc", varname = "sp")
dta_11_10 <- brick("2011_10.nc", varname = "sp")
dta_11_11 <- brick("2011_11.nc", varname = "sp")
dta_11_12 <- brick("2011_12.nc", varname = "sp")

#2012
dta_12_01 <- brick("2012_01.nc", varname = "sp")
dta_12_02 <- brick("2012_02.nc", varname = "sp")
dta_12_03 <- brick("2012_03.nc", varname = "sp")
dta_12_04 <- brick("2012_04.nc", varname = "sp")
dta_12_05 <- brick("2012_05.nc", varname = "sp")
dta_12_06 <- brick("2012_06.nc", varname = "sp")
dta_12_07 <- brick("2012_07.nc", varname = "sp")
dta_12_08 <- brick("2012_08.nc", varname = "sp")
dta_12_09 <- brick("2012_09.nc", varname = "sp")
dta_12_10 <- brick("2012_10.nc", varname = "sp")
dta_12_11 <- brick("2012_11.nc", varname = "sp")
dta_12_12 <- brick("2012_12.nc", varname = "sp")

#2013
dta_13_01 <- brick("2013_01.nc", varname = "sp")
dta_13_02 <- brick("2013_02.nc", varname = "sp")
dta_13_03 <- brick("2013_03.nc", varname = "sp")
dta_13_04 <- brick("2013_04.nc", varname = "sp")
dta_13_05 <- brick("2013_05.nc", varname = "sp")
dta_13_06 <- brick("2013_06.nc", varname = "sp")
dta_13_07 <- brick("2013_07.nc", varname = "sp")
dta_13_08 <- brick("2013_08.nc", varname = "sp")
dta_13_09 <- brick("2013_09.nc", varname = "sp")
dta_13_10 <- brick("2013_10.nc", varname = "sp")
dta_13_11 <- brick("2013_11.nc", varname = "sp")
dta_13_12 <- brick("2013_12.nc", varname = "sp")

#2014
dta_14_01 <- brick("2014_01.nc", varname = "sp")
dta_14_02 <- brick("2014_02.nc", varname = "sp")
dta_14_03 <- brick("2014_03.nc", varname = "sp")
dta_14_04 <- brick("2014_04.nc", varname = "sp")
dta_14_05 <- brick("2014_05.nc", varname = "sp")
dta_14_06 <- brick("2014_06.nc", varname = "sp")
dta_14_07 <- brick("2014_07.nc", varname = "sp")
dta_14_08 <- brick("2014_08.nc", varname = "sp")
dta_14_09 <- brick("2014_09.nc", varname = "sp")
dta_14_10 <- brick("2014_10.nc", varname = "sp")
dta_14_11 <- brick("2014_11.nc", varname = "sp")
dta_14_12 <- brick("2014_12.nc", varname = "sp")

#2015
dta_15_01 <- brick("2015_01.nc", varname = "sp")
dta_15_02 <- brick("2015_02.nc", varname = "sp")
dta_15_03 <- brick("2015_03.nc", varname = "sp")
dta_15_04 <- brick("2015_04.nc", varname = "sp")
dta_15_05 <- brick("2015_05.nc", varname = "sp")
dta_15_06 <- brick("2015_06.nc", varname = "sp")
dta_15_07 <- brick("2015_07.nc", varname = "sp")
dta_15_08 <- brick("2015_08.nc", varname = "sp")
dta_15_09 <- brick("2015_09.nc", varname = "sp")
dta_15_10 <- brick("2015_10.nc", varname = "sp")
dta_15_11 <- brick("2015_11.nc", varname = "sp")
dta_15_12 <- brick("2015_12.nc", varname = "sp")

#2016
dta_16_01 <- brick("2016_01.nc", varname = "sp")
dta_16_02 <- brick("2016_02.nc", varname = "sp")
dta_16_03 <- brick("2016_03.nc", varname = "sp")
dta_16_04 <- brick("2016_04.nc", varname = "sp")
dta_16_05 <- brick("2016_05.nc", varname = "sp")
dta_16_06 <- brick("2016_06.nc", varname = "sp")
dta_16_07 <- brick("2016_07.nc", varname = "sp")
dta_16_08 <- brick("2016_08.nc", varname = "sp")
dta_16_09 <- brick("2016_09.nc", varname = "sp")
dta_16_10 <- brick("2016_10.nc", varname = "sp")
dta_16_11 <- brick("2016_11.nc", varname = "sp")
dta_16_12 <- brick("2016_12.nc", varname = "sp")

#2017
dta_17_01 <- brick("2017_01.nc", varname = "sp")
dta_17_02 <- brick("2017_02.nc", varname = "sp")
dta_17_03 <- brick("2017_03.nc", varname = "sp")
dta_17_04 <- brick("2017_04.nc", varname = "sp")
dta_17_05 <- brick("2017_05.nc", varname = "sp")
dta_17_06 <- brick("2017_06.nc", varname = "sp")
dta_17_07 <- brick("2017_07.nc", varname = "sp")
dta_17_08 <- brick("2017_08.nc", varname = "sp")
dta_17_09 <- brick("2017_09.nc", varname = "sp")
dta_17_10 <- brick("2017_10.nc", varname = "sp")
dta_17_11 <- brick("2017_11.nc", varname = "sp")
dta_17_12 <- brick("2017_12.nc", varname = "sp")

#2018
dta_18_01 <- brick("2018_01.nc", varname = "sp")
dta_18_02 <- brick("2018_02.nc", varname = "sp")
dta_18_03 <- brick("2018_03.nc", varname = "sp")
dta_18_04 <- brick("2018_04.nc", varname = "sp")
dta_18_05 <- brick("2018_05.nc", varname = "sp")
dta_18_06 <- brick("2018_06.nc", varname = "sp")
dta_18_07 <- brick("2018_07.nc", varname = "sp")
dta_18_08 <- brick("2018_08.nc", varname = "sp")
dta_18_09 <- brick("2018_09.nc", varname = "sp")
dta_18_10 <- brick("2018_10.nc", varname = "sp")
dta_18_11 <- brick("2018_11.nc", varname = "sp")
dta_18_12 <- brick("2018_12.nc", varname = "sp")

#2019
dta_19_01 <- brick("2019_01.nc", varname = "sp")
dta_19_02 <- brick("2019_02.nc", varname = "sp")
dta_19_03 <- brick("2019_03.nc", varname = "sp")
dta_19_04 <- brick("2019_04.nc", varname = "sp")
dta_19_05 <- brick("2019_05.nc", varname = "sp")
dta_19_06 <- brick("2019_06.nc", varname = "sp")
dta_19_07 <- brick("2019_07.nc", varname = "sp")
dta_19_08 <- brick("2019_08.nc", varname = "sp")
dta_19_09 <- brick("2019_09.nc", varname = "sp")
dta_19_10 <- brick("2019_10.nc", varname = "sp")
dta_19_11 <- brick("2019_11.nc", varname = "sp")
dta_19_12 <- brick("2019_12.nc", varname = "sp")

#2020
dta_20_01 <- brick("2020_01.nc", varname = "sp")
dta_20_02 <- brick("2020_02.nc", varname = "sp")
dta_20_03 <- brick("2020_03.nc", varname = "sp")
dta_20_04 <- brick("2020_04.nc", varname = "sp")
dta_20_05 <- brick("2020_05.nc", varname = "sp")
dta_20_06 <- brick("2020_06.nc", varname = "sp")
dta_20_07 <- brick("2020_07.nc", varname = "sp")
dta_20_08 <- brick("2020_08.nc", varname = "sp")
dta_20_09 <- brick("2020_09.nc", varname = "sp")
dta_20_10 <- brick("2020_10.nc", varname = "sp")
dta_20_11 <- brick("2020_11.nc", varname = "sp")
dta_20_12 <- brick("2020_12.nc", varname = "sp")

#2021
dta_21_01 <- brick("2021_01.nc", varname = "sp")
dta_21_02 <- brick("2021_02.nc", varname = "sp")
dta_21_03 <- brick("2021_03.nc", varname = "sp")
dta_21_04 <- brick("2021_04.nc", varname = "sp")
dta_21_05 <- brick("2021_05.nc", varname = "sp")
dta_21_06 <- brick("2021_06.nc", varname = "sp")
dta_21_07 <- brick("2021_07.nc", varname = "sp")
dta_21_08 <- brick("2021_08.nc", varname = "sp")
dta_21_09 <- brick("2021_09.nc", varname = "sp")
dta_21_10 <- brick("2021_10.nc", varname = "sp")
dta_21_11 <- brick("2021_11.nc", varname = "sp")
dta_21_12 <- brick("2021_12.nc", varname = "sp")

#2022
dta_22_01 <- brick("2022_01.nc", varname = "sp")
dta_22_02 <- brick("2022_02.nc", varname = "sp")
dta_22_03 <- brick("2022_03.nc", varname = "sp")
dta_22_04 <- brick("2022_04.nc", varname = "sp")
dta_22_05 <- brick("2022_05.nc", varname = "sp")
dta_22_06 <- brick("2022_06.nc", varname = "sp")
dta_22_07 <- brick("2022_07.nc", varname = "sp")
dta_22_08 <- brick("2022_08.nc", varname = "sp")
dta_22_09 <- brick("2022_09.nc", varname = "sp")
dta_22_10 <- brick("2022_10.nc", varname = "sp")
dta_22_11 <- brick("2022_11.nc", varname = "sp")
dta_22_12 <- brick("2022_12.nc", varname = "sp")

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
sp <- mosaic(sub_00, sub_01, sub_02, sub_03, sub_04, sub_05,
              sub_06, sub_07, sub_08, sub_09, sub_10, sub_11,
              sub_12, sub_13, sub_14, sub_15, sub_16, sub_17,
              sub_18, sub_19, sub_20, sub_21, sub_22, sub_23, fun = mean)
names(sp) <- names(sub_00)



#### Suface sensible heat flux ####
#2004
dta_04_10 <- brick("2004_10.nc", varname = "sshf")
dta_04_11 <- brick("2004_11.nc", varname = "sshf")
dta_04_12 <- brick("2004_12.nc", varname = "sshf")

#2005
dta_05_01 <- brick("2005_01.nc", varname = "sshf")
dta_05_02 <- brick("2005_02.nc", varname = "sshf")
dta_05_03 <- brick("2005_03.nc", varname = "sshf")
dta_05_04 <- brick("2005_04.nc", varname = "sshf")
dta_05_05 <- brick("2005_05.nc", varname = "sshf")
dta_05_06 <- brick("2005_06.nc", varname = "sshf")
dta_05_07 <- brick("2005_07.nc", varname = "sshf")
dta_05_08 <- brick("2005_08.nc", varname = "sshf")
dta_05_09 <- brick("2005_09.nc", varname = "sshf")
dta_05_10 <- brick("2005_10.nc", varname = "sshf")
dta_05_11 <- brick("2005_11.nc", varname = "sshf")
dta_05_12 <- brick("2005_12.nc", varname = "sshf")

#2006
dta_06_01 <- brick("2006_01.nc", varname = "sshf")
dta_06_02 <- brick("2006_02.nc", varname = "sshf")
dta_06_03 <- brick("2006_03.nc", varname = "sshf")
dta_06_04 <- brick("2006_04.nc", varname = "sshf")
dta_06_05 <- brick("2006_05.nc", varname = "sshf")
dta_06_06 <- brick("2006_06.nc", varname = "sshf")
dta_06_07 <- brick("2006_07.nc", varname = "sshf")
dta_06_08 <- brick("2006_08.nc", varname = "sshf")
dta_06_09 <- brick("2006_09.nc", varname = "sshf")
dta_06_10 <- brick("2006_10.nc", varname = "sshf")
dta_06_11 <- brick("2006_11.nc", varname = "sshf")
dta_06_12 <- brick("2006_12.nc", varname = "sshf")

#2007
dta_07_01 <- brick("2007_01.nc", varname = "sshf")
dta_07_02 <- brick("2007_02.nc", varname = "sshf")
dta_07_03 <- brick("2007_03.nc", varname = "sshf")
dta_07_04 <- brick("2007_04.nc", varname = "sshf")
dta_07_05 <- brick("2007_05.nc", varname = "sshf")
dta_07_06 <- brick("2007_06.nc", varname = "sshf")
dta_07_07 <- brick("2007_07.nc", varname = "sshf")
dta_07_08 <- brick("2007_08.nc", varname = "sshf")
dta_07_09 <- brick("2007_09.nc", varname = "sshf")
dta_07_10 <- brick("2007_10.nc", varname = "sshf")
dta_07_11 <- brick("2007_11.nc", varname = "sshf")
dta_07_12 <- brick("2007_12.nc", varname = "sshf")

#2008
dta_08_01 <- brick("2008_01.nc", varname = "sshf")
dta_08_02 <- brick("2008_02.nc", varname = "sshf")
dta_08_03 <- brick("2008_03.nc", varname = "sshf")
dta_08_04 <- brick("2008_04.nc", varname = "sshf")
dta_08_05 <- brick("2008_05.nc", varname = "sshf")
dta_08_06 <- brick("2008_06.nc", varname = "sshf")
dta_08_07 <- brick("2008_07.nc", varname = "sshf")
dta_08_08 <- brick("2008_08.nc", varname = "sshf")
dta_08_09 <- brick("2008_09.nc", varname = "sshf")
dta_08_10 <- brick("2008_10.nc", varname = "sshf")
dta_08_11 <- brick("2008_11.nc", varname = "sshf")
dta_08_12 <- brick("2008_12.nc", varname = "sshf")

#2009
dta_09_01 <- brick("2009_01.nc", varname = "sshf")
dta_09_02 <- brick("2009_02.nc", varname = "sshf")
dta_09_03 <- brick("2009_03.nc", varname = "sshf")
dta_09_04 <- brick("2009_04.nc", varname = "sshf")
dta_09_05 <- brick("2009_05.nc", varname = "sshf")
dta_09_06 <- brick("2009_06.nc", varname = "sshf")
dta_09_07 <- brick("2009_07.nc", varname = "sshf")
dta_09_08 <- brick("2009_08.nc", varname = "sshf")
dta_09_09 <- brick("2009_09.nc", varname = "sshf")
dta_09_10 <- brick("2009_10.nc", varname = "sshf")
dta_09_11 <- brick("2009_11.nc", varname = "sshf")
dta_09_12 <- brick("2009_12.nc", varname = "sshf")

#2010
dta_10_01 <- brick("2010_01.nc", varname = "sshf")
dta_10_02 <- brick("2010_02.nc", varname = "sshf")
dta_10_03 <- brick("2010_03.nc", varname = "sshf")
dta_10_04 <- brick("2010_04.nc", varname = "sshf")
dta_10_05 <- brick("2010_05.nc", varname = "sshf")
dta_10_06 <- brick("2010_06.nc", varname = "sshf")
dta_10_07 <- brick("2010_07.nc", varname = "sshf")
dta_10_08 <- brick("2010_08.nc", varname = "sshf")
dta_10_09 <- brick("2010_09.nc", varname = "sshf")
dta_10_10 <- brick("2010_10.nc", varname = "sshf")
dta_10_11 <- brick("2010_11.nc", varname = "sshf")
dta_10_12 <- brick("2010_12.nc", varname = "sshf")

#2011
dta_11_01 <- brick("2011_01.nc", varname = "sshf")
dta_11_02 <- brick("2011_02.nc", varname = "sshf")
dta_11_03 <- brick("2011_03.nc", varname = "sshf")
dta_11_04 <- brick("2011_04.nc", varname = "sshf")
dta_11_05 <- brick("2011_05.nc", varname = "sshf")
dta_11_06 <- brick("2011_06.nc", varname = "sshf")
dta_11_07 <- brick("2011_07.nc", varname = "sshf")
dta_11_08 <- brick("2011_08.nc", varname = "sshf")
dta_11_09 <- brick("2011_09.nc", varname = "sshf")
dta_11_10 <- brick("2011_10.nc", varname = "sshf")
dta_11_11 <- brick("2011_11.nc", varname = "sshf")
dta_11_12 <- brick("2011_12.nc", varname = "sshf")

#2012
dta_12_01 <- brick("2012_01.nc", varname = "sshf")
dta_12_02 <- brick("2012_02.nc", varname = "sshf")
dta_12_03 <- brick("2012_03.nc", varname = "sshf")
dta_12_04 <- brick("2012_04.nc", varname = "sshf")
dta_12_05 <- brick("2012_05.nc", varname = "sshf")
dta_12_06 <- brick("2012_06.nc", varname = "sshf")
dta_12_07 <- brick("2012_07.nc", varname = "sshf")
dta_12_08 <- brick("2012_08.nc", varname = "sshf")
dta_12_09 <- brick("2012_09.nc", varname = "sshf")
dta_12_10 <- brick("2012_10.nc", varname = "sshf")
dta_12_11 <- brick("2012_11.nc", varname = "sshf")
dta_12_12 <- brick("2012_12.nc", varname = "sshf")

#2013
dta_13_01 <- brick("2013_01.nc", varname = "sshf")
dta_13_02 <- brick("2013_02.nc", varname = "sshf")
dta_13_03 <- brick("2013_03.nc", varname = "sshf")
dta_13_04 <- brick("2013_04.nc", varname = "sshf")
dta_13_05 <- brick("2013_05.nc", varname = "sshf")
dta_13_06 <- brick("2013_06.nc", varname = "sshf")
dta_13_07 <- brick("2013_07.nc", varname = "sshf")
dta_13_08 <- brick("2013_08.nc", varname = "sshf")
dta_13_09 <- brick("2013_09.nc", varname = "sshf")
dta_13_10 <- brick("2013_10.nc", varname = "sshf")
dta_13_11 <- brick("2013_11.nc", varname = "sshf")
dta_13_12 <- brick("2013_12.nc", varname = "sshf")

#2014
dta_14_01 <- brick("2014_01.nc", varname = "sshf")
dta_14_02 <- brick("2014_02.nc", varname = "sshf")
dta_14_03 <- brick("2014_03.nc", varname = "sshf")
dta_14_04 <- brick("2014_04.nc", varname = "sshf")
dta_14_05 <- brick("2014_05.nc", varname = "sshf")
dta_14_06 <- brick("2014_06.nc", varname = "sshf")
dta_14_07 <- brick("2014_07.nc", varname = "sshf")
dta_14_08 <- brick("2014_08.nc", varname = "sshf")
dta_14_09 <- brick("2014_09.nc", varname = "sshf")
dta_14_10 <- brick("2014_10.nc", varname = "sshf")
dta_14_11 <- brick("2014_11.nc", varname = "sshf")
dta_14_12 <- brick("2014_12.nc", varname = "sshf")

#2015
dta_15_01 <- brick("2015_01.nc", varname = "sshf")
dta_15_02 <- brick("2015_02.nc", varname = "sshf")
dta_15_03 <- brick("2015_03.nc", varname = "sshf")
dta_15_04 <- brick("2015_04.nc", varname = "sshf")
dta_15_05 <- brick("2015_05.nc", varname = "sshf")
dta_15_06 <- brick("2015_06.nc", varname = "sshf")
dta_15_07 <- brick("2015_07.nc", varname = "sshf")
dta_15_08 <- brick("2015_08.nc", varname = "sshf")
dta_15_09 <- brick("2015_09.nc", varname = "sshf")
dta_15_10 <- brick("2015_10.nc", varname = "sshf")
dta_15_11 <- brick("2015_11.nc", varname = "sshf")
dta_15_12 <- brick("2015_12.nc", varname = "sshf")

#2016
dta_16_01 <- brick("2016_01.nc", varname = "sshf")
dta_16_02 <- brick("2016_02.nc", varname = "sshf")
dta_16_03 <- brick("2016_03.nc", varname = "sshf")
dta_16_04 <- brick("2016_04.nc", varname = "sshf")
dta_16_05 <- brick("2016_05.nc", varname = "sshf")
dta_16_06 <- brick("2016_06.nc", varname = "sshf")
dta_16_07 <- brick("2016_07.nc", varname = "sshf")
dta_16_08 <- brick("2016_08.nc", varname = "sshf")
dta_16_09 <- brick("2016_09.nc", varname = "sshf")
dta_16_10 <- brick("2016_10.nc", varname = "sshf")
dta_16_11 <- brick("2016_11.nc", varname = "sshf")
dta_16_12 <- brick("2016_12.nc", varname = "sshf")

#2017
dta_17_01 <- brick("2017_01.nc", varname = "sshf")
dta_17_02 <- brick("2017_02.nc", varname = "sshf")
dta_17_03 <- brick("2017_03.nc", varname = "sshf")
dta_17_04 <- brick("2017_04.nc", varname = "sshf")
dta_17_05 <- brick("2017_05.nc", varname = "sshf")
dta_17_06 <- brick("2017_06.nc", varname = "sshf")
dta_17_07 <- brick("2017_07.nc", varname = "sshf")
dta_17_08 <- brick("2017_08.nc", varname = "sshf")
dta_17_09 <- brick("2017_09.nc", varname = "sshf")
dta_17_10 <- brick("2017_10.nc", varname = "sshf")
dta_17_11 <- brick("2017_11.nc", varname = "sshf")
dta_17_12 <- brick("2017_12.nc", varname = "sshf")

#2018
dta_18_01 <- brick("2018_01.nc", varname = "sshf")
dta_18_02 <- brick("2018_02.nc", varname = "sshf")
dta_18_03 <- brick("2018_03.nc", varname = "sshf")
dta_18_04 <- brick("2018_04.nc", varname = "sshf")
dta_18_05 <- brick("2018_05.nc", varname = "sshf")
dta_18_06 <- brick("2018_06.nc", varname = "sshf")
dta_18_07 <- brick("2018_07.nc", varname = "sshf")
dta_18_08 <- brick("2018_08.nc", varname = "sshf")
dta_18_09 <- brick("2018_09.nc", varname = "sshf")
dta_18_10 <- brick("2018_10.nc", varname = "sshf")
dta_18_11 <- brick("2018_11.nc", varname = "sshf")
dta_18_12 <- brick("2018_12.nc", varname = "sshf")

#2019
dta_19_01 <- brick("2019_01.nc", varname = "sshf")
dta_19_02 <- brick("2019_02.nc", varname = "sshf")
dta_19_03 <- brick("2019_03.nc", varname = "sshf")
dta_19_04 <- brick("2019_04.nc", varname = "sshf")
dta_19_05 <- brick("2019_05.nc", varname = "sshf")
dta_19_06 <- brick("2019_06.nc", varname = "sshf")
dta_19_07 <- brick("2019_07.nc", varname = "sshf")
dta_19_08 <- brick("2019_08.nc", varname = "sshf")
dta_19_09 <- brick("2019_09.nc", varname = "sshf")
dta_19_10 <- brick("2019_10.nc", varname = "sshf")
dta_19_11 <- brick("2019_11.nc", varname = "sshf")
dta_19_12 <- brick("2019_12.nc", varname = "sshf")

#2020
dta_20_01 <- brick("2020_01.nc", varname = "sshf")
dta_20_02 <- brick("2020_02.nc", varname = "sshf")
dta_20_03 <- brick("2020_03.nc", varname = "sshf")
dta_20_04 <- brick("2020_04.nc", varname = "sshf")
dta_20_05 <- brick("2020_05.nc", varname = "sshf")
dta_20_06 <- brick("2020_06.nc", varname = "sshf")
dta_20_07 <- brick("2020_07.nc", varname = "sshf")
dta_20_08 <- brick("2020_08.nc", varname = "sshf")
dta_20_09 <- brick("2020_09.nc", varname = "sshf")
dta_20_10 <- brick("2020_10.nc", varname = "sshf")
dta_20_11 <- brick("2020_11.nc", varname = "sshf")
dta_20_12 <- brick("2020_12.nc", varname = "sshf")

#2021
dta_21_01 <- brick("2021_01.nc", varname = "sshf")
dta_21_02 <- brick("2021_02.nc", varname = "sshf")
dta_21_03 <- brick("2021_03.nc", varname = "sshf")
dta_21_04 <- brick("2021_04.nc", varname = "sshf")
dta_21_05 <- brick("2021_05.nc", varname = "sshf")
dta_21_06 <- brick("2021_06.nc", varname = "sshf")
dta_21_07 <- brick("2021_07.nc", varname = "sshf")
dta_21_08 <- brick("2021_08.nc", varname = "sshf")
dta_21_09 <- brick("2021_09.nc", varname = "sshf")
dta_21_10 <- brick("2021_10.nc", varname = "sshf")
dta_21_11 <- brick("2021_11.nc", varname = "sshf")
dta_21_12 <- brick("2021_12.nc", varname = "sshf")

#2022
dta_22_01 <- brick("2022_01.nc", varname = "sshf")
dta_22_02 <- brick("2022_02.nc", varname = "sshf")
dta_22_03 <- brick("2022_03.nc", varname = "sshf")
dta_22_04 <- brick("2022_04.nc", varname = "sshf")
dta_22_05 <- brick("2022_05.nc", varname = "sshf")
dta_22_06 <- brick("2022_06.nc", varname = "sshf")
dta_22_07 <- brick("2022_07.nc", varname = "sshf")
dta_22_08 <- brick("2022_08.nc", varname = "sshf")
dta_22_09 <- brick("2022_09.nc", varname = "sshf")
dta_22_10 <- brick("2022_10.nc", varname = "sshf")
dta_22_11 <- brick("2022_11.nc", varname = "sshf")
dta_22_12 <- brick("2022_12.nc", varname = "sshf")

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
sshf <- mosaic(sub_00, sub_01, sub_02, sub_03, sub_04, sub_05,
             sub_06, sub_07, sub_08, sub_09, sub_10, sub_11,
             sub_12, sub_13, sub_14, sub_15, sub_16, sub_17,
             sub_18, sub_19, sub_20, sub_21, sub_22, sub_23, fun = mean)
names(sshf) <- names(sub_00)



#### Surface thermal radiation downwards ####
#2004
dta_04_10 <- brick("2004_10.nc", varname = "strd")
dta_04_11 <- brick("2004_11.nc", varname = "strd")
dta_04_12 <- brick("2004_12.nc", varname = "strd")

#2005
dta_05_01 <- brick("2005_01.nc", varname = "strd")
dta_05_02 <- brick("2005_02.nc", varname = "strd")
dta_05_03 <- brick("2005_03.nc", varname = "strd")
dta_05_04 <- brick("2005_04.nc", varname = "strd")
dta_05_05 <- brick("2005_05.nc", varname = "strd")
dta_05_06 <- brick("2005_06.nc", varname = "strd")
dta_05_07 <- brick("2005_07.nc", varname = "strd")
dta_05_08 <- brick("2005_08.nc", varname = "strd")
dta_05_09 <- brick("2005_09.nc", varname = "strd")
dta_05_10 <- brick("2005_10.nc", varname = "strd")
dta_05_11 <- brick("2005_11.nc", varname = "strd")
dta_05_12 <- brick("2005_12.nc", varname = "strd")

#2006
dta_06_01 <- brick("2006_01.nc", varname = "strd")
dta_06_02 <- brick("2006_02.nc", varname = "strd")
dta_06_03 <- brick("2006_03.nc", varname = "strd")
dta_06_04 <- brick("2006_04.nc", varname = "strd")
dta_06_05 <- brick("2006_05.nc", varname = "strd")
dta_06_06 <- brick("2006_06.nc", varname = "strd")
dta_06_07 <- brick("2006_07.nc", varname = "strd")
dta_06_08 <- brick("2006_08.nc", varname = "strd")
dta_06_09 <- brick("2006_09.nc", varname = "strd")
dta_06_10 <- brick("2006_10.nc", varname = "strd")
dta_06_11 <- brick("2006_11.nc", varname = "strd")
dta_06_12 <- brick("2006_12.nc", varname = "strd")

#2007
dta_07_01 <- brick("2007_01.nc", varname = "strd")
dta_07_02 <- brick("2007_02.nc", varname = "strd")
dta_07_03 <- brick("2007_03.nc", varname = "strd")
dta_07_04 <- brick("2007_04.nc", varname = "strd")
dta_07_05 <- brick("2007_05.nc", varname = "strd")
dta_07_06 <- brick("2007_06.nc", varname = "strd")
dta_07_07 <- brick("2007_07.nc", varname = "strd")
dta_07_08 <- brick("2007_08.nc", varname = "strd")
dta_07_09 <- brick("2007_09.nc", varname = "strd")
dta_07_10 <- brick("2007_10.nc", varname = "strd")
dta_07_11 <- brick("2007_11.nc", varname = "strd")
dta_07_12 <- brick("2007_12.nc", varname = "strd")

#2008
dta_08_01 <- brick("2008_01.nc", varname = "strd")
dta_08_02 <- brick("2008_02.nc", varname = "strd")
dta_08_03 <- brick("2008_03.nc", varname = "strd")
dta_08_04 <- brick("2008_04.nc", varname = "strd")
dta_08_05 <- brick("2008_05.nc", varname = "strd")
dta_08_06 <- brick("2008_06.nc", varname = "strd")
dta_08_07 <- brick("2008_07.nc", varname = "strd")
dta_08_08 <- brick("2008_08.nc", varname = "strd")
dta_08_09 <- brick("2008_09.nc", varname = "strd")
dta_08_10 <- brick("2008_10.nc", varname = "strd")
dta_08_11 <- brick("2008_11.nc", varname = "strd")
dta_08_12 <- brick("2008_12.nc", varname = "strd")

#2009
dta_09_01 <- brick("2009_01.nc", varname = "strd")
dta_09_02 <- brick("2009_02.nc", varname = "strd")
dta_09_03 <- brick("2009_03.nc", varname = "strd")
dta_09_04 <- brick("2009_04.nc", varname = "strd")
dta_09_05 <- brick("2009_05.nc", varname = "strd")
dta_09_06 <- brick("2009_06.nc", varname = "strd")
dta_09_07 <- brick("2009_07.nc", varname = "strd")
dta_09_08 <- brick("2009_08.nc", varname = "strd")
dta_09_09 <- brick("2009_09.nc", varname = "strd")
dta_09_10 <- brick("2009_10.nc", varname = "strd")
dta_09_11 <- brick("2009_11.nc", varname = "strd")
dta_09_12 <- brick("2009_12.nc", varname = "strd")

#2010
dta_10_01 <- brick("2010_01.nc", varname = "strd")
dta_10_02 <- brick("2010_02.nc", varname = "strd")
dta_10_03 <- brick("2010_03.nc", varname = "strd")
dta_10_04 <- brick("2010_04.nc", varname = "strd")
dta_10_05 <- brick("2010_05.nc", varname = "strd")
dta_10_06 <- brick("2010_06.nc", varname = "strd")
dta_10_07 <- brick("2010_07.nc", varname = "strd")
dta_10_08 <- brick("2010_08.nc", varname = "strd")
dta_10_09 <- brick("2010_09.nc", varname = "strd")
dta_10_10 <- brick("2010_10.nc", varname = "strd")
dta_10_11 <- brick("2010_11.nc", varname = "strd")
dta_10_12 <- brick("2010_12.nc", varname = "strd")

#2011
dta_11_01 <- brick("2011_01.nc", varname = "strd")
dta_11_02 <- brick("2011_02.nc", varname = "strd")
dta_11_03 <- brick("2011_03.nc", varname = "strd")
dta_11_04 <- brick("2011_04.nc", varname = "strd")
dta_11_05 <- brick("2011_05.nc", varname = "strd")
dta_11_06 <- brick("2011_06.nc", varname = "strd")
dta_11_07 <- brick("2011_07.nc", varname = "strd")
dta_11_08 <- brick("2011_08.nc", varname = "strd")
dta_11_09 <- brick("2011_09.nc", varname = "strd")
dta_11_10 <- brick("2011_10.nc", varname = "strd")
dta_11_11 <- brick("2011_11.nc", varname = "strd")
dta_11_12 <- brick("2011_12.nc", varname = "strd")

#2012
dta_12_01 <- brick("2012_01.nc", varname = "strd")
dta_12_02 <- brick("2012_02.nc", varname = "strd")
dta_12_03 <- brick("2012_03.nc", varname = "strd")
dta_12_04 <- brick("2012_04.nc", varname = "strd")
dta_12_05 <- brick("2012_05.nc", varname = "strd")
dta_12_06 <- brick("2012_06.nc", varname = "strd")
dta_12_07 <- brick("2012_07.nc", varname = "strd")
dta_12_08 <- brick("2012_08.nc", varname = "strd")
dta_12_09 <- brick("2012_09.nc", varname = "strd")
dta_12_10 <- brick("2012_10.nc", varname = "strd")
dta_12_11 <- brick("2012_11.nc", varname = "strd")
dta_12_12 <- brick("2012_12.nc", varname = "strd")

#2013
dta_13_01 <- brick("2013_01.nc", varname = "strd")
dta_13_02 <- brick("2013_02.nc", varname = "strd")
dta_13_03 <- brick("2013_03.nc", varname = "strd")
dta_13_04 <- brick("2013_04.nc", varname = "strd")
dta_13_05 <- brick("2013_05.nc", varname = "strd")
dta_13_06 <- brick("2013_06.nc", varname = "strd")
dta_13_07 <- brick("2013_07.nc", varname = "strd")
dta_13_08 <- brick("2013_08.nc", varname = "strd")
dta_13_09 <- brick("2013_09.nc", varname = "strd")
dta_13_10 <- brick("2013_10.nc", varname = "strd")
dta_13_11 <- brick("2013_11.nc", varname = "strd")
dta_13_12 <- brick("2013_12.nc", varname = "strd")

#2014
dta_14_01 <- brick("2014_01.nc", varname = "strd")
dta_14_02 <- brick("2014_02.nc", varname = "strd")
dta_14_03 <- brick("2014_03.nc", varname = "strd")
dta_14_04 <- brick("2014_04.nc", varname = "strd")
dta_14_05 <- brick("2014_05.nc", varname = "strd")
dta_14_06 <- brick("2014_06.nc", varname = "strd")
dta_14_07 <- brick("2014_07.nc", varname = "strd")
dta_14_08 <- brick("2014_08.nc", varname = "strd")
dta_14_09 <- brick("2014_09.nc", varname = "strd")
dta_14_10 <- brick("2014_10.nc", varname = "strd")
dta_14_11 <- brick("2014_11.nc", varname = "strd")
dta_14_12 <- brick("2014_12.nc", varname = "strd")

#2015
dta_15_01 <- brick("2015_01.nc", varname = "strd")
dta_15_02 <- brick("2015_02.nc", varname = "strd")
dta_15_03 <- brick("2015_03.nc", varname = "strd")
dta_15_04 <- brick("2015_04.nc", varname = "strd")
dta_15_05 <- brick("2015_05.nc", varname = "strd")
dta_15_06 <- brick("2015_06.nc", varname = "strd")
dta_15_07 <- brick("2015_07.nc", varname = "strd")
dta_15_08 <- brick("2015_08.nc", varname = "strd")
dta_15_09 <- brick("2015_09.nc", varname = "strd")
dta_15_10 <- brick("2015_10.nc", varname = "strd")
dta_15_11 <- brick("2015_11.nc", varname = "strd")
dta_15_12 <- brick("2015_12.nc", varname = "strd")

#2016
dta_16_01 <- brick("2016_01.nc", varname = "strd")
dta_16_02 <- brick("2016_02.nc", varname = "strd")
dta_16_03 <- brick("2016_03.nc", varname = "strd")
dta_16_04 <- brick("2016_04.nc", varname = "strd")
dta_16_05 <- brick("2016_05.nc", varname = "strd")
dta_16_06 <- brick("2016_06.nc", varname = "strd")
dta_16_07 <- brick("2016_07.nc", varname = "strd")
dta_16_08 <- brick("2016_08.nc", varname = "strd")
dta_16_09 <- brick("2016_09.nc", varname = "strd")
dta_16_10 <- brick("2016_10.nc", varname = "strd")
dta_16_11 <- brick("2016_11.nc", varname = "strd")
dta_16_12 <- brick("2016_12.nc", varname = "strd")

#2017
dta_17_01 <- brick("2017_01.nc", varname = "strd")
dta_17_02 <- brick("2017_02.nc", varname = "strd")
dta_17_03 <- brick("2017_03.nc", varname = "strd")
dta_17_04 <- brick("2017_04.nc", varname = "strd")
dta_17_05 <- brick("2017_05.nc", varname = "strd")
dta_17_06 <- brick("2017_06.nc", varname = "strd")
dta_17_07 <- brick("2017_07.nc", varname = "strd")
dta_17_08 <- brick("2017_08.nc", varname = "strd")
dta_17_09 <- brick("2017_09.nc", varname = "strd")
dta_17_10 <- brick("2017_10.nc", varname = "strd")
dta_17_11 <- brick("2017_11.nc", varname = "strd")
dta_17_12 <- brick("2017_12.nc", varname = "strd")

#2018
dta_18_01 <- brick("2018_01.nc", varname = "strd")
dta_18_02 <- brick("2018_02.nc", varname = "strd")
dta_18_03 <- brick("2018_03.nc", varname = "strd")
dta_18_04 <- brick("2018_04.nc", varname = "strd")
dta_18_05 <- brick("2018_05.nc", varname = "strd")
dta_18_06 <- brick("2018_06.nc", varname = "strd")
dta_18_07 <- brick("2018_07.nc", varname = "strd")
dta_18_08 <- brick("2018_08.nc", varname = "strd")
dta_18_09 <- brick("2018_09.nc", varname = "strd")
dta_18_10 <- brick("2018_10.nc", varname = "strd")
dta_18_11 <- brick("2018_11.nc", varname = "strd")
dta_18_12 <- brick("2018_12.nc", varname = "strd")

#2019
dta_19_01 <- brick("2019_01.nc", varname = "strd")
dta_19_02 <- brick("2019_02.nc", varname = "strd")
dta_19_03 <- brick("2019_03.nc", varname = "strd")
dta_19_04 <- brick("2019_04.nc", varname = "strd")
dta_19_05 <- brick("2019_05.nc", varname = "strd")
dta_19_06 <- brick("2019_06.nc", varname = "strd")
dta_19_07 <- brick("2019_07.nc", varname = "strd")
dta_19_08 <- brick("2019_08.nc", varname = "strd")
dta_19_09 <- brick("2019_09.nc", varname = "strd")
dta_19_10 <- brick("2019_10.nc", varname = "strd")
dta_19_11 <- brick("2019_11.nc", varname = "strd")
dta_19_12 <- brick("2019_12.nc", varname = "strd")

#2020
dta_20_01 <- brick("2020_01.nc", varname = "strd")
dta_20_02 <- brick("2020_02.nc", varname = "strd")
dta_20_03 <- brick("2020_03.nc", varname = "strd")
dta_20_04 <- brick("2020_04.nc", varname = "strd")
dta_20_05 <- brick("2020_05.nc", varname = "strd")
dta_20_06 <- brick("2020_06.nc", varname = "strd")
dta_20_07 <- brick("2020_07.nc", varname = "strd")
dta_20_08 <- brick("2020_08.nc", varname = "strd")
dta_20_09 <- brick("2020_09.nc", varname = "strd")
dta_20_10 <- brick("2020_10.nc", varname = "strd")
dta_20_11 <- brick("2020_11.nc", varname = "strd")
dta_20_12 <- brick("2020_12.nc", varname = "strd")

#2021
dta_21_01 <- brick("2021_01.nc", varname = "strd")
dta_21_02 <- brick("2021_02.nc", varname = "strd")
dta_21_03 <- brick("2021_03.nc", varname = "strd")
dta_21_04 <- brick("2021_04.nc", varname = "strd")
dta_21_05 <- brick("2021_05.nc", varname = "strd")
dta_21_06 <- brick("2021_06.nc", varname = "strd")
dta_21_07 <- brick("2021_07.nc", varname = "strd")
dta_21_08 <- brick("2021_08.nc", varname = "strd")
dta_21_09 <- brick("2021_09.nc", varname = "strd")
dta_21_10 <- brick("2021_10.nc", varname = "strd")
dta_21_11 <- brick("2021_11.nc", varname = "strd")
dta_21_12 <- brick("2021_12.nc", varname = "strd")

#2022
dta_22_01 <- brick("2022_01.nc", varname = "strd")
dta_22_02 <- brick("2022_02.nc", varname = "strd")
dta_22_03 <- brick("2022_03.nc", varname = "strd")
dta_22_04 <- brick("2022_04.nc", varname = "strd")
dta_22_05 <- brick("2022_05.nc", varname = "strd")
dta_22_06 <- brick("2022_06.nc", varname = "strd")
dta_22_07 <- brick("2022_07.nc", varname = "strd")
dta_22_08 <- brick("2022_08.nc", varname = "strd")
dta_22_09 <- brick("2022_09.nc", varname = "strd")
dta_22_10 <- brick("2022_10.nc", varname = "strd")
dta_22_11 <- brick("2022_11.nc", varname = "strd")
dta_22_12 <- brick("2022_12.nc", varname = "strd")

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
strd <- mosaic(sub_00, sub_01, sub_02, sub_03, sub_04, sub_05,
               sub_06, sub_07, sub_08, sub_09, sub_10, sub_11,
               sub_12, sub_13, sub_14, sub_15, sub_16, sub_17,
               sub_18, sub_19, sub_20, sub_21, sub_22, sub_23, fun = mean)
names(strd) <- names(sub_00)



#### Total precipitation ####
#2004
dta_04_10 <- brick("2004_10.nc", varname = "tp")
dta_04_11 <- brick("2004_11.nc", varname = "tp")
dta_04_12 <- brick("2004_12.nc", varname = "tp")

#2005
dta_05_01 <- brick("2005_01.nc", varname = "tp")
dta_05_02 <- brick("2005_02.nc", varname = "tp")
dta_05_03 <- brick("2005_03.nc", varname = "tp")
dta_05_04 <- brick("2005_04.nc", varname = "tp")
dta_05_05 <- brick("2005_05.nc", varname = "tp")
dta_05_06 <- brick("2005_06.nc", varname = "tp")
dta_05_07 <- brick("2005_07.nc", varname = "tp")
dta_05_08 <- brick("2005_08.nc", varname = "tp")
dta_05_09 <- brick("2005_09.nc", varname = "tp")
dta_05_10 <- brick("2005_10.nc", varname = "tp")
dta_05_11 <- brick("2005_11.nc", varname = "tp")
dta_05_12 <- brick("2005_12.nc", varname = "tp")

#2006
dta_06_01 <- brick("2006_01.nc", varname = "tp")
dta_06_02 <- brick("2006_02.nc", varname = "tp")
dta_06_03 <- brick("2006_03.nc", varname = "tp")
dta_06_04 <- brick("2006_04.nc", varname = "tp")
dta_06_05 <- brick("2006_05.nc", varname = "tp")
dta_06_06 <- brick("2006_06.nc", varname = "tp")
dta_06_07 <- brick("2006_07.nc", varname = "tp")
dta_06_08 <- brick("2006_08.nc", varname = "tp")
dta_06_09 <- brick("2006_09.nc", varname = "tp")
dta_06_10 <- brick("2006_10.nc", varname = "tp")
dta_06_11 <- brick("2006_11.nc", varname = "tp")
dta_06_12 <- brick("2006_12.nc", varname = "tp")

#2007
dta_07_01 <- brick("2007_01.nc", varname = "tp")
dta_07_02 <- brick("2007_02.nc", varname = "tp")
dta_07_03 <- brick("2007_03.nc", varname = "tp")
dta_07_04 <- brick("2007_04.nc", varname = "tp")
dta_07_05 <- brick("2007_05.nc", varname = "tp")
dta_07_06 <- brick("2007_06.nc", varname = "tp")
dta_07_07 <- brick("2007_07.nc", varname = "tp")
dta_07_08 <- brick("2007_08.nc", varname = "tp")
dta_07_09 <- brick("2007_09.nc", varname = "tp")
dta_07_10 <- brick("2007_10.nc", varname = "tp")
dta_07_11 <- brick("2007_11.nc", varname = "tp")
dta_07_12 <- brick("2007_12.nc", varname = "tp")

#2008
dta_08_01 <- brick("2008_01.nc", varname = "tp")
dta_08_02 <- brick("2008_02.nc", varname = "tp")
dta_08_03 <- brick("2008_03.nc", varname = "tp")
dta_08_04 <- brick("2008_04.nc", varname = "tp")
dta_08_05 <- brick("2008_05.nc", varname = "tp")
dta_08_06 <- brick("2008_06.nc", varname = "tp")
dta_08_07 <- brick("2008_07.nc", varname = "tp")
dta_08_08 <- brick("2008_08.nc", varname = "tp")
dta_08_09 <- brick("2008_09.nc", varname = "tp")
dta_08_10 <- brick("2008_10.nc", varname = "tp")
dta_08_11 <- brick("2008_11.nc", varname = "tp")
dta_08_12 <- brick("2008_12.nc", varname = "tp")

#2009
dta_09_01 <- brick("2009_01.nc", varname = "tp")
dta_09_02 <- brick("2009_02.nc", varname = "tp")
dta_09_03 <- brick("2009_03.nc", varname = "tp")
dta_09_04 <- brick("2009_04.nc", varname = "tp")
dta_09_05 <- brick("2009_05.nc", varname = "tp")
dta_09_06 <- brick("2009_06.nc", varname = "tp")
dta_09_07 <- brick("2009_07.nc", varname = "tp")
dta_09_08 <- brick("2009_08.nc", varname = "tp")
dta_09_09 <- brick("2009_09.nc", varname = "tp")
dta_09_10 <- brick("2009_10.nc", varname = "tp")
dta_09_11 <- brick("2009_11.nc", varname = "tp")
dta_09_12 <- brick("2009_12.nc", varname = "tp")

#2010
dta_10_01 <- brick("2010_01.nc", varname = "tp")
dta_10_02 <- brick("2010_02.nc", varname = "tp")
dta_10_03 <- brick("2010_03.nc", varname = "tp")
dta_10_04 <- brick("2010_04.nc", varname = "tp")
dta_10_05 <- brick("2010_05.nc", varname = "tp")
dta_10_06 <- brick("2010_06.nc", varname = "tp")
dta_10_07 <- brick("2010_07.nc", varname = "tp")
dta_10_08 <- brick("2010_08.nc", varname = "tp")
dta_10_09 <- brick("2010_09.nc", varname = "tp")
dta_10_10 <- brick("2010_10.nc", varname = "tp")
dta_10_11 <- brick("2010_11.nc", varname = "tp")
dta_10_12 <- brick("2010_12.nc", varname = "tp")

#2011
dta_11_01 <- brick("2011_01.nc", varname = "tp")
dta_11_02 <- brick("2011_02.nc", varname = "tp")
dta_11_03 <- brick("2011_03.nc", varname = "tp")
dta_11_04 <- brick("2011_04.nc", varname = "tp")
dta_11_05 <- brick("2011_05.nc", varname = "tp")
dta_11_06 <- brick("2011_06.nc", varname = "tp")
dta_11_07 <- brick("2011_07.nc", varname = "tp")
dta_11_08 <- brick("2011_08.nc", varname = "tp")
dta_11_09 <- brick("2011_09.nc", varname = "tp")
dta_11_10 <- brick("2011_10.nc", varname = "tp")
dta_11_11 <- brick("2011_11.nc", varname = "tp")
dta_11_12 <- brick("2011_12.nc", varname = "tp")

#2012
dta_12_01 <- brick("2012_01.nc", varname = "tp")
dta_12_02 <- brick("2012_02.nc", varname = "tp")
dta_12_03 <- brick("2012_03.nc", varname = "tp")
dta_12_04 <- brick("2012_04.nc", varname = "tp")
dta_12_05 <- brick("2012_05.nc", varname = "tp")
dta_12_06 <- brick("2012_06.nc", varname = "tp")
dta_12_07 <- brick("2012_07.nc", varname = "tp")
dta_12_08 <- brick("2012_08.nc", varname = "tp")
dta_12_09 <- brick("2012_09.nc", varname = "tp")
dta_12_10 <- brick("2012_10.nc", varname = "tp")
dta_12_11 <- brick("2012_11.nc", varname = "tp")
dta_12_12 <- brick("2012_12.nc", varname = "tp")

#2013
dta_13_01 <- brick("2013_01.nc", varname = "tp")
dta_13_02 <- brick("2013_02.nc", varname = "tp")
dta_13_03 <- brick("2013_03.nc", varname = "tp")
dta_13_04 <- brick("2013_04.nc", varname = "tp")
dta_13_05 <- brick("2013_05.nc", varname = "tp")
dta_13_06 <- brick("2013_06.nc", varname = "tp")
dta_13_07 <- brick("2013_07.nc", varname = "tp")
dta_13_08 <- brick("2013_08.nc", varname = "tp")
dta_13_09 <- brick("2013_09.nc", varname = "tp")
dta_13_10 <- brick("2013_10.nc", varname = "tp")
dta_13_11 <- brick("2013_11.nc", varname = "tp")
dta_13_12 <- brick("2013_12.nc", varname = "tp")

#2014
dta_14_01 <- brick("2014_01.nc", varname = "tp")
dta_14_02 <- brick("2014_02.nc", varname = "tp")
dta_14_03 <- brick("2014_03.nc", varname = "tp")
dta_14_04 <- brick("2014_04.nc", varname = "tp")
dta_14_05 <- brick("2014_05.nc", varname = "tp")
dta_14_06 <- brick("2014_06.nc", varname = "tp")
dta_14_07 <- brick("2014_07.nc", varname = "tp")
dta_14_08 <- brick("2014_08.nc", varname = "tp")
dta_14_09 <- brick("2014_09.nc", varname = "tp")
dta_14_10 <- brick("2014_10.nc", varname = "tp")
dta_14_11 <- brick("2014_11.nc", varname = "tp")
dta_14_12 <- brick("2014_12.nc", varname = "tp")

#2015
dta_15_01 <- brick("2015_01.nc", varname = "tp")
dta_15_02 <- brick("2015_02.nc", varname = "tp")
dta_15_03 <- brick("2015_03.nc", varname = "tp")
dta_15_04 <- brick("2015_04.nc", varname = "tp")
dta_15_05 <- brick("2015_05.nc", varname = "tp")
dta_15_06 <- brick("2015_06.nc", varname = "tp")
dta_15_07 <- brick("2015_07.nc", varname = "tp")
dta_15_08 <- brick("2015_08.nc", varname = "tp")
dta_15_09 <- brick("2015_09.nc", varname = "tp")
dta_15_10 <- brick("2015_10.nc", varname = "tp")
dta_15_11 <- brick("2015_11.nc", varname = "tp")
dta_15_12 <- brick("2015_12.nc", varname = "tp")

#2016
dta_16_01 <- brick("2016_01.nc", varname = "tp")
dta_16_02 <- brick("2016_02.nc", varname = "tp")
dta_16_03 <- brick("2016_03.nc", varname = "tp")
dta_16_04 <- brick("2016_04.nc", varname = "tp")
dta_16_05 <- brick("2016_05.nc", varname = "tp")
dta_16_06 <- brick("2016_06.nc", varname = "tp")
dta_16_07 <- brick("2016_07.nc", varname = "tp")
dta_16_08 <- brick("2016_08.nc", varname = "tp")
dta_16_09 <- brick("2016_09.nc", varname = "tp")
dta_16_10 <- brick("2016_10.nc", varname = "tp")
dta_16_11 <- brick("2016_11.nc", varname = "tp")
dta_16_12 <- brick("2016_12.nc", varname = "tp")

#2017
dta_17_01 <- brick("2017_01.nc", varname = "tp")
dta_17_02 <- brick("2017_02.nc", varname = "tp")
dta_17_03 <- brick("2017_03.nc", varname = "tp")
dta_17_04 <- brick("2017_04.nc", varname = "tp")
dta_17_05 <- brick("2017_05.nc", varname = "tp")
dta_17_06 <- brick("2017_06.nc", varname = "tp")
dta_17_07 <- brick("2017_07.nc", varname = "tp")
dta_17_08 <- brick("2017_08.nc", varname = "tp")
dta_17_09 <- brick("2017_09.nc", varname = "tp")
dta_17_10 <- brick("2017_10.nc", varname = "tp")
dta_17_11 <- brick("2017_11.nc", varname = "tp")
dta_17_12 <- brick("2017_12.nc", varname = "tp")

#2018
dta_18_01 <- brick("2018_01.nc", varname = "tp")
dta_18_02 <- brick("2018_02.nc", varname = "tp")
dta_18_03 <- brick("2018_03.nc", varname = "tp")
dta_18_04 <- brick("2018_04.nc", varname = "tp")
dta_18_05 <- brick("2018_05.nc", varname = "tp")
dta_18_06 <- brick("2018_06.nc", varname = "tp")
dta_18_07 <- brick("2018_07.nc", varname = "tp")
dta_18_08 <- brick("2018_08.nc", varname = "tp")
dta_18_09 <- brick("2018_09.nc", varname = "tp")
dta_18_10 <- brick("2018_10.nc", varname = "tp")
dta_18_11 <- brick("2018_11.nc", varname = "tp")
dta_18_12 <- brick("2018_12.nc", varname = "tp")

#2019
dta_19_01 <- brick("2019_01.nc", varname = "tp")
dta_19_02 <- brick("2019_02.nc", varname = "tp")
dta_19_03 <- brick("2019_03.nc", varname = "tp")
dta_19_04 <- brick("2019_04.nc", varname = "tp")
dta_19_05 <- brick("2019_05.nc", varname = "tp")
dta_19_06 <- brick("2019_06.nc", varname = "tp")
dta_19_07 <- brick("2019_07.nc", varname = "tp")
dta_19_08 <- brick("2019_08.nc", varname = "tp")
dta_19_09 <- brick("2019_09.nc", varname = "tp")
dta_19_10 <- brick("2019_10.nc", varname = "tp")
dta_19_11 <- brick("2019_11.nc", varname = "tp")
dta_19_12 <- brick("2019_12.nc", varname = "tp")

#2020
dta_20_01 <- brick("2020_01.nc", varname = "tp")
dta_20_02 <- brick("2020_02.nc", varname = "tp")
dta_20_03 <- brick("2020_03.nc", varname = "tp")
dta_20_04 <- brick("2020_04.nc", varname = "tp")
dta_20_05 <- brick("2020_05.nc", varname = "tp")
dta_20_06 <- brick("2020_06.nc", varname = "tp")
dta_20_07 <- brick("2020_07.nc", varname = "tp")
dta_20_08 <- brick("2020_08.nc", varname = "tp")
dta_20_09 <- brick("2020_09.nc", varname = "tp")
dta_20_10 <- brick("2020_10.nc", varname = "tp")
dta_20_11 <- brick("2020_11.nc", varname = "tp")
dta_20_12 <- brick("2020_12.nc", varname = "tp")

#2021
dta_21_01 <- brick("2021_01.nc", varname = "tp")
dta_21_02 <- brick("2021_02.nc", varname = "tp")
dta_21_03 <- brick("2021_03.nc", varname = "tp")
dta_21_04 <- brick("2021_04.nc", varname = "tp")
dta_21_05 <- brick("2021_05.nc", varname = "tp")
dta_21_06 <- brick("2021_06.nc", varname = "tp")
dta_21_07 <- brick("2021_07.nc", varname = "tp")
dta_21_08 <- brick("2021_08.nc", varname = "tp")
dta_21_09 <- brick("2021_09.nc", varname = "tp")
dta_21_10 <- brick("2021_10.nc", varname = "tp")
dta_21_11 <- brick("2021_11.nc", varname = "tp")
dta_21_12 <- brick("2021_12.nc", varname = "tp")

#2022
dta_22_01 <- brick("2022_01.nc", varname = "tp")
dta_22_02 <- brick("2022_02.nc", varname = "tp")
dta_22_03 <- brick("2022_03.nc", varname = "tp")
dta_22_04 <- brick("2022_04.nc", varname = "tp")
dta_22_05 <- brick("2022_05.nc", varname = "tp")
dta_22_06 <- brick("2022_06.nc", varname = "tp")
dta_22_07 <- brick("2022_07.nc", varname = "tp")
dta_22_08 <- brick("2022_08.nc", varname = "tp")
dta_22_09 <- brick("2022_09.nc", varname = "tp")
dta_22_10 <- brick("2022_10.nc", varname = "tp")
dta_22_11 <- brick("2022_11.nc", varname = "tp")
dta_22_12 <- brick("2022_12.nc", varname = "tp")

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
tp <- mosaic(sub_00, sub_01, sub_02, sub_03, sub_04, sub_05,
               sub_06, sub_07, sub_08, sub_09, sub_10, sub_11,
               sub_12, sub_13, sub_14, sub_15, sub_16, sub_17,
               sub_18, sub_19, sub_20, sub_21, sub_22, sub_23, fun = mean)
names(tp) <- names(sub_00)



#### Loop and output both files ####
## First, double check all output files
u10
v10
d2m
t2m
fal
src
skt
stl1
str
sp
sshf
strd
tp

## Since files are same length, just pick one to use as "base" with x/y/time information
## cbind the rest

## Reformatting for a single CSV file
u10.1 <- as.data.frame(rasterToPoints(u10[[1]]))
v10.1 <- as.data.frame(rasterToPoints(v10[[1]]))
d2m.1 <- as.data.frame(rasterToPoints(d2m[[1]]))
t2m.1 <- as.data.frame(rasterToPoints(t2m[[1]]))
fal.1 <- as.data.frame(rasterToPoints(fal[[1]]))
src.1 <- as.data.frame(rasterToPoints(src[[1]]))
skt.1 <- as.data.frame(rasterToPoints(skt[[1]]))
stl1.1 <- as.data.frame(rasterToPoints(stl1[[1]]))
str.1 <- as.data.frame(rasterToPoints(str[[1]]))
sp.1 <- as.data.frame(rasterToPoints(sp[[1]]))
sshf.1 <- as.data.frame(rasterToPoints(sshf[[1]]))
strd.1 <- as.data.frame(rasterToPoints(strd[[1]]))
tp.1 <- as.data.frame(rasterToPoints(tp[[1]]))

u10.1$date <- as.Date(substr(names(u10.1)[3], 2, 11), format = "%Y.%m.%d")
v10.1$date <- as.Date(substr(names(v10.1)[3], 2, 11), format = "%Y.%m.%d")
d2m.1$date <- as.Date(substr(names(d2m.1)[3], 2, 11), format = "%Y.%m.%d")
t2m.1$date <- as.Date(substr(names(t2m.1)[3], 2, 11), format = "%Y.%m.%d")
fal.1$date <- as.Date(substr(names(fal.1)[3], 2, 11), format = "%Y.%m.%d")
src.1$date <- as.Date(substr(names(src.1)[3], 2, 11), format = "%Y.%m.%d")
skt.1$date <- as.Date(substr(names(skt.1)[3], 2, 11), format = "%Y.%m.%d")
stl1.1$date <- as.Date(substr(names(stl1.1)[3], 2, 11), format = "%Y.%m.%d")
str.1$date <- as.Date(substr(names(str.1)[3], 2, 11), format = "%Y.%m.%d")
sp.1$date <- as.Date(substr(names(sp.1)[3], 2, 11), format = "%Y.%m.%d")
sshf.1$date <- as.Date(substr(names(sshf.1)[3], 2, 11), format = "%Y.%m.%d")
strd.1$date <- as.Date(substr(names(strd.1)[3], 2, 11), format = "%Y.%m.%d")
tp.1$date <- as.Date(substr(names(tp.1)[3], 2, 11), format = "%Y.%m.%d")

names(u10.1)[3] <- "wind_u"
names(v10.1)[3] <- "wind_v"
names(d2m.1)[3] <- "dew_2m"
names(t2m.1)[3] <- "temp_2m"
names(fal.1)[3] <- "albedo"
names(src.1)[3] <- "skin_res"
names(skt.1)[3] <- "skin_temp"
names(stl1.1)[3] <- "soil_temp_1"
names(str.1)[3] <- "radiation_net"
names(sp.1)[3] <- "pressure"
names(sshf.1)[3] <- "heat_flux"
names(strd.1)[3] <- "radiation_down"
names(tp.1)[3] <- "precip"

## use blh as "base", bind data together
nc.1 <- u10.1[, c(1, 2, 4, 3)]
nc.1 <- cbind(nc.1, v10.1$wind_v)
nc.1 <- cbind(nc.1, d2m.1$dew_2m)
nc.1 <- cbind(nc.1, t2m.1$temp_2m)
nc.1 <- cbind(nc.1, fal.1$albedo)
nc.1 <- cbind(nc.1, src.1$skin_res)
nc.1 <- cbind(nc.1, skt.1$skin_temp)
nc.1 <- cbind(nc.1, stl1.1$soil_temp_1)
nc.1 <- cbind(nc.1, str.1$radiation_net)
nc.1 <- cbind(nc.1, sp.1$pressure)
nc.1 <- cbind(nc.1, sshf.1$heat_flux)
nc.1 <- cbind(nc.1, strd.1$radiation_down)
nc.1 <- cbind(nc.1, tp.1$precip)

names(nc.1)[5] <- "wind_v" #need to do this again due to cbind
names(nc.1)[6] <- "dew_2m"
names(nc.1)[7] <- "temp_2m"
names(nc.1)[8] <- "albedo"
names(nc.1)[9] <- "skin_res"
names(nc.1)[10] <- "skin_temp"
names(nc.1)[11] <- "soil_temp_1"
names(nc.1)[12] <- "radiation_net"
names(nc.1)[13] <- "pressure"
names(nc.1)[14] <- "heat_flux"
names(nc.1)[15] <- "radiation_down"
names(nc.1)[16] <- "precip"

nc.1 <- st_as_sf(nc.1, coords=c("x", "y"), crs=4326)
nc.1 <- st_join(grid, nc.1, join = st_nearest_feature)
coords <- as.data.frame(st_coordinates(nc.1))
nc.1 <- nc.1 %>%
  as.data.frame(dplyr::select(sinu_id, date, wind_u, wind_v,
                              dew_2m, temp_2m, albedo, skin_res,
                              skin_temp, soil_temp_1, radiation_net,
                              pressure, heat_flux, radiation_down, precip)) %>%
  dplyr::select(-geometry)
nc.1 <- cbind(nc.1, coords)
nc.1 <- nc.1[, c(1, 16, 17, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)]


## Looping procedure
setwd("/media/hd/no2_israel/processed_data/era5_land")
files.length <- dim(u10)[3]
dates <- as.data.frame(seq(as.Date("2004-10-01"), as.Date("2022-12-31"), by = 1))
names(dates)[1] <- "date"

# i in  1:files.length
for (i in  1:files.length){
  ## data frame all variables
  u10.i <- as.data.frame(rasterToPoints(u10[[i]]))
  v10.i <- as.data.frame(rasterToPoints(v10[[i]]))
  d2m.i <- as.data.frame(rasterToPoints(d2m[[i]]))
  t2m.i <- as.data.frame(rasterToPoints(t2m[[i]]))
  fal.i <- as.data.frame(rasterToPoints(fal[[i]]))
  src.i <- as.data.frame(rasterToPoints(src[[i]]))
  skt.i <- as.data.frame(rasterToPoints(skt[[i]]))
  stl1.i <- as.data.frame(rasterToPoints(stl1[[i]]))
  str.i <- as.data.frame(rasterToPoints(str[[i]]))
  sp.i <- as.data.frame(rasterToPoints(sp[[i]]))
  sshf.i <- as.data.frame(rasterToPoints(sshf[[i]]))
  strd.i <- as.data.frame(rasterToPoints(strd[[i]]))
  tp.i <- as.data.frame(rasterToPoints(tp[[i]]))
  
  ## date
  u10.i$date <- as.Date(substr(names(u10.i)[3], 2, 11), format = "%Y.%m.%d")
  v10.i$date <- as.Date(substr(names(v10.i)[3], 2, 11), format = "%Y.%m.%d")
  d2m.i$date <- as.Date(substr(names(d2m.i)[3], 2, 11), format = "%Y.%m.%d")
  t2m.i$date <- as.Date(substr(names(t2m.i)[3], 2, 11), format = "%Y.%m.%d")
  fal.i$date <- as.Date(substr(names(fal.i)[3], 2, 11), format = "%Y.%m.%d")
  src.i$date <- as.Date(substr(names(src.i)[3], 2, 11), format = "%Y.%m.%d")
  skt.i$date <- as.Date(substr(names(skt.i)[3], 2, 11), format = "%Y.%m.%d")
  stl1.i$date <- as.Date(substr(names(stl1.i)[3], 2, 11), format = "%Y.%m.%d")
  str.i$date <- as.Date(substr(names(str.i)[3], 2, 11), format = "%Y.%m.%d")
  sp.i$date <- as.Date(substr(names(sp.i)[3], 2, 11), format = "%Y.%m.%d")
  sshf.i$date <- as.Date(substr(names(sshf.i)[3], 2, 11), format = "%Y.%m.%d")
  strd.i$date <- as.Date(substr(names(strd.i)[3], 2, 11), format = "%Y.%m.%d")
  tp.i$date <- as.Date(substr(names(tp.i)[3], 2, 11), format = "%Y.%m.%d")
  
  ## change names
  names(u10.i)[3] <- "wind_u"
  names(v10.i)[3] <- "wind_v"
  names(d2m.i)[3] <- "dew_2m"
  names(t2m.i)[3] <- "temp_2m"
  names(fal.i)[3] <- "albedo"
  names(src.i)[3] <- "skin_res"
  names(skt.i)[3] <- "skin_temp"
  names(stl1.i)[3] <- "soil_temp_1"
  names(str.i)[3] <- "radiation_net"
  names(sp.i)[3] <- "pressure"
  names(sshf.i)[3] <- "heat_flux"
  names(strd.i)[3] <- "radiation_down"
  names(tp.i)[3] <- "precip"
  
  ## use u10 as "base", bind data together
  nc.i <- u10.i[, c(1, 2, 4, 3)]
  nc.i <- cbind(nc.i, v10.i$wind_v)
  nc.i <- cbind(nc.i, d2m.i$dew_2m)
  nc.i <- cbind(nc.i, t2m.i$temp_2m)
  nc.i <- cbind(nc.i, fal.i$albedo)
  nc.i <- cbind(nc.i, src.i$skin_res)
  nc.i <- cbind(nc.i, skt.i$skin_temp)
  nc.i <- cbind(nc.i, stl1.i$soil_temp_1)
  nc.i <- cbind(nc.i, str.i$radiation_net)
  nc.i <- cbind(nc.i, sp.i$pressure)
  nc.i <- cbind(nc.i, sshf.i$heat_flux)
  nc.i <- cbind(nc.i, strd.i$radiation_down)
  nc.i <- cbind(nc.i, tp.i$precip)
  
  names(nc.i)[5] <- "wind_v"
  names(nc.i)[6] <- "dew_2m"
  names(nc.i)[7] <- "temp_2m"
  names(nc.i)[8] <- "albedo"
  names(nc.i)[9] <- "skin_res"
  names(nc.i)[10] <- "skin_temp"
  names(nc.i)[11] <- "soil_temp_1"
  names(nc.i)[12] <- "radiation_net"
  names(nc.i)[13] <- "pressure"
  names(nc.i)[14] <- "heat_flux"
  names(nc.i)[15] <- "radiation_down"
  names(nc.i)[16] <- "precip"
  
  nc.i <- st_as_sf(nc.i, coords=c("x", "y"), crs=4326)
  nc.i <- st_join(grid, nc.i, join = st_nearest_feature)
  coords <- as.data.frame(st_coordinates(nc.i))
  nc.i <- nc.i %>%
    as.data.frame(dplyr::select(sinu_id, date, wind_u, wind_v,
                                dew_2m, temp_2m, albedo, skin_res,
                                skin_temp, soil_temp_1, radiation_net,
                                pressure, heat_flux, radiation_down, precip)) %>%
    dplyr::select(-geometry)
  nc.i <- cbind(nc.i, coords)
  nc.i <- nc.i[, c(1, 16, 17, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)]

  ## output
  nm1 <- paste("era5_l_", dates$date[i], ".csv", sep="")
  write.csv(nc.i, file = nm1 ,row.names = FALSE)
}

#writeRaster(dta_1, filename='wind_u.tif', format="GTiff", overwrite=TRUE,options=c("INTERLEAVE=BAND","COMPRESS=LZW"))