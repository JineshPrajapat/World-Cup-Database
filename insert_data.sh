#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $WINNER != "winner" ]]
  then
    # get winner_id
    WINNER_TEAM_ID = $($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $WINNER_TEAM_ID ]]
      then 
        INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        # if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
        #   then 
        #     echo inserted, "$WINNER"
        #   fi
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    OPPONENT_TEAM_ID = $($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $OPPONENT_TEAM_ID ]]
      then 
        INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        # if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
        #   then 
        #     echo inserted, "$OPPONENT"
        #   fi
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
  fi

  # WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  # OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year,round, opponent_id,winner_id,winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$OPPONENT_ID', '$WINNER_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
done