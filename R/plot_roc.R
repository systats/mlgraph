#' get_roc_df
# get_roc_df <- function(actual, prob){
#   dplyr::tibble(actual, prob) %>%
#     dplyr::mutate_at(1, as.factor) %>%
#     yardstick::roc_curve(actual, prob)
# }
#' @export
get_roc_df <- function(.data, actual){

  probs <- .data %>% select(contains("prob"))

  if(ncol(probs) > 2) {
    
    out <- .data %>%
      dplyr::select(actual = {{actual}}, contains("prob")) %>%
      dplyr::mutate_at(1, as.factor) %>%
      yardstick::roc_curve(actual, contains("prob"))
      dplyr::as_tibble()
      
  } else {
    out <- .data %>%
      dplyr::select(actual = {{actual}}, prob) %>%
      dplyr::mutate_at(1, as.factor) %>%
      yardstick::roc_curve(actual, prob)

    out$.level <- 1
  }

  return(dplyr::as_tibble(out))
}

#' gg_plot_roc
#'
#' @export
gg_plot_roc <- function(.data){
  .data %>%
    dplyr::mutate(.level = as.factor(.level)) %>%
    ggplot2::ggplot(aes(x = 1 - sensitivity, y = specificity, colour = .level)) +
    ggplot2::geom_abline(slope = 1, intercept = 0, color = "gray50", linetype = "dashed") +
    ggplot2::geom_line() +
    ggthemes::theme_hc() +
    ggthemes::scale_colour_hc() +
    ggplot2::coord_equal()+
    ggplot2::labs(x = "FPR (1 - Sensitivity)", y = "TPR (Specificity)") +
    theme(legend.position = "none")
}

#' gg_plot_roc2
#'
#' @export
gg_plot_roc2 <- function(actual, prob){
  dplyr::tibble(actual, prob)  %>%
    ggplot2::ggplot(aes(d = actual, m = prob)) +
    plotROC::geom_roc() +
    ggthemes::theme_hc() +
    ggplot2::geom_abline(slope = 1, intercept = 0, color = "gray50", linetype = "dashed") +
    ggplot2::coord_equal() +
    ggplot2::labs(x = "FPR (1 - Sensitivity)", y = "TPR (Specificity)") +
    theme(legend.position = "none")
}

#' hc_plot_roc
#'
#' @export
hc_plot_roc <- function(.data){
  .data %>%
    highcharter::hchart("line", highcharter::hcaes(x = 1 - sensitivity, y = specificity, group = .level)) %>%
    highcharter::hc_xAxis(min = 0, max = 1, title = list(text = "FPR (1 - Sensitivity)")) %>%
    highcharter::hc_yAxis(min = 0, max = 1, title = list(text = "TPR (Specificity)")) %>%
    highcharter::hc_add_series(tibble(x = 0:1, y = 0:1), color = "gray") %>%
    highcharter::hc_legend(enabled = F)
}

#' ax_plot_roc
#'
#' @export
ax_plot_roc <- function(.data, type = "line", ...){
  n_group <- length(unique(.data$.level))

  #diag <- tibble(sensitivity = seq(0, 1, length.out = 100), specificity = seq(1, 0, length.out = 100), .level = "diag")
  .data %>%
    #dplyr::mutate(type = "curve") %>%
    #dplyr::bind_rows(diag) %>%
    apexcharter::apex(type = type, mapping = apexcharter::aes(x = 1 - sensitivity, y = specificity, color = .level), ...) %>%
    apexcharter::ax_legend(show = F) %>%
    apexcharter::ax_colors(ggthemes::hc_pal()(n_group)) %>%
    apexcharter::ax_xaxis(title = list(text = "FPR (1 - Sensitivity)"), min = 0, max = 1, tickAmount = 5, labels = list(formatter = apexcharter::JS("function(val) {return val.toFixed(1);}"))) %>%
    apexcharter::ax_yaxis(title = list(text = "TPR (Specificity)"), min = 0, max = 1, tickAmount = 5, labels = list(formatter = apexcharter::JS("function(val) {return val.toFixed(1);}")))
}

