#!/bin/bash

echo "Starting development environment from $(pwd)..."

# Run a container from the Base-ANTLR development image
docker run -it --rm -v "$(pwd)":/home/devuser/workspace base-antlr:dev
