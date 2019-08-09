#!/bin/bash

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

docker build -t paragraval/node-min-puppeteer:1.0.0 .

docker push paragraval/node-min-puppeteer:1.0.0