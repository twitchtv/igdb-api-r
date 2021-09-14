# NOTICE
This repository is for the v3 version of the API and no longer supported. 

A member of the community has created this for V4: https://github.com/praster1/igdbV4 








# igdb-api-r
An R wrapper for the IGDB.com Free Video Game Database API.

## About IGDB
One of the principles behind IGDB.com is accessibility of data. We wish to share the data with anyone who wants to build cool videogame oriented websites, apps and services. This means that the information you contribute to IGDB.com can be used by other projects as well.

Thus, you are not only contributing to the value of this site but to thousands of other projects as well. We are looking forward to see what exciting game related projects you come up with. Happy coding!

More info here:
* [About the API](https://www.igdb.com/api)
* [API Documentation](https://igdb.github.io/api/about/welcome/)

# Installation and setup
To get the current version from github:
``` R
install.packages("devtools")
devtools::install_github("igdb/igdb-api-r")
```

## Using your API key
* create a local variable and pass that to your requests
``` R
igdb_key <- "YOUR KEY"
igdb_request(GAMES, params, igdb_key)
```
* OR create a environment variable and pass that to your requests
``` R
Sys.setenv(igdb_key = "YOUR KEY")
igdb_key = Sys.getenv("igdb_key")
igdb_request(GAMES, params, igdb_key) || igdb_request(GAMES, params, Sys.getenv("igdb_key")
```

## Usage
All API endpoints are available as variables in the wrapper.

Example: you want to request the games endpoint then you use the variable 'GAMES'
### All endpoints (variables)
* CHARACTERS
* COLLECTIONS
* COMPANIES
* CREDITS
* FEEDS
* FRANCHISES
* GAME_ENGINES
* GAME_MODES
* GAMES
* GENRES
* KEYWORDS
* PAGES
* PEOPLE
* PLATFORMS
* PLAYER_PERSPECTIVES
* PULSE_GROUPS
* PULSE_SOURCES
* PULSES
* RELEASE_DATES
* REVIEWS
* THEMES
* TITLES

### Requesting Data
__Arguments__
* endpoint - the chosen endpoint to request, use the variables above
* Parameters - An object specifying the operations to be performed, ex. expander, filter, ordering etc. These Operations can be found in the API documentation under References: (https://igdb.github.io/api/references/)
* key - Your api key for authentication

### Using the parameters function
To help you structure your requests correctly you should use the igdb_parameters function. The functions parameters:
``` R
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
){}
```
query is for advanced usage which overrides the logic of the function. It is basically a return(query)

IMPORTANT
- Note that the filter param is a list() of "strings"
- Note that you cannot use both search and ids, this will trow an exception

### The response structure
The response is returnes as a structure which looks like this: 
``` R
structure(
    list(
      content = The parsed JSON response,
      path = The complete path,
      response = The response from httr
    ),
    class = "igdb_api"
  )
```
this can help with debugging requests. To get the json from the response: `json_resp$content`


__EXAMPLES__
Requesting games from the API
``` R
igdb_key <- "YOUR KEY"
params <- igdb_parameters(fields = "*", order = "published_at:desc")
json_resp <- igdb_request(GAMES, params, igdb_key)
# The sent request will look like this:
# https://api-endpoint.igdb.com/games/?fields=*&order=published_at:desc 
```
Searching for a game
m the API
``` R
igdb_key <- "YOUR KEY"
params <- igdb_parameters(search = "Zelda", fields = "*", order = "published_at:desc")
json_resp <- igdb_request(GAMES, params, igdb_key)
# The sent request will look like this:
# https://api-endpoint.igdb.com/games/?search=Zelda&fields=*&order=published_at:desc 
```
Using filter

``` R
igdb_key <- "YOUR KEY"
params <- igdb_parameters(fields = "*", 
                         order = "published_at:desc", 
                         filter = list("[themes][not_in]=42"))
json_resp <- igdb_request(GAMES, params, igdb_key)
# The sent request will look like this:
# https://api-endpoint.igdb.com/games/?fields=*&filter[themes][not_in]=42&order=published_at:desc 
```

## More examples
Search for up to two Atari platforms and return their names
```R
params <- igdb_parameters(search = "Atari", fields = "name", limit = 2)
json_resp <- igdb_request(PLATFORMS, params, igdb_key)

# The sent request will look like this:
# https://api-endpoint.igdb.com/platforms/?search=Atari&fields=name&limit=2 
```
Search for up to five Zelda games with release dates between 1 Jan and 31 Dec 2011, sorted by release date in descending order.
``` R
params <- igdb_parameters(search = "Zelda", 
                         fields = "name,release_dates.date,rating,hypes,cover", 
                         filter = list("[release_dates.date][gt]=2010-12-31", 
                                      "[release_dates.date][lt]=2012-01-01"),
                         limit = 2),
                         order = "release_dates.date:desc")
json_resp <- igdb_request(GAMES, params, igdb_key)

# The sent request will look like this:
# https://api-endpoint.igdb.com/games/?search=Zelda&fields=name,release_dates.date,rating,hypes,cover&filter[release_dates.date][gt]=2010-12-31&filter[release_dates.date][lt]=2012-01-01&limit=5&order=release_dates.date:desc 
```
Search for companies with 'rockstar' in their name. Return up to five results sorted by name in descending order
``` R
params <- igdb_parameters(search = "rockstar", 
                         fields = "name,logo", 
                         filter = list("[name][in]=rockstar"),
                         limit = 5),
                         order = "name:desc")
json_resp <- igdb_request(COMPANIES, params, igdb_key)

# The sent request will look like this:
# https://api-endpoint.igdb.com/companies/?search=rockstar&fields=name,logo&filter[name][in]=rockstar&limit=5&offset=0&order=name:desc
```
Search for two specific games by their IDs
``` R
params <- igdb_parameters(ids = "18472,18228", 
                         fields = "name,cover")
json_resp <- igdb_request(GAMES, params, igdb_key)

# The sent request will look like this:
# https://api-2445582011268.apicast.io/games/18472,18228?fields=name,cover 

```
