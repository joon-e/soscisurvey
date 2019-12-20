theme_set(theme_bw())

data %>%
  select(GS01_01) %>%
  mutate_all(labelled::user_na_to_na) %>%
  ggplot(aes(GS01_01)) +
  geom_bar() +
  coord_flip()


plot_values <- function(data, var) {

  # Check attributes

  # Prepare
  plot_data <- data %>%
    dplyr::select({{ var }}) %>%
    dplyr::mutate_all(labelled::user_na_to_na) %>%
    dplyr::mutate(
      value = labelled::remove_val_labels({{ var }}),
      label = labelled::to_factor({{ var }})
    ) %>%
    droplevels() %>%
    tidyr::drop_na()

  # Plot
  plot_data %>%
    ggplot(aes(value)) +
    geom_bar() +
    labs(x = "", y = "") +
    theme(
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank()
    )
}


plot_values(data, GS01_01)
