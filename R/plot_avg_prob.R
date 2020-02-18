#' get_avg_df
#' @export 
get_avg_df <- function(.data, actual){
  .data %>%
    dplyr::rename(actual = {{actual}}) %>%
    dplyr::mutate(prob_class = dplyr::ntile(prob, 10)) %>%
    dplyr::group_by(prob_class) %>%
    dplyr::summarise(
      accuracy = mean(pred == actual),
      f1 = f1(pred, actual),
      min = min(prob),
      max = max(prob)
    ) %>%
    dplyr::ungroup() %>%
    dplyr::mutate_all(round, 2) %>%
    dplyr::mutate(
      prob_class = glue::glue("{prob_class}: {min}-{max}") %>% 
        str_replace_all("0\\.", ".")
    ) %>%
    dplyr::select(prob_class, accuracy, f1) %>%
    tidyr::gather(var, value, -prob_class)
}

#' ax_plot_avg
#' @export 
ax_plot_avg <- function(.data){
  .data %>%
    apexcharter::apex(type = "line", mapping = aes(x = prob_class, y = value, colour = var)) %>% 
    apexcharter::ax_yaxis(min = 0, max = 1)
}