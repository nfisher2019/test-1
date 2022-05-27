#!/usr/bin/env bash

PORT=4566
CONTAINER=localstack
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo $SCRIPT_DIR

export AWS_ACCESS_KEY_ID="unused-id"
export AWS_SECRET_ACCESS_KEY="unused-secret"
export AWS_SESSION_TOKEN="unused-token"

docker stop $CONTAINER 2> /dev/null

echo "creating dynamo container"
docker run --rm -p $PORT:$PORT -e "SERVICES=dynamodb,sns,sqs,s3" -d \
  --name $CONTAINER localstack/localstack:0.12.19

if [ $? -ne 0 ]; then
  docker start $CONTAINER
fi
