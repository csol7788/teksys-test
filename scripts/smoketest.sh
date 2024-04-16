#!/bin/bash -e

echo Checking REST API Endpoint
echo API INVOKE URL: $1

api_url=${1::-1}
api_url=${api_url:1}
api_url="${api_url}/testing"

echo Invoke URL with API resource $api_url

api_response=$(curl --location --request POST --write-out %{http_code} --silent --output /dev/null ${api_url})

if [ $api_response -eq 200 ]
then
    echo "$api_url has responded with a 200 status code"
    exit 0
else
    echo "REST API call returned: $api_response code"
    exit 1
fi