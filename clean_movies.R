# this script cleans up box office revenue data in two major ways
# - pulls a ton of empty rows and columns from the csv
# - fixes units problem so that all dollar amounts are in the same unit (currently, dollars)

library(dplyr)
library(tidyr)

movies <- read.csv('Box Office Mojo CSV.csv',
                   stringsAsFactors = FALSE,
                   na.strings = c("","n/a", "NA"))

# this cleans up the data to make a less large and empty csv
# it had ~100k blank rows and 3 blank columns
better_data <- movies %>%
  filter(!is.na(Identifier)) %>%
  rename(Domestic.Percent = Domestic..,
         Overseas.Percent = Overseas..) %>%
  select(1:10)

write.csv(better_dollars, file = "cleaned_mojo.csv", quote = TRUE, row.names = FALSE, na = "")

# fixing units below
better_dollars <- better_data %>%
  # fix the units for worldwide
  separate(Worldwide.Dollar, c('sign', 'worldwide_box', 'unit'), c(1,-1)) %>% # break off the $ and k (or space)
  mutate(worldwide_box = as.numeric(stringr::str_remove(worldwide_box, ",")), # pull any commas from the dollar amount
         worldwide_box = ifelse(unit == "k", #multiply by 1,000 if it's k; by 1,000,000 if not
                                worldwide_box * 1000,
                                worldwide_box * 1000000)) %>%
  select(-sign, -unit) %>%
  
  # fix the units for domestic
  separate(Domestic.Dollar, c('sign', 'domestic_box', 'unit'), c(1,-1)) %>%
  mutate(domestic_box = as.numeric(stringr::str_remove(domestic_box, ",")),
         domestic_box = ifelse(unit == "k",
                                domestic_box * 1000,
                                domestic_box * 1000000)) %>%
  select(-sign, -unit) %>%
  
  # fix the units for overseas
  separate(Overseas.Dollar, c('sign', 'overseas_box', 'unit'), c(1,-1)) %>%
  mutate(overseas_box = as.numeric(stringr::str_remove(overseas_box, ",")),
         overseas_box = ifelse(unit == "k",
                               overseas_box * 1000,
                               overseas_box * 1000000)) %>%
  select(-sign, -unit)

# set columns per "How I Want Data to Look"
movies_clean <- select(better_dollars,
                       Identifier, Year, Title, Studio,
                       worldwide_box, domestic_box, overseas_box)

write.csv(movies_clean, file = "boxoffice.csv", quote = TRUE, row.names = FALSE, na = "0")
