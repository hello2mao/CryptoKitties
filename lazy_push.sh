#!/bin/sh
git add .
date=`date`
git commit -m "Lazy push: $date"
git push
