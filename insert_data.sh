#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Clear tables
$PSQL "TRUNCATE teams, games"

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WIN_GOALS OPP_GOALS
do

  if [[ $YEAR != year ]]
  then

    # Check if winner is recorded
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # If not, insert

    if [[ -z $WINNER_ID ]]
    then 
      WINNER_INSERT=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
    fi

    # Get ID of new item
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # Check if oppoent is recorded
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # If not, insert

    if [[ -z $OPPONENT_ID ]]
    then 
      OPPONENT_INSERT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
    fi

    # Get ID of new item
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # Insert game data
    GAME_INSERT=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WIN_GOALS, $OPP_GOALS)")

  fi

done