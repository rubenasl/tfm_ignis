# ignis.R

Ignis <- new.env()

Ignis$start <- function() {
  message("[Ignis] Starting session...")
}

Ignis$stop <- function() {
  message("[Ignis] Stopping session...")
}

IProperties <- setRefClass(
  "IProperties",
  fields = list(properties = "list"),
  methods = list(
    initialize = function() {
      properties <<- list()
    },
    set = function(key, value) {
      properties[[key]] <<- value
    },
    get = function(key) {
      return(properties[[key]])
    },
    asList = function() {
      return(properties)
    },
    `[[` = function(key) {
      return(properties[[key]])
    },
    `[[<-` = function(key, value) {
      properties[[key]] <<- value
    }
  )
)

ICluster <- setRefClass(
  "ICluster",
  fields = list(props = "IProperties"),
  methods = list(
    initialize = function(properties = props) {
      if (!is.null(properties)) {
        props <<- properties
        message("[ICluster] Cluster created with properties:")
        print(props$asList())  # 👈 Esto imprime todo el contenido
      } else {
        props <<- IProperties$new()
        message("[ICluster] No properties provided. Using empty defaults.")
      }
    }
  )
)



IWorker <- setRefClass(
  "IWorker",
  fields = list(cluster = "ICluster", lang = "character"),
  methods = list(
    initialize = function(cluster, language = "r") {
      cluster <<- cluster
      lang <<- language
      message(paste("[IWorker] Worker initialized with language:", 
language))
    },

textFile = function(filename) {
  message(paste("[IWorker] Loading text file:", filename))
  lines <- as.list(readLines(filename))  # 🔧 Conversión a lista
  return(IData$new(data = lines))        # ✅ Llamada correcta al constructor
}

  )
)

IData <- setRefClass(
  "IData",
  fields = list(data = "list"),
  methods = list(
    flatmap = function(f) {
      result <- list()
      for (item in data) {
        mapped <- f(item)
        result <- c(result, mapped)
      }
      return(IData$new(data = result))
    },
    toPair = function() {
      return(IData$new(data = data))
    },
    reduceByKey = function(f) {
      result <- list()
      for (pair in data) {
        key <- pair[[1]]
        val <- pair[[2]]
        if (!key %in% names(result)) {
          result[[key]] <- val
        } else {
          result[[key]] <- f(result[[key]], val)
        }
      }
      return(IData$new(data = lapply(names(result), function(k) list(k, result[[k]]))))
    },
    saveAsTextFile = function(path) {
      con <- file(path, "w")
      for (item in data) {
        line <- paste(item[[1]], item[[2]])
        writeLines(line, con)
      }
      close(con)
      message(paste("[IData] Saved result to", path))
    }
  )
)


