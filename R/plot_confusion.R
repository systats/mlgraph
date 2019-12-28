#' get_confusion_df
#'
#' @export
get_confusion_df <- function(.data, actual, pred){


  tab <- .data %>% dplyr::select(actual = {{actual}}, pred = {{pred}})
  lvls <- sort(unique(c(tab$actual, tab$pred)))

  tab %>%
    dplyr::mutate_all(factor, lvls) %>%
    dplyr::group_by(actual, pred, .drop = F) %>%
    dplyr::tally() %>%
    dplyr::ungroup() %>%

    dplyr::group_by(actual, .drop = F) %>%
    dplyr::mutate(n_actual = sum(n)) %>%
    dplyr::mutate(perc_actual = n/n_actual) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(perc_all = n/sum(n)) %>%
    dplyr::mutate_if(is.numeric, round, 3) %>%
    dplyr::as_tibble()

}

#' gg_plot_confusion
#'
#' @export
gg_plot_confusion <- function(.data){
  .data %>%
    dplyr::mutate_at(1:2, as.factor) %>%
    dplyr::mutate(label = glue::glue("{n}\n{perc_all}")) %>%
    ggplot2::ggplot(ggplot2::aes(pred, actual, fill = n)) +
    ggplot2::geom_tile() +
    ggplot2::scale_fill_gradient(low = "#e7ecf6", high = "#224ea7")+
    ggplot2::coord_equal() +
    ggplot2::labs(y = "Actual", x = "Predicted") +
    ggplot2::geom_text(ggplot2::aes(label = label)) +
    ggthemes::theme_hc() +
    ggplot2::theme(legend.position = "none") +
    ggplot2::guides(colour = F, fill = F)
}

#' hc_plot_confusion
#'
#' @export
hc_plot_confusion <- function(.data){
  .data %>%
    highcharter::hchart(
      "heatmap",
      highcharter::hcaes(x = pred, y = actual, value = n),
      dataLabels = list(enabled = T)
    ) %>%
    highcharter::hc_legend(enabled = F) %>%
    highcharter::hc_xAxis(title = list(text = "Predicted")) %>%
    highcharter::hc_yAxis(title = list(text = "Actual"))
}

#' ax_plot_confusion
#'
#' @export
ax_plot_confusion <- function(.data, ...){
  .data %>%
    apexcharter::apex(type = "heatmap", mapping = apexcharter::aes(x = pred, y = actual, fill = n), colors = "#224ea7", ...) %>%
    #apexcharter::ax_dataLabels(enabled = FALSE) %>%
    apexcharter::ax_colors("#224ea7") %>%
    apexcharter::ax_xaxis(title = list(text = "Predicted")) %>%
    apexcharter::ax_yaxis(title = list(text = "Actual"))
}
