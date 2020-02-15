#' get_dens_df
#'
#' @export
get_density_df <- function(.data, actual){

  .data %>%
    dplyr::select(actual = {{actual}}, contains("prob")) %>%
    tidyr::gather(var, prob, -actual) %>%
    split(.$actual) %>%
    purrr::imap(~{ density(.x$prob) }) %>%
    purrr::imap_dfr(~as.data.frame(.x[c("x", "y")]) %>% dplyr::mutate(actual = .y)) %>%
    dplyr::as_tibble()
}

#' gg_plot_density
#'
#' @export
gg_plot_density <- function(.data){
  n_group <- length(unique(.data$actual))
  .data %>%
    dplyr::mutate(actual = as.factor(actual)) %>%
    ggplot2::ggplot(ggplot2::aes(x, y, colour = actual)) +
    ggplot2::geom_line(alpha=.7) +
    ggplot2::xlim(0, 1) +
    ggthemes::scale_colour_hc() +
    ggthemes::theme_hc() +
    #scale_colour_manual(values = ggthemes::hc_pal()(n_group)) +
    theme(legend.position = "none")
}

#' hc_plot_density
#'
#' @export
hc_plot_density <- function(.data){
  .data %>%
    split(.$actual) %>%
    purrr::reduce(.f = highcharter::hc_add_series, .init = highcharter::highchart()) %>%
    highcharter::hc_xAxis(min = 0, max = 1, title = list(text = "Probability")) %>%
    highcharter::hc_yAxis(min = 0, title = list(text = "Density")) %>%
    highcharter::hc_legend(enabled = F) 
}

#' ax_plot_density
#'
#' @export
ax_plot_density <- function(.data, ...){
  .data %>%
    apexcharter::apex(type = "line", mapping = apexcharter::aes(x = x, y = y, color = actual)) %>%
    apexcharter::ax_legend(show = F) %>%
    apexcharter::ax_xaxis(title = list(text = "Probability"), min = 0, max = 1, tickAmount = 5, labels = list(formatter = apexcharter::JS("function(val) {return val.toFixed(2);}"))) %>%
    apexcharter::ax_yaxis(title = list(text = "Density"), tickAmount = 5, labels = list(formatter = apexcharter::JS("function(val) {return val.toFixed(2);}"))) %>%
    apexcharter::ax_tooltip(shared = T)
}

