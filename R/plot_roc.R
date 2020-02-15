#' get_roc_df
#'
#' @export
get_roc_df <- function(.data, actual){

  probs <- .data %>% select(contains("prob"))

  if(ncol(probs) > 2) {
    
    .data %>%
      dplyr::select(actual = {{actual}}, contains("prob")) %>%
      dplyr::mutate_at(1, as.factor) %>%
      split(.$actual) %>%
      purrr::map_dfr(~{
        yardstick::roc_curve(.x, actual, dplyr::contains("prob"))
      }) %>%
      dplyr::mutate(actual = .level) %>%
      dplyr::mutate(actual = as.factor(actual), fpr = 1 - sensitivity) %>%
      dplyr::rename(thres = .threshold)
      
  } else {
    
    df <- .data %>%
      dplyr::select(actual = {{actual}}, prob)
    
    unique(df$actual) %>%
      purrr::map_dfr(~{
        df %>%
          dplyr::mutate(actual = as.factor(ifelse(actual == .x, 1, 0))) %>%
          yardstick::roc_curve(actual, prob) %>%
          dplyr::mutate(actual = .x)
      }) %>%
      dplyr::mutate(actual = as.factor(actual), fpr = 1 - sensitivity) %>%
      dplyr::rename(thres = .threshold)
  }
}


#' gg_plot_roc
#'
#' @export
gg_plot_roc <- function(.data){
  .data %>%
    ggplot2::ggplot(aes(x = fpr, y = specificity, colour = actual)) +
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
    highcharter::hchart("line", highcharter::hcaes(x = fpr, y = specificity, group = actual)) %>%
    highcharter::hc_xAxis(min = 0, max = 1, title = list(text = "FPR (1 - Sensitivity)")) %>%
    highcharter::hc_yAxis(min = 0, max = 1, title = list(text = "TPR (Specificity)")) %>%
    highcharter::hc_add_series(tibble(x = 0:1, y = 0:1), color = "gray") %>%
    highcharter::hc_legend(enabled = F)
}

#' ax_plot_roc
#'
#' @export
ax_plot_roc <- function(.data){
  .data %>%
    apexcharter::apex(type = "line", mapping = apexcharter::aes(x = fpr, y = specificity, color = actual)) %>%
    apexcharter::ax_legend(show = F) %>%
    apexcharter::ax_xaxis(title = list(text = "FPR (1 - Sensitivity)"), min = 0, max = 1, tickAmount = 5, labels = list(formatter = apexcharter::JS("function(val) {return val.toFixed(2);}"))) %>%
    apexcharter::ax_yaxis(title = list(text = "TPR (Specificity)"), tickAmount = 5, labels = list(formatter = apexcharter::JS("function(val) {return val.toFixed(2);}"))) %>%
    apexcharter::ax_tooltip(shared = T)
}

