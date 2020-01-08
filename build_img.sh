#!/bin/sh
VERSION=v1.0.0

docker rmi -f hello2mao/crypto-kitties:${VERSION}
docker build -t hello2mao/crypto-kitties:${VERSION} .
docker push hello2mao/crypto-kitties:${VERSION}