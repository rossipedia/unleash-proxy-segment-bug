#!/bin/sh

API_KEY="*:*.super-secret-admin-token"

# Create Test Segment
curl --location --request POST 'http://localhost:4242/api/admin/segments' \
--header "Authorization: $API_KEY" \
--header 'Content-Type: application/json' \
--data-raw '{
  "name": "Test Segment",
  "description": "",
  "constraints": [
    {
      "contextName": "userId",
      "operator": "IN",
      "values": [
        "someuser"
      ],
      "caseInsensitive": false,
      "inverted": false
    }
  ]
}'

echo ""

# Create Flag in Default project
curl --location --request POST 'http://localhost:4242/api/admin/projects/default/features' \
    --header "Authorization: $API_KEY" \
    --header 'Content-Type: application/json' \
    --data-raw '{
  "type": "release",
  "name": "TestFeature",
  "description": "",
  "impressionData": false
}'

echo ""

# Enable it in development
curl -L -X POST 'http://localhost:4242/api/admin/projects/default/features/TestFeature/environments/development/on' \
-H 'Accept: application/json' \
-H "Authorization: $API_KEY"

# Get first strategy
STRATEGY_ID=$(curl -L 'http://localhost:4242/api/admin/projects/default/features/TestFeature/environments/development/strategies' \
-H 'Accept: application/json' \
-H "Authorization: $API_KEY" -s | jq -r '.[0].id')


# Update to use the segment
curl --location --request PUT "http://localhost:4242/api/admin/projects/default/features/TestFeature/environments/development/strategies/$STRATEGY_ID" \
    --header "Authorization: $API_KEY" \
    --header 'Content-Type: application/json' \
    --data-raw '{
  "name": "flexibleRollout",
  "title": "",
  "constraints": [],
  "parameters": {
    "rollout": "100",
    "stickiness": "default",
    "groupId": "TestFeature"
  },
  "variants": [],
  "segments": [
    1
  ],
  "disabled": false
}'
