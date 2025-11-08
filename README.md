# Base-ANTLR
A starting point for ANTLR-based language projects

## Setup
All dev work should be done in a Docker container; the Docker file(s) for that container is stored in ./docker:

```
docker build -t base-antlr:dev -f docker/Dockerfile .
docker run -it --rm -v "$(pwd)":/home/devuser/workspace base-antlr:dev
```

These have both been captured in the top-level scripts `build.sh` and `run.sh`, respectively. They are configured to run from the project root directory, so run them as `./docker/build.sh` and `./docker/run.sh`.

Once inside the container, `./gradlew test`.

## ANTLR
The `antlr` directory has a copy of the ANTLR 4.13.2 JAR file. This contains the ANTLR parser generator and a few supporting tools. The grammar file should be in this directory, and it will generate its target parser code to `code`. This is necessary in order to be able to run the various ANTLR supporting tools, such as its visualizer.

See the antlr/README.md for details on ANTLR usage.

## Grammars
The `grammars` directory contains a set of starting-point grammars for experimentation/use.
