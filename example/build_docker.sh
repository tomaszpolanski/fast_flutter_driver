#!/bin/bash

set -e

docker build --tag tomek/flutter:`echo "$1" | tr + _` \
             --tag tomek/flutter:latest \
             --build-arg flutter_version=$1 ./