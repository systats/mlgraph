#' get_rp_df
#'
#' @export
get_rp_df <- function(actual, prob){
  dplyr::tibble(actual, prob) %>%
    dplyr::mutate_at(1, as.factor) %>%
    dplyr::mutate(prob = 1-prob) %>%
    yardstick::pr_curve(actual, prob) %>%
    dplyr::as_tibble()
}

#' gg_plot_density
#'
#' @export
gg_plot_rp <- function(.data){
  .data %>%
    ggplot2::ggplot(aes(x = recall, y = precision)) +
    ggplot2::geom_abline(slope = -.5, intercept = 1, color = "gray50", linetype = "dashed") +
    ggplot2::geom_line() +
    ggplot2::coord_equal() +
    ggthemes::theme_hc() +
    ggplot2::labs(x = "Recall", y = "Precision") +
    theme(legend.position = "none")
}

#' hc_plot_rp
#'
#' @export
hc_plot_rp <- function(.data){
  .data %>%
    highcharter::hchart("line", highcharter::hcaes(x = recall, y = precision)) %>%
    highcharter::hc_xAxis(min = 0, max = 1, title = list(text = "Recall")) %>%
    highcharter::hc_yAxis(min = 0, max = 1, title = list(text = "Precision")) %>%
    apexcharter::ax_legend(show = F) %>%
    highcharter::hc_add_series(tibble(x = 1:0, y = 0:1), color = "gray")
}

#' ax_plot_rp
#'
#' @export
ax_plot_rp <- function(.data, type = "area"){
  diag <- tibble(recall = seq(0, 1, length.out = 100), precision = seq(1, 0, length.out = 100), type = "diag")
  .data %>%
    dplyr::mutate(type = "curve") %>%
    dplyr::bind_rows(diag) %>%
    apex(type = type, mapping = aes(x = recall, y = precision, fill = type)) %>%
    apexcharter::ax_legend(show = F) %>%
    apexcharter::ax_colors("#7cb5ec", "#434348") %>%
    apexcharter::ax_xaxis(title = list(text = "Recall"), min = 0, max = 1, tickAmount = 5, labels = list(formatter = apexcharter::JS("function(val) {return val.toFixed(1);}"))) %>%
    apexcharter::ax_yaxis(title = list(text = "Precision"), min = 0, max = 1, tickAmount = 5, labels = list(formatter = apexcharter::JS("function(val) {return val.toFixed(1);}")))
}
