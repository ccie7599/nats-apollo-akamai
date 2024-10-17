#!/bin/bash

# Function to generate a random selection of fields
generate_query() {
  # Declare an array with possible fields
  fields=("id" "customer" "product" "quantity" "status")

  # Shuffle the array and pick a random number of fields (1 to 5)
  selected_fields=$(shuf -e "${fields[@]}" -n $((RANDOM % 5 + 1)))

  # Start building the query
  query="query { getOrder(orderId: \\\"$1\\\") {"

  # Loop through the selected fields and add them to the query
  for field in ${selected_fields}; do
    query="$query $field"
  done

  query="$query } }"
  
  echo "$query"
}

while true; do
  # Generate a random number between 1 and 1000 for the orderId
  orderId=$((RANDOM % 1000 + 1))

  # Generate the query with a random selection of fields
  random_query=$(generate_query "$orderId")

  # Run the curl command with the generated query
  curl -k -X POST 'https://workshop.connected-cloud.io/graphql?origin=graphql' \
    -H "Content-Type: application/json" \
    -H "Pragma: akamai-x-cache-on, akamai-x-cache-remote-on" \
    -H "Cache-Control: no-cache" \
    -d "{\"query\": \"$random_query\"}" \
    -i
done
