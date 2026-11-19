#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# year,round,winner,opponent,winner_goals,opponent_goals

ADD_TEAMS() {
  echo "Adding teams..."
  cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
    if [[ $YEAR != year ]]
    then
      WINNER_EXISTS=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER'")
      # check if team name exists in table
      if [[ -z $WINNER_EXISTS ]]
      then
        # if not then add winner variable
        WINNERS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        echo "$WINNER"
      fi
      
      
      OPPONENT_EXISTS=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT'")
      if [[ -z $OPPONENT_EXISTS ]]
      then
        # then check if opponent exists in table if not add opp
        OPPONENTS=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        echo "$OPPONENT"
      fi
    fi
  done
}
ADD_TEAMS

INSERT_GAMES() {
  echo -e "\nAdding Games..."
  cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  # year,round,winner,opponent,winner_goals,opponent_goals
  do
    if [[ $YEAR != 'year' ]]
    then
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      GAMES=$($PSQL "INSERT INTO
      games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
      VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    fi
  done
  echo "Done."
}
INSERT_GAMES
