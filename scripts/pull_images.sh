#!/bin/bash

# Log in to ECR (ensure AWS CLI is configured with proper credentials and region)
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 058264092984.dkr.ecr.us-east-1.amazonaws.com

TAG="dynamoai-3.18.9"

# List of image repositories
images=(
  "billing"
  "data-processing"
  "db-migrations"
  "dynamoai-api"
  "dynamoai-ui"
  "dynamoai-vllm"
  "dynamoguard"
  "dynamoguard-lorax"
  "dynamoguard-pii"
  "e5_finetune"
  "e5-hf"
  "hallucination-entailment"
  "hallucination-rag"
  "init-checkers"
  "metrics-report"
  "moderation"
  "off_topic"
  "pen-testing"
  "report-generation"
)

# Pull each image
for image in "${images[@]}"; do
  echo "Pulling image: 058264092984.dkr.ecr.us-east-1.amazonaws.com/$image:$TAG"
  docker pull 058264092984.dkr.ecr.us-east-1.amazonaws.com/$image:$TAG
  if [ $? -ne 0 ]; then
    echo "Failed to pull image: $image"
  else
    echo "Successfully pulled image: $image"
  fi
done

docker logout 058264092984.dkr.ecr.us-east-1.amazonaws.com
