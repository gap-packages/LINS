#!/bin/bash

DIR=$1
TEST=$2
SCRIPTS="$DIR/scripts"
TESTFILES="$DIR/testfiles"
OUTPUT="$DIR/output/$TEST"
LATEX="$DIR/latex"

cd $DIR/..
gap64 -r -b -q -T << EOI
Read("$TESTFILES/$TEST.g");
EOI

echo "\documentclass{test}" > $LATEX/$TEST.tex
echo "\begin{document}" >> $LATEX/$TEST.tex

for SUBTEST in $OUTPUT/*/; do
  SUBTEST=${SUBTEST%*/}
  FILE=$SUBTEST/main.txt
  $SCRIPTS/convertToTex.sh $TEST < $FILE
  
  for FILE in $SUBTEST/table*; do
    $SCRIPTS/convertToTable.sh $LATEX/$TEST.tex < $FILE
  done
done

echo "\end{document}" >> $LATEX/$TEST.tex;

cd $LATEX
latexmk $TEST.tex 
#latexmk -silent $TEST.tex test.cls
