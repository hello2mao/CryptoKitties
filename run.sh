#!/bin/sh

cd private-eth && sh run.sh

echo "start to run DApp..."
sleep 5s
cd .. && npm run all
echo "run DApp success"