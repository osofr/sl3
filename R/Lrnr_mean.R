#' Intercept Model Fits
#'
#' This learner provides fitting procedures for intercept models. Such models
#' predict the outcome variable simply as the mean of the outcome vector.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @keywords data
#' @return Learner object with methods for training and prediction. See \code{\link{Lrnr_base}} for documentation on learners.
#' @format \code{\link{R6Class}} object.
#' @family Learners
#' 
#' @section Parameters:
#' \describe{
#'   \item{\code{...}}{Not used}
#' }
#' @template common_parameters
#' @importFrom assertthat assert_that is.count is.flag
Lrnr_mean <- R6Class(classname = "Lrnr_mean", inherit = Lrnr_base,
                     portable = TRUE, class = TRUE,
  public = list(
    initialize = function(...) {
      params <- list(...)
      super$initialize(params = params, ...)
    },
    print = function() {
      print(self$name)
    }
  ),
  private = list(
    .properties = c("continuous", "binomial", "categorical", "weights"),
    .train = function(task) {
      outcome_type <- self$get_outcome_type(task)
      y <- outcome_type$format(task$Y)
      weights <- task$weights
      
      if(outcome_type$type == "categorical"){
        y_levels <- outcome_type$levels
        means <- sapply(y_levels, function(level)weighted.mean(y==level, weights))
        fit_object <- list(mean = pack_predictions(matrix(means, nrow=1)))
        
      } else {
        fit_object <- list(mean = weighted.mean(y, weights))  
      }
      
      return(fit_object)
    },
    .predict = function(task = NULL) {
      predictions <- rep(private$.fit_object$mean, task$nrow)
      return(predictions)
    }
  ),
)

