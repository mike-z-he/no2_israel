#### Plots for Israel NO2 Manuscript ####
#### March 26, 2024 ####

#### Load packages ####
library(tidyverse)
library(data.table)
library(dplyr)
library(doParallel)
library(foreach)
library(ranger)
library(mgcv)
library(caret)
library(xgboost)
library(DiceKriging)
library(rgenoud)
library(patchwork)
library(raster)
library(sf)
library(stars)


#### Making plots with Michael's code ####
# Read
r = read_stars('template.tif')

# Prepare template
crs = st_crs(r)
r = st_set_dimensions(r, 'x', offset = st_dimensions(r)$x$offset + st_dimensions(r)$x$delta/2, delta = st_dimensions(r)$x$delta)
r = st_set_dimensions(r, 'y', offset = st_dimensions(r)$y$offset + st_dimensions(r)$y$delta/2, delta = st_dimensions(r)$y$delta)
r = st_set_crs(r, crs)

# To points
spatial_rf <- st_transform(spatial_rf, st_crs(r))
spatial_bo <- st_transform(spatial_bo, st_crs(r))
spatial_gam <- st_transform(spatial_gam, st_crs(r))

# Rasterize
r_rf = st_rasterize(spatial_rf['mean_rf'], r)
r_bo = st_rasterize(spatial_bo['mean_bo'], r)
r_gam = st_rasterize(spatial_gam['mean_gam'], r)

plot(r_rf)
plot(r_bo)
plot(r_gam)