#' f1
#' @export
f1 <- function(actual, pred) {
  pr <- Metrics::precision(actual, pred)
  rc <- Metrics::recall(actual, pred)
  pr*rc/(pr+rc)
}


#' query_rate
#' @export
query_rate <- function(actual, pred){
  mean(pred)
}

#' metrics_binary
#' @export
metrics_binary <- function(actual, pred){
  
  list(
    precision = Metrics::precision,
    recall = Metrics::recall,
    accuracy = Metrics::accuracy,
    ce = Metrics::ce,
    f1 = f1,
    query_rate = query_rate
  ) %>% 
    purrr::imap_dfc(~{ mean(.x(actual, pred)) })
  
}

#' get_cutoff_df
#' @export
get_cutoff_df <- function(.data, actual){
  dplyr::tibble(thres = seq(0, 1,length.out = 100)) %>%
    split(1:nrow(.)) %>%
    purrr::map_dfr(~{
      df <- .data %>% select(actual = {{actual}}, prob) %>%
        dplyr::mutate(pred = ifelse(prob > .x$thres, 1, 0))
      
      metrics_binary(df$actual, df$pred) %>% mutate(thres = .x$thres)
    }) %>%
    tidyr::gather(metric, value, -thres)
}

#' ax_plot_cutoff
#' @export
ax_plot_cutoff <- function(.data){
  .data %>%
    apexcharter::apex(type = "line", mapping = apexcharter::aes(x = thres, y = value, color = metric)) %>%
    apexcharter::ax_legend(show = F) %>%
    apexcharter::ax_xaxis(title = list(text = "Probability Threshold"), min = 0, max = 1, tickAmount = 5, labels = list(formatter = apexcharter::JS("function(val) {return val.toFixed(2);}"))) %>%
    apexcharter::ax_yaxis(title = list(text = "Values"), tickAmount = 5, labels = list(formatter = apexcharter::JS("function(val) {return val.toFixed(2);}"))) %>%
    apexcharter::ax_tooltip(shared = T)
}