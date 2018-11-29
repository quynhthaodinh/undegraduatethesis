#OMDB API
#install the requisite packages for working with API
library(httr)
library(jsonlite)
library(xml2)
library(omdbapi)

#Create a string of IMBD IDs corresponding to the films in the Box Office Mojo dataset
IMDB_ID <- BOMojo_IMDB_2$IMDB_ID

#TEST
#Call to API for data on movie with IMDB ID 
OMDB_tt1843866 <- GET("http://www.omdbapi.com/?apikey=67ed49f9", query = list(i = "tt1843866", r = "json"))

json_text_content <- content(OMDB_tt1843866, as = "text") %>%
  fromJSON()
omdb_tt1843866 <- as.data.frame(json_text_content)

##Note: Figure out how to systematically loop this process so you dont have to manually call every single movie in the box office mojo dataset