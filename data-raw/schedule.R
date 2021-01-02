library(tidyverse)
library(lubridate)
library(paletteer)
set.seed(1234)

# Last run on 2021-01-01

pokemon_colors <- palettes_d_names %>%
  filter(package == "palettetown") %>%
  mutate(slug = glue::glue("{package}::{palette}"))

discrete_colors <- palettes_d_names %>%
  filter(package != "palettetown") %>%
  mutate(slug = glue::glue("{package}::{palette}"))

continuous_colors <- palettes_c_names %>%
  mutate(slug = glue::glue("{package}::{palette}"))

schedule <- data.frame(date = date("2021-01-01") + 0:364) %>%
  mutate(weekday = weekdays(date),
         daytype = case_when(weekday == "Monday" ~ "pokemon",
                             weekday == "Friday" ~ "continuous",
                             TRUE ~ "discrete"))

schedule_split <- split(schedule, schedule$daytype)

schedule_split$continuous <- continuous_colors %>%
  add_count(package) %>%
  mutate(n = sqrt(n)) %>%
  sample_n(size = nrow(schedule_split$continuous), wt = n) %>%
  select(slug) %>%
  bind_cols(schedule_split$continuous)

schedule_split$discrete <- discrete_colors %>%
  add_count(package) %>%
  mutate(n = sqrt(n)) %>%
  sample_n(size = nrow(schedule_split$discrete), wt = n) %>%
  select(slug) %>%
  bind_cols(schedule_split$discrete)

schedule_split$pokemon <- pokemon_colors %>%
  add_count(package) %>%
  mutate(n = sqrt(n)) %>%
  sample_n(size = nrow(schedule_split$pokemon), wt = n) %>%
  select(slug) %>%
  bind_cols(schedule_split$pokemon)


schedule <- bind_rows(schedule_split) %>%
  arrange(date)

write_rds(schedule, "data/2019_schedule.rds")
write_rds(pokemon_colors, "data/pokemon_colors.rds")
write_rds(discrete_colors, "data/discrete_colors.rds")
write_rds(continuous_colors, "data/continuous_colors.rds")

