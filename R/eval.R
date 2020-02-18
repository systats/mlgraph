#' save_rds
#' @export
save_rds <- function(file, name, path) saveRDS(file, file = glue::glue("{path}/{name}.rds"))

#' eval_classifier
#' @export
eval_classifier <- function(params, preds, path = NULL){
  
  out <- list(
    confusion = purrr::possibly(mlgraph::get_confusion_df, NULL),
    classes = purrr::possibly(mlgraph::get_classes_df, NULL),
    roc = purrr::possibly(mlgraph::get_roc_df, NULL),
    cutoff = purrr::possibly(mlgraph::get_cutoff_df, NULL),
    density = purrr::possibly(mlgraph::get_density_df, NULL),
    avg = purrr::possibly(mlgraph::get_avg_df, NULL)
  ) %>%
    purrr::imap(~{
      do.call(.x, list(.data = preds, actual = params[[.y]]))
    }) %>% 
    purrr::compact()

  if(!is.null(path)) {
    save_rds(out, "evals", path)
  } else {
    return(out)
  }
}

#' plot_classifier
#' @export
plot_classifier <- function(li){
  li %>% 
    imap(~{
      do.call(glue::glue("ax_plot_{.y}"), list(.data = .x))
    })
}