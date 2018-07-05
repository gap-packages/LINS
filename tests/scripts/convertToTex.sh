#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TEST=$1
while read line; do
  echo "$line" >> $DIR/$TEST.tex
done
