#!/bin/bash

# bogus secret passthrough, use docker secrets in prod env
docker run --rm -it --privileged --mount type=bind,src=$(pwd)/run-password.txt,dst=/run/secrets/run-password my-app
