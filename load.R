library(tidyverse)
library(lubridate)
library(janitor)
library(skimr)

source("lib/helpers.R")

kitchener <- read_csv("data/source/City_of_Kitchener_Parking_Infractions.csv") %>%
  clean_names()

waterloo <- read_csv("data/source/City_of_Waterloo_Bylaw_Parking_Infractions.csv") %>%
  clean_names() %>%
  mutate(hour = hour(issuedate), minute = minute(issuedate), second = second(issuedate)) %>%
  mutate(time = paste0(today(), " ", hour, ":", minute, ":", second)) %>%
  mutate(time = parse_date_time(time, "Y-m-d H:M:S"))

waterloo %>%
  filter(str_detect(street, "PINE")) %>%
  group_by(street) %>%
  summarize(count = n(), min = min(issuedate), max = max(issuedate))

waterloo %>%
  filter(str_detect(reason, regex("night|between|AM", ignore_case = TRUE))) %>%
  filter(! str_detect(reason, "MARKED|PAY AND DISPLAY")) %>%
  mutate(hour = hour(issuedate)) %>%
  group_by(reason, hour) %>%
  summarize(count = n()) %>%
  mutate(prop = round(count / sum(count), 3)) %>%
  arrange(reason, hour, count) %>%
  View()

waterloo %>%
  mutate(time = paste0(today(), " ", hour(issuedate), ":", minute(issuedate), ":", second(issuedate))) %>%
  mutate(time = parse_date_time(time, "Y-m-d H:M:S"))

waterloo %>%
  ggplot(aes(x = time)) +
  geom_point(stat = "count")

waterloo %>%
  count_group(time) %>%
  ggplot(aes(x = time, y = count)) +
  geom_point() +
  geom_smooth(method = "lm")

waterloo %>%
  count_group(minute) %>%
  ggplot(aes(x = minute, y = count)) +
  geom_point() +
  geom_smooth()

waterloo %>%
  ggplot(aes(x = hour)) +
  geom_bar(stat = "count")

waterloo %>%
  ggplot(aes(x = hour)) +
  geom_bar(aes(y = (..count..)/sum(..count..))) + 
  scale_y_continuous(labels=scales::percent)

  
