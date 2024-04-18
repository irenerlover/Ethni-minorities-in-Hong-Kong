library(here)
library(tidyverse)
library(readxl)
library(geojsonio)
library(sf)
library(magrittr)
library(broom)
list.files()

#Load the data
dcd_em = read_xlsx('DCD_EM.xlsx')

district_map = st_read("DCD.json")

#Data cleaning

dcd_em$District = paste(dcd_em$District, 'District')

# Remove leading and trailing whitespace
district_map$NAME_EN[2] = trimws(district_map$NAME_EN[2])

#checking
dcd_em$District %in% district_map$NAME_EN

dcd_em_2006 = dcd_em %>% filter(Year == 2006)

district_map_2006 = left_join(district_map,dcd_em_2006, by = join_by(NAME_EN == District))

district_map_2006$`Total Population` = as.numeric(district_map_2006$`Total Population`)

# Create a map using ggplot
ggplot(district_map_2006) + 
  geom_sf(aes(fill = `Total Population`)) + 
  scale_fill_gradient(low = "white", high = "black") +
  theme_minimal()




































