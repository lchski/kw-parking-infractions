library(tidyverse)
library(lubridate)
library(janitor)
library(skimr)

source("lib/helpers.R")

kitchener <- read_csv("data/source/City_of_Kitchener_Parking_Infractions.csv") %>%
  clean_names()

waterloo <- read_csv("data/source/City_of_Waterloo_Bylaw_Parking_Infractions.csv") %>%
  clean_names() %>%
  mutate(month = month(issuedate), hour = hour(issuedate), minute = minute(issuedate), second = second(issuedate)) %>%
  mutate(time = paste0(today(), " ", hour, ":", minute, ":", second)) %>%
  mutate(time = parse_date_time(time, "Y-m-d H:M:S"))
