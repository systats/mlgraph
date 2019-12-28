#' gg_plot_roc2
#'
#' @export
# get_dens_df <- function(actual, prob){
#   dplyr::tibble(actual, prob) %>%
#     split(.$actual) %>%
#     purrr::imap(~{ density(.x$prob) }) %>%
#     purrr::imap_dfr(~as.data.frame(.x[c("x", "y")]) %>% dplyr::mutate(actual = .y))
# }

get_dens_df <- function(.data, actual, prob){

  probs <- .data %>% select(contains("prob"))

  .data %>%
    dplyr::select(actual = {{actual}}) %>%
    dplyr::bind_cols(probs) %>%
    split(.$actual) %>%
    purrr::imap(~{ .x %>% rename("prob" = paste0("prob", .y)) }) %>%
    purrr::imap(~{ density(.x$prob) }) %>%
    purrr::imap_dfr(~as.data.frame(.x[c("x", "y")]) %>% dplyr::mutate(actual = .y)) %>%
    dplyr::as_tibble()
  # if(ncol(probs) > 2) {
  #
  # } else {
  #   .data %>%
  #     dplyr::select(actual = {{actual}}, prob = .data$prob1) %>%
  #     split(.$actual) %>%
  #     purrr::imap(~{ density(.x$prob) }) %>%
  #     purrr::imap_dfr(~as.data.frame(.x[c("x", "y")]) %>% dplyr::mutate(actual = .y)) %>%
  #     dplyr::as_tibble()
  # }

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
  n_group <- length(unique(.data$actual))
  .data %>%
    apexcharter::apex(type = "line", mapping = apexcharter::aes(x = x, y = y, group = actual), ...) %>%
    apexcharter::ax_legend(show = F) %>%
    apexcharter::ax_colors(ggthemes::hc_pal()(n_group)) %>%
    apexcharter::ax_xaxis(title = list(text = "Probability"), min = 0, max = 1, tickAmount = 5, labels = list(formatter = apexcharter::JS("function(val) {return val.toFixed(1);}"))) %>%
    apexcharter::ax_yaxis(title = list(text = "Density"), min = 0, tickAmount = 5, labels = list(formatter = apexcharter::JS("function(val) {return val.toFixed(1);}")))
}

