#load packages

library("Lahman")
library("dplyr")
library("tidyr")


#get relevant data from Master list
master_data <- Master %>%
  select(playerID, debut, finalGame, throws, bats)


#separate debut date into 3 col (debut year, deb_month, deb_day)
master_data <- master_data %>%
  separate(debut, c("Debut_Year", "Deb_Month", "Deb_Day"), sep = "-", remove = TRUE)

#separate date of final game into 3 col (final year, f_month, f_day)
master_data <- master_data %>%
  separate(finalGame, c("Final_Year", "F_month", "F_day"), sep = "-", remove = TRUE)

#remove Deb_month, Deb_day and F_month, F_day
 master_data <- master_data %>%
   subset(select = -c(Deb_Month, Deb_Day, F_month, F_day))

#create column for career length (in years)
master_data <- master_data %>%
  mutate(Career_Length = as.numeric(Final_Year) - as.numeric(Debut_Year))

#get relevant fielding data from Fielding data set
fielding_data <- Fielding %>%
  select(playerID, yearID, POS, InnOuts, PO, A, E)

#calculate fielding percentage - measure of fielder's capability
fielding_data <- fielding_data %>%
  mutate(FPCT = (PO + A)/(PO + A + E))


#get relevant batting data from Batting data set
batting_data <- Batting %>%
  select(playerID, yearID, G, AB, R, H, X2B, X3B, HR, RBI, BB, SF, HBP)


#get relevant pitching data from Pitching data set
pitching_data <- Pitching %>%
  select(playerID, yearID, W, L, G, BAOpp, ERA, BB, SO)

#calculate strikeouts/walks ratio for pitchers K/BB
pitching_data <- pitching_data %>%
  mutate(KperBB = SO/BB)

#get salary data for each player each year
player_salary <- Salaries %>%
  select(playerID, yearID, salary)

#merge data frames together for position players

all_positions <- left_join(master_data, fielding_data, by = "playerID")

all_positions <- left_join(all_positions, batting_data, by = c("playerID", "yearID"))

all_positions <- inner_join(all_positions, player_salary, by = c("playerID", "yearID"))

#create column to represent which year of career
all_positions <- all_positions %>%
  mutate(Career_Year = yearID - as.numeric(Debut_Year) + 1 )

#create subset of all_positions to remove rows that correspond to pitchers
all_posplayers <- all_positions %>%
  subset(POS != "P")

# group by player by year and count number of games
all_posplayers <- all_posplayers %>%
  group_by(playerID, yearID, add = TRUE) %>%
  summarise(G = n())

#create data frame for pitchers
all_pitching <- inner_join(master_data, pitching_data, by = "playerID")

#create career year column for pitchers
all_pitching <- all_pitching %>%
  mutate(Career_Year = yearID - as.numeric(Debut_Year) + 1 )

#write CSV for all position players
write.csv(all_posplayers, "all_posplayers.csv")

#write csv for all pitchers
write.csv(all_pitching, "all_pitching.csv")