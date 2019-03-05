# 

# Author: Sara Altman, Bill Behrman
# Version: 2019-02-27

# Libraries
library(tidyverse)
library(sf)

# Parameters
url_data <- "https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip"
# Output files
file_out_africa <- "africa.geojson"
#===============================================================================

# Create temporary directory
dir_tmp <- str_glue("/tmp/{Sys.time() %>% as.integer()}")

if (!file.exists(dir_tmp)) {
  dir.create(dir_tmp, recursive = TRUE)
}

file_zip <- str_glue("{dir_tmp}/ne_50m_admin_0_countries.zip")

if (download.file(url = url_data, destfile = file_zip, quiet = TRUE)) {
  stop("Error: Download failed")
}

unzip(zipfile = file_zip, exdir = dir_tmp)

str_glue("{dir_tmp}/ne_50m_admin_0_countries.shp") %>% 
  read_sf() %>% 
  rename_all(str_to_lower) %>% 
  filter(continent == "Africa") %>% 
  select(name, population = pop_est, geometry) %>% 
  st_write(file_out_africa)
  
# Remove temporary directory
if (unlink(dir_tmp, recursive = TRUE, force = TRUE)) {
  print("Error: Remove temporary directory failed")
}