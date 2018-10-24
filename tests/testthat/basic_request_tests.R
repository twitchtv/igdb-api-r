# Basic request test

# library(testthat)

context("basic_request_tests.R")

# initialize ----------------------------------------------------------------------------

# We must add a valid test key

igdb_key = Sys.getenv("key")

# tests ---------------------------------------------------------------------------------

test_that("search for mass effect", {
  parameters <- igdb_parameters(fields = "*", search = "mass effect")
  json_resp <- igdb_request(GAMES, parameters, igdb_key)
  expect_equal(json_resp$path, "games/?search=mass effect&fields=*")
  expect_equal(json_resp$response$status_code, 200)
  expect_equal(length(json_resp$content), 10)
})

test_that("limit changes json content size", {
  parameters <- igdb_parameters(fields = "name", limit = 33)
  json_resp <- igdb_request(GAMES, parameters, igdb_key)
  expect_equal(json_resp$path, "games/?fields=name&limit=33")
  expect_equal(json_resp$response$status_code, 200)
  expect_equal(length(json_resp$content), 33)
})

test_that("wrapper can handle advanced queries", {
  parameters <- igdb_parameters(fields = "name,cover,rating,genres.name,release_dates.human,release_dates.date,first_release_date,hypes", 
                                filter = list("[first_release_date][gt]=1508243168000", "[themes][not_in]=42", "[cover][exists]"),
                                order = "hypes:desc", limit = 20)
  json_resp <- igdb_request(GAMES, parameters, igdb_key)
  expect_equal(json_resp$path, "games/?fields=name,cover,rating,genres.name,release_dates.human,release_dates.date,first_release_date,hypes&limit=20&order=hypes:desc&filter=[first_release_date][gt]=1508243168000&filter=[themes][not_in]=42&filter=[cover][exists]")
  expect_equal(json_resp$response$status_code, 200)
  expect_equal(length(json_resp$content), 20)
})

# test errors

test_that("Using wrapper without key throws an error", {
  expect_error(igdb_request(GAMES, "?fields=id,name", ""), "Empty API key, please set the parameter 'key' with your API key.")
})

test_that("API returns correct formatted data 'application/json' otherwise error", {
  expect_error(igdb_request("", "", igdb_key), "API did not return json")
})