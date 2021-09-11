#!/bin/bash

DOCKER_BUILDKIT=1 docker build -t my-app . --secret id=run-password,src=run-password.txt
