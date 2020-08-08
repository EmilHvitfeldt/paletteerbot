library(tidyverse)
library(lubridate)
library(paletteer)
set.seed(1234)

# Last run on 2020-08-07

pokemon_colors <- palettes_d_names %>%
  filter(package == "palettetown") %>%
  mutate(slug = glue::glue("{package}::{palette}"))

discrete_colors <- palettes_d_names %>%
  filter(package != "palettetown") %>%
  mutate(slug = glue::glue("{package}::{palette}"))

continuous_colors <- palettes_c_names %>%
  mutate(slug = glue::glue("{package}::{palette}"))

schedule <- data.frame(date = Sys.Date() + 3:146) %>%
  mutate(weekday = weekdays(date),
         daytype = case_when(weekday == "Monday" ~ "pokemon",
                             weekday == "Friday" ~ "continuous",
                             TRUE ~ "discrete"))

schedule_split <- split(schedule, schedule$daytype)

schedule_split$continuous <- schedule_split$continuous %>%
  mutate(slug = sample(continuous_colors$slug, n()))

schedule_split$discrete <- schedule_split$discrete %>%
  mutate(slug = sample(discrete_colors$slug, n()))

schedule_split$pokemon <- schedule_split$pokemon %>%
  mutate(slug = sample(pokemon_colors$slug, n()))

schedule <- bind_rows(schedule_split) %>%
  arrange(date)

write_rds(schedule, "data/schedule.rds")
write_rds(pokemon_colors, "data/pokemon_colors.rds")
write_rds(discrete_colors, "data/discrete_colors.rds")
write_rds(continuous_colors, "data/continuous_colors.rds")

