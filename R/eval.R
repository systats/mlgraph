#' save_rds
#' @export
save_rds <- function(file, name, path) saveRDS(file, file = glue::glue("{path}/{name}.rds"))

#' eval_classifier
#' @export
eval_classifier <- function(.data, actual, pred, prob = "prob", path = NULL){

  df <- .data %>% select(actual = {{actual}}, pred = {{pred}}, contains("prob"))

  confusion_pos <- purrr::possibly(mlgraph::get_confusion_df, NULL)
  roc_pos <- purrr::possibly(mlgraph::get_roc_df, NULL)
  dens_pos <- purrr::possibly(mlgraph::get_dens_df, NULL)

  out <- list(
    confusion = confusion_pos(.data, {{actual}}, {{pred}}),
    roc = roc_pos(.data, {{actual}}, contains("prob")),# %>% mutate(.threshold = round(.threshold, 2)) %>% group_by(.threshold) %>% slice(1) %>% ungroup,
    dens = dens_pos(.data, {{actual}}, contains("prob"))
  )

  if(!is.null(path)) {
    save_rds(out, "evals", path)
  } else {
    return(out)
  }
}
