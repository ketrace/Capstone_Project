#load packages

library("Lahman")
library("dplyr")
library("tidyr")


#get relevant data from Master list
master_data <- Master %>%
  select(playerID, debut, finalGame, throws, bats)


#separate debut date into 3 col (debut year, deb_month, deb_day)
master_data <- master_data %>%
  separate(debut, c("Debut Year", "Deb_Month", "Deb_Day"), sep = "-", remove = TRUE)

#separate date of final game into 3 col (final year, f_month, f_day)
master_data <- master_data %>%
  separate(finalGame, c("Final Year", "F_month", "F_day"), sep = "-", remove = TRUE)



#get relevant fielding data from Fielding data set
fielding_data <- Fielding %>%
  select(playerID, yearID, POS, InnOuts, PO, A, E)


#get relevant batting data from Batting data set
batting_data <- Batting %>%
  select(playerID, yearID, AB, R, H, X2B, X3B, HR, RBI)

#get relevant pitching data from Pitching data set
pitching_data <- Pitching %>%
  select(playerID, yearID, W, L, G, BAOpp, ERA, BB, SO)


#get salary data for each player each year
player_salary <- Salaries %>%
  select(playerID, yearID, salary)

#merge data frames together for position players(nonpitchersn ***need to remove pitchers from position player dataframe

all_positions <- left_join(master_data, fielding_data)

all_positions <- left_join(all_positions, batting_data)

all_positions <- left_join(all_positions, player_salary)

#create data frame for pitchers
all_pitching <- inner_join(master_data, pitching_data)


