# Downloads and unzips Snow's cholera data
# Creates two geojson files: one for pumps and one for deaths

# Author: Sara Altman, Bill Behrman
# Version: 2019-02-27

# Libraries
library(tidyverse)
library(sf)

# Parameters
url_data <- "http://rtwilson.com/downloads/SnowGIS_KML.zip"
# Output files
file_out_deaths <- "cholera_deaths.geojson"
file_out_pumps <- "cholera_pumps.geojson"
#===============================================================================

# Create temporary directory
dir_tmp <- str_glue("/tmp/{Sys.time() %>% as.integer()}")
if (!file.exists(dir_tmp)) {
  dir.create(dir_tmp, recursive = TRUE)
}

file_zip <- str_glue("{dir_tmp}/SnowGIS_KML.zip")

if (download.file(url = url_data, destfile = file_zip, quiet = TRUE)) {
  stop("Error: Download failed")
}

unzip(zipfile = file_zip, exdir = dir_tmp)

str_glue("{dir_tmp}/SnowGIS_KML/cholera_deaths.kml") %>% 
  read_sf() %>% 
  transmute(
    deaths = str_extract(Description, "\\d+") %>% as.integer(),
    geometry = geometry
  ) %>% 
  arrange(desc(deaths)) %>% 
  st_write(file_out_deaths, delete_dsn = TRUE)
  
str_glue("{dir_tmp}/SnowGIS_KML/pumps.kml") %>% 
  read_sf() %>%  
  select(geometry) %>% 
  st_write(file_out_pumps, delete_dsn = TRUE)

# Remove temporary directory
if (unlink(dir_tmp, recursive = TRUE, force = TRUE)) {
  print("Error: Remove temporary directory failed")
}



