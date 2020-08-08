library(paletteer)
library(tidyverse)
library(lubridate)
library(patchwork)
library(tidygraph)
library(ggraph)
library(rtweet)
library(glue)
library(emo)

lapply(list.files("./R", full.names = TRUE), source)

continuous_colors <- readRDS("data/continuous_colors.rds")
discrete_colors <- readRDS("data/discrete_colors.rds")
pokemon_colors <- readRDS("data/pokemon_colors.rds")
schedule <- readRDS("data/schedule.rds")
usa_plot <- readRDS("data/usa_plot.rds")

Today <- today()

Today_palette <- schedule %>%
  filter(date == Today)

chart <- if (Today_palette$daytype == "discrete") {
  discrete_colors %>%
    filter(slug == Today_palette$slug) %>%
    plot_discrete()
} else if (Today_palette$daytype == "pokemon") {
  pokemon_colors %>%
    filter(slug == Today_palette$slug) %>%
    plot_discrete()
} else if (Today_palette$daytype == "continuous") {
  continuous_colors %>%
    filter(slug == Today_palette$slug) %>%
    plot_continuous()
}

ggsave("chart.png", chart, width = 4, height = 2, dpi = 300, scale = 2)

paletteer_token <- function() {
  rtweet::create_token(
    "paletteerbot",
    consumer_key = Sys.getenv("PALBOT_CONSUMER_KEY"),
    consumer_secret = Sys.getenv("PALBOT_CONSUMER_SECRET"),
    access_token = Sys.getenv("PALBOT_ACCESS_TOKEN"),
    access_secret = Sys.getenv("PALBOT_ACCESS_SECRET"),
    set_renv = FALSE
  )
}

post_tweet(daily_tweet(Today_palette), media = "chart.png", token = paletteer_token())
