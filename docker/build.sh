#!/bin/sh

# Build the Docker image for Base-ANTLR development
docker build -t base-antlr:dev -f docker/Dockerfile .
