##!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# if no input
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi  

# if input not a number
if ! [[ $1 =~ ^[0-9]+$ ]]
then
  # Get atomic number
  ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol='$1' or name='$1'")
  # if not found
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
    exit 0
  fi
else
  ATOMIC_NUMBER=$1
fi  

#Get element data
ELEMENT_DATA=$($PSQL "select * from elements inner join properties using(atomic_number) inner join types using(type_id) where atomic_number='$ATOMIC_NUMBER'")

#IF NOT FOUND
if [[ -z $ELEMENT_DATA ]]
then
  echo "I could not find that element in the database."
else
  read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE <<< $ELEMENT_DATA
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
fi  