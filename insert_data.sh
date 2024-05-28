#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#Insert Teams
TEAMS=()
while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ ! $first_line ]]; then
  first_line=1
  continue
  fi

  if [[ ! "${TEAMS[@]}" =~ "$WINNER" ]]; 
  then
    TEAMS+="$WINNER"
    $PSQL "INSERT INTO teams (name) VALUES ('$WINNER')"
  fi

  if [[ ! "${TEAMS[@]}" =~ "$OPPONENT" ]]; 
  then
    TEAMS+="$OPPONENT"
    $PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')"
  fi
  $PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', '$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")', '$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")', $WINNER_GOALS, $OPPONENT_GOALS)"

done < "games.csv"