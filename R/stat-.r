Stat <- proto2(
  class = "Stat",
  inherit = TopLevel,
  members = list(
    objname = "",

    desc = "",

    # Should the values produced by the statistic also be transformed
    # in the second pass when recently added statistics are trained to
    # the scales
    retransform = TRUE,

    default_geom = function(self) Geom,

    default_aes = function(self) aes(),

    default_pos = function(self) self$default_geom()$default_pos(),

    required_aes = c(),

    aesthetics = list(),

    calculate = function(self, data, scales, ...) {},

    calculate_groups = function(self, data, scales, ...) {
      if (empty(data)) return(data.frame())

      force(data)
      force(scales)

      # # Alternative approach: cleaner, but much slower
      # # Compute statistic for each group
      # stats <- ddply(data, "group", function(group) {
      #   self$calculate(group, scales, ...)
      # })
      # stats$ORDER <- seq_len(nrow(stats))
      #
      # # Combine statistics with original columns
      # unique <- ddply(data, .(group), uniquecols)
      # stats <- merge(stats, unique, by = "group")
      # stats[stats$ORDER, ]

      groups <- split(data, data$group)
      stats <- lapply(groups, function(group)
        self$calculate(data = group, scales = scales, ...))

      stats <- mapply(function(new, old) {
        if (empty(new)) return(data.frame())
        unique <- uniquecols(old)
        missing <- !(names(unique) %in% names(new))
        cbind(
          new,
          unique[rep(1, nrow(new)), missing,drop=FALSE]
        )
      }, stats, groups, SIMPLIFY=FALSE)

      do.call(rbind.fill, stats)
    },


    # print = function(self, newline=TRUE) {
    #   cat("stat_", self$objname ,": ", sep="") # , clist(self$parameters())
    #   if (newline) cat("\n")
    # },

    parameters = function(self) {
      # proto2 TODO: better way of getting formals for self$calculate
      params <- formals(environment(self$calculate)$res)
      params[setdiff(names(params), c("self", "super", "data", "scales"))]
    },

    class = function(self) "stat"
  )
)
