#!/bin/sh
./node_modules/.bin/truffle compile --compile-all && ./node_modules/.bin/truffle migrate --reset && cd src && node server.js
