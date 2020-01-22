#' save_rds
#' @export
save_rds <- function(file, name, path) saveRDS(file, file = glue::glue("{path}/{name}.rds"))

#' eval_classifier
#' @export
eval_classifier <- function(.data, actual, path = NULL){

  confusion_pos <- purrr::possibly(mlgraph::get_confusion_df, NULL)
  roc_pos <- purrr::possibly(mlgraph::get_roc_df, NULL)
  dens_pos <- purrr::possibly(mlgraph::get_dens_df, NULL)

  out <- list(
    confusion = confusion_pos(.data, {{actual}}),
    roc = roc_pos(.data, {{actual}}),
    dens = dens_pos(.data, {{actual}})
  )

  if(!is.null(path)) {
    save_rds(out, "evals", path)
  } else {
    return(out)
  }
}



#' model_eda
#' @export
model_eda <- function(self){
  if(self$meta$task == "linear"){
    list()
  } else if(self$meta$task == "binary") {
    model_eval(self, self$process$ask_y())
  }
}

