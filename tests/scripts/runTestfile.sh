#!/bin/bash

DIR=$1
TEST=$2

# Create all .tex files from the testfile
cd $DIR/..
gap -r -b -q -T << EOI
Read("./tests/testfiles/$TEST.g");
EOI

cd $DIR/latex 

$DIR/scripts/createTex.sh $TEST BaseGroup header main
$DIR/scripts/createTex.sh $TEST BaseProfile header table1
$DIR/scripts/createTex.sh $TEST ExtendedProfile header table2
