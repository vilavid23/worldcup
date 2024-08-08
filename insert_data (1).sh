#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

# GET TEAM NAMES
  # Skip lable line
  if [[ $WINNER != "winner" ]]
  then
  # Get winner name
  TEAM_1=$($PSQL "SELECT name FROM teams where name='$WINNER'")
  # If not found
  if [[ -z $TEAM_1 ]]
  then
  # Insert winner name
  INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
  # echo inserted name
  if [[ $INSERT_TEAM == "INSERT 0 1" ]]
  then
  echo Inserted $WINNER
  fi
fi
fi

  # Skip lable line
  if [[ $OPPONENT != "opponent" ]]
  then
  # Get opponent name
  OPP_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
  # if not found
  if [[ -z $OPP_NAME ]]
  then
  # Insert opponent name
  INSERT_OPP=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
  # echo inserted name
  if [[ $INSERT_OPP == "INSERT 0 1" ]]
  then
  echo Inserted $OPPONENT
  fi
fi
fi
# GET GAMES
  # Skip lable line for year
  if [[ $YEAR != "year" ]]
  then
  # Get winner_id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  # Get opponent_id
  OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  # Insert into games row with year round winner_id opponent_id winner_goals opponent_goals
  INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPP_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  # echo inserted winner VS inserted opponent
  if [[ $INSERT_GAMES == "INSERT 0 1" ]]
  then
  echo Inserted $WINNER VS $OPPONENT
  fi
fi
done