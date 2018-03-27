#load packages

library("Lahman")
library("dplyr")
library("tidyr")


#get relevant data from Master list
master_data <- Master %>%
  select(playerID, debut, finalGame, throws, bats)

#get debut year (year 1)
master_data <- master_data %>%
  separate(debut, c("Debut Year", "Deb_Month", "Deb_Day"), sep = "-", remove = TRUE)

#get relevant fielding data from Fielding data set
fielding_data <- Fielding %>%
  select(playerID, yearID, POS, InnOuts, PO, A, E)

#get relevant batting data from Batting data set
batting_data <- Batting %>%
  select(playerID, yearID, AB, R, H, X2B, X3B, HR, RBI)

#get relevant pitching data from Pitching data set
pitching_data <- Pitching %>%
  select(playerID, yearID, W, L, G, BAOpp, ERA, BB, SO)

#merge data frames together

all_positions <- left_join(master_data, fielding_data)

all_positions <- left_join(all_positions, batting_data)

all_positions <- left_join(all_positions, pitching_data)

#separate pitchers out
