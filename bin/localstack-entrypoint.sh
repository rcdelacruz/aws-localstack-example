#!/usr/bin/env bash
printf "Configuring localstack components..."

readonly LOCALSTACK_URL=http://localhost:4566

sleep 5;

set -x

aws configure set aws_access_key_id test
aws configure set aws_secret_access_key test
echo "[default]" > ~/.aws/config
echo "region = us-east-1" >> ~/.aws/config
echo "output = json" >> ~/.aws/config

aws --endpoint $LOCALSTACK_URL sqs create-queue --queue-name blockchain-local-engine-cancel
aws --endpoint $LOCALSTACK_URL sqs create-queue --queue-name blockchain-local-engine-input.fifo --attributes FifoQueue=true,MessageGroupId=blockchain
aws --endpoint $LOCALSTACK_URL sqs create-queue --queue-name blockchain-local-engine-output.fifo --attributes FifoQueue=true,MessageGroupId=blockchain
aws --endpoint-url=$LOCALSTACK_URL s3api create-bucket --bucket blockchain-s3-local-bitcoin
aws --endpoint-url=$LOCALSTACK_URL s3api create-bucket --bucket blockchain-s3-local-ziliqa
aws --endpoint-url=$LOCALSTACK_URL s3api create-bucket --bucket blockchain-s3-local-xrp
aws --endpoint-url=$LOCALSTACK_URL s3api create-bucket --bucket blockchain-s3-local-ada
aws --endpoint-url=$LOCALSTACK_URL s3api create-bucket --bucket blockchain-s3-local-eth
aws --endpoint-url=$LOCALSTACK_URL s3api create-bucket --bucket nyc-tlc

printf "Sample data begin..."
# create tmp directory to put sample data after chunking
mkdir -p /tmp/localstack/data
# aws s3 cp --debug "s3://nyc-tlc/trip data/yellow_tripdata_2018-04.csv" /tmp/localstack --no-sign-request --region us-east-1
aws --endpoint-url=$LOCALSTACK_URL s3api create-bucket --bucket nyc-tlc
# Create lambda deploy bucket for our simple http endpoint example
aws --endpoint-url=$LOCALSTACK_URL s3api create-bucket --bucket simple-http-endpoint-local-deploy
# Grant bucket public read
aws --endpoint-url=$LOCALSTACK_URL s3api put-bucket-acl --bucket nyc-tlc --acl public-read
aws --endpoint-url=$LOCALSTACK_URL s3api put-bucket-acl --bucket simple-http-endpoint-local-deploy --acl public-read
# Create a folder inside the bucket
aws --endpoint-url=$LOCALSTACK_URL s3api put-object --bucket nyc-tlc --key "trip data/"
aws --endpoint-url=$LOCALSTACK_URL s3 sync /tmp/localstack "s3://nyc-tlc/trip data" --cli-connect-timeout 0
# Display bucket content
aws --endpoint-url=$LOCALSTACK_URL s3 ls "s3://nyc-tlc/trip data"

set +x

