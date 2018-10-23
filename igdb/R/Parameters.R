

#' Helper function for igdb_parameters function
#' DO NOT USE
#'
#' @param param     igdb_parameters param variable
#' @param result    igdb_parameters result variable
#' @param paramName param variable name
#' @return refactored parameter text
resultQuery <- function(param = "", result = "", paramName = "") {
  if(result == "") {
    paramName <- paste("?", paramName, "=", param, sep = "")
    return(paramName)
  } else {
    paramName <- paste("&", paramName, "=", param, sep = "")
    return(paramName)
  }
}

#' igdb_parameters helps you convert your request to queryparameters that the api can read.
#'
#' @param fields  enter the fields you want to see
#' @param limit   limit sets the response limit, default is 10
#' @param offset  offset set the response offset, default is 0
#' @param order   order sets the default ordering of your response
#' @param ids     displays items with the specific id WARNING cannot be used together with search
#' @param expand  expand sets the fields you want expanded in the response
#' @param search  search is a text based search search for titles WARNING cannot be used together with ids
#' @param filter  filter sets the specific filters to your response ex: list("[genre][eq]=33"). adding multiple filters will AND then in the response
#' @param query   query replaces ALL other params and is intended for raw queryparams
#' @return a complete and valid queryParameter for use with your request.
#' @examples
#' igdb_parameters(fields = "id,name,genres.name", order = "name:desc", expand = "genres")
#' igdb_parameters(search = "Zelda", fields = "id,name,genres.name", order = "name:desc", expand = "genres")
#' igdb_parameters(ids = "1,23,33,42", fields = "*", expand = "genres")
#' igdb_parameters(query = "?fields=id,name&limit=33&order=name:desc")
#' igdb_parameters(fields = "name,genres.name,release_dates.human,release_dates.date,first_release_date" filter = list("[first_release_date][gt]=1508243168000", "[themes][not_in]=42", "[cover][exists]"))
igdb_parameters <- function(
  fields = "",
  limit = 10,
  offset = 0,
  order = "",
  ids = "",
  expand = "",
  search = "",
  filter = list(),
  query = ""
) {

  result <- ""

  if(query != "") {
    return(query)
  }

  if(search != "" & ids != "") {
    stop(
      sprintf(
        error = "Param error!",
        cause = "cannot use 'search' & 'ids' at the same time"
      ),
      call. = FALSE
    )
  }

  if(search != "") {
    result = paste("?search=", search, sep = "")
  }

  if(ids != "") {
    result = ids
  }

  if(fields != "") {
    result = paste(result, resultQuery(fields, result, "fields"), sep = "")
  }

  if(limit != 10) {
    result = paste(result, resultQuery(limit, result, "limit"), sep = "")
  }

  if(offset != 0) {
    result = paste(result, resultQuery(offset, result, "offset"), sep = "")
  }

  if(order != "") {
    result = paste(result, resultQuery(order, result, "order"), sep = "")
  }

  if(expand != "") {
    result = paste(result, resultQuery(expand, result, "expand"), sep = "")
  }

  filterLength <- length(filter)
  if(filterLength > 0) {
    for (f in 1:filterLength) {
      result = paste(result, resultQuery(filter[f], result, "filter"), sep = "")
    }
  }

  return(result)
}


