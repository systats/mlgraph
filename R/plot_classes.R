#' get_classes_df
#' @export
get_classes_df <- function(.data, actual){
  .data %>%
    dplyr::rename(actual = {{actual}}) %>%
    dplyr::count(actual, pred, .drop = F) %>%
    dplyr::mutate_at(1:2, as_factor) 
}

#' ax_plot_classes
#' @export
ax_plot_classes <- function(.data){
  .data %>%
    apexcharter::apex(type = "column", mapping = aes(x = actual, y = n, fill = pred)) %>%
    apexcharter::ax_chart(stacked = T) %>%
    apexcharter::ax_tooltip(shared = T) %>%
    apexcharter::ax_legend(show = F) %>%
    apexcharter::ax_xaxis(title = list(text = "Actual")) %>%
    apexcharter::ax_yaxis(title = list(text = "Predicted"))
}