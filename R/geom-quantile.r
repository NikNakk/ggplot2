#' Add quantile lines from a quantile regression.
#'
#' This can be used as a continuous analogue of a geom_boxplot.
#'
#' @section Aesthetics:
#' \Sexpr[results=rd,stage=build]{ggplot2:::rd_aesthetics("geom", "quantile")}
#'
#' @export
#' @inheritParams geom_point
#' @inheritParams geom_path
#' @seealso See \code{\link{stat_quantile}} for examples.
#' @examples
#' # See stat_quantile for examples
geom_quantile <- function (mapping = NULL, data = NULL, stat = "quantile",
  position = "identity", lineend = "butt", linejoin = "round", linemitre = 1,
  na.rm = FALSE, show_guide = NA, inherit.aes = TRUE, ...)
{
  Layer$new(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomQuantile,
    position = position,
    show_guide = show_guide,
    inherit.aes = inherit.aes,
    geom_params = list(
      lineend = lineend,
      linejoin = linejoin,
      linemitre = linemitre
    ),
    params = list(...)
  )
}

GeomQuantile <- proto2(
  class = "GeomQuantile",
  inherit = GeomPath,
  members = list(
    objname = "quantile",

    default_stat = function(self) StatQuantile,

    default_aes = function(self) {
      defaults(
        aes(weight = 1, colour = "#3366FF", size = 0.5),
        GeomPath$default_aes()
      )
    },

    guide_geom = function(self) "path"
  )
)
