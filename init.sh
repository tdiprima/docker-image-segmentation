#!/bin/bash

set -e  # Exit immediately if a command fails

# Build the Docker image
docker build -t segmentation-base .

# Tag the image for Docker Hub
docker tag segmentation-base codewhispererx/segmentation-base:latest

# Push the image to Docker Hub
docker push codewhispererx/segmentation-base:latest
