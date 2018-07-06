#!/bin/bash

DIR=$1
TEST=$2

# Create all .tex files from the testfile
cd $DIR/..
gap64 -r -b -q -T << EOI
Read("./lowIndexNormal.gd");
Read("./tests/scripts/fctsProfileDefinition.g");
Read("./tests/scripts/header.g");
Read("./tests/scripts/mainTable.g");
Read("./tests/scripts/profileTable.g");
Read("./tests/scripts/raw.g");
Read("./tests/testfiles/$TEST.g");
EOI

cd $DIR/latex 

$DIR/scripts/createTex.sh $TEST BaseGroup header main
$DIR/scripts/createTex.sh $TEST BaseProfile header table1
$DIR/scripts/createTex.sh $TEST ExtendedProfile header table2
