#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"


SERVICES_LIST() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  # get services
  AVAILABLE_SERVICES_RAW=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  AVAILABLE_SERVICES=$(echo "$AVAILABLE_SERVICES_RAW" | sed 's/|/ /g')
  echo -e "\nWelcome to My Salon, how can I help you?"
  
  while true; do
    echo "$AVAILABLE_SERVICES" | while read SERVICE_ID NAME
    do
      echo "$SERVICE_ID) $NAME"
    done
    read SERVICE_ID_SELECTED
    case $SERVICE_ID_SELECTED in
      1) break ;;
      2) break ;;
      3) break ;;
      4) break ;;
      *) echo -e "\nI could not find that service. What would you like today?"; continue ;;
    esac
    break
  done
  echo -e "\nthx for select $SERVICE_ID_SELECTED"
  
  # get customer info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    #insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  # get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  SERVICE_NAME_FORMATED=$(echo "$SERVICE_NAME" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  CUSTOMER_NAME_FORMATED=$(echo "$CUSTOMER_NAME" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  echo -e "\nWhat time would you like your $SERVICE_NAME_FORMATED, $CUSTOMER_NAME_FORMATED?"
  read SERVICE_TIME
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo -e "I have put you down for a $SERVICE_NAME_FORMATED at $SERVICE_TIME, $CUSTOMER_NAME_FORMATED."
}

SERVICES_LIST