library(httr)
library(jsonlite)
library(roxygen2)

#' igdb_request requests the IGDB API for information
#'
#' @param endpoint   The endpoint you wish to request, use the pre-made endpoint varaiables
#' @param parameters the completed query parameters from igdb_parameters
#' @param key IGDB API key
#' @return a structure containing: \itemize{
#' \item content: Parsed JSON
#' \item path: complete path
#' \item response
#' }
#'
igdb_request <- function(endpoint, parameters = "", key = "") {
  completePath <- paste(endpoint, parameters, sep = "")
  igdb_complete_request(completePath)
}


#' igdb_complete_request function creates a new GET request to the IGDB API
#' This function is used by igdb_request() which creates the complete path for you.
#'
#' @param completePath the complete pathcosists of the endpoint path and the query parameters
#' @param key IGDB API key
#' @return a structure containing: \itemize{
#' \item content: Parsed JSON
#' \item path: complete path
#' \item response
#' }
igdb_complete_request <- function(completePath = "", key = "") {

  if(key == "") {
    stop("Empty API key, please set the parameter 'key' with your API key.")
  }

  url <- modify_url("http://api-endpoint.igdb.com", path = completePath)

    resp <- GET(url, add_headers(`user-key` = key), encode = "json")

  if (http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  parsed <- jsonlite::fromJSON(content(resp, "text"), simplifyVector = FALSE)

  if (http_error(resp)) {
    msg = list("IGDB API request failed", str(status_code(resp)))
    stop(
      sprintf(
        paste(msg, collapse = ": ")
      ),
     call. = FALSE
    )
  }
  structure(
    list(
      content = parsed,
      path = completePath,
      response = resp
    ),
    class = "igdb_api"
  )
}
