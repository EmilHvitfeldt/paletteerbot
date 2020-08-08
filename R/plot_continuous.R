plot_continuous <- function(pal) {
  bar_chart <- tibble(x = rpois(15, 10), y = seq_len(15)) %>%
    ggplot(aes(y, x, fill = y)) +
    geom_col(color = "grey31") +
    scale_fill_paletteer_c(pal$slug) +
    theme_void() +
    guides(fill = "none")

  usa_chart <- usa_plot +
    scale_fill_paletteer_c(pal$slug)

  scatter_chart <- tibble(x = runif(250),
                          y = runif(250),
                          group = (x + rnorm(250, sd = 0.1)) *
                                  (y + rnorm(250, sd = 0.1))) %>%
    ggplot(aes(x, y, color = group)) +
    geom_point() +
    scale_color_paletteer_c(pal$slug) +
    theme_void() +
    guides(color = "none")


  hex_chart <- ggplot(data.frame(x = rnorm(1e4), y = rnorm(1e4)),
         aes(x = x, y = y)) +
    geom_hex() +
    theme_void() +
    guides(fill = "none") +
    coord_fixed() +
    scale_fill_paletteer_c(pal$slug)

  stacked_chart <- map_dfr(seq_len(10),
                           ~tibble(x = seq_len(25),
                                   y = rpois(25, 10),
                                   group = as.character(.x))) %>%
    group_by(x) %>%
    mutate(y = y / sum(y)) %>%
    ggplot(aes(x = x, y = y, fill = group)) +
    geom_area() +
    scale_fill_manual(values = paletteer_c(pal$slug, 10)) +
    theme_void() +
    guides(fill = "none")

  network_chart <- play_islands(10, 20, 0.25, 1) %>%
    mutate(community = group_infomap()) %>%
    ggraph(layout = 'nicely') +
    geom_edge_link(color = "grey69", alpha = 0.5) +
    geom_node_point(aes(color = community)) +
    theme_graph() +
    guides(color = "none") +
    scale_color_paletteer_c(pal$slug)

  (bar_chart + usa_chart + scatter_chart) /
    (stacked_chart + hex_chart  + network_chart) +
    plot_annotation(title = paste0('"', pal$palette, '" palette from {', pal$package, "}"),
                    caption = "@paletteerBot", theme = theme(plot.title = element_text(hjust = 0.5)))
}
