#!/bin/bash

DIR=$1
TEST=$2
TESTFILES="$DIR/testfiles"
LATEX="$DIR/latex"

# Create all .tex files from the testfile
cd $DIR/..
gap64 -r -b -q -T << EOI
Read("$TESTFILES/$TEST.g");
EOI

cd $LATEX 


# Base Group File
FILE=${TEST}BaseGroup.tex
echo "\documentclass{test}" > ./$FILE
echo "\begin{document}" >> ./$FILE
for SUBTEST in ./$TEST/*/; do
  SUBTEST=${SUBTEST%*/}
  SUBTEST=./$TEST/${SUBTEST##*/}
  echo "\input{${SUBTEST}/header.tex}" >> ./$FILE
  echo "\input{${SUBTEST}/main.tex}" >> ./$FILE
done
echo "\end{document}" >> ./$FILE
latexmk -silent $FILE


# Base Profile File
FILE=${TEST}BaseProfile.tex
echo "\documentclass{test}" > ./$FILE
echo "\begin{document}" >> ./$FILE
for SUBTEST in ./$TEST/*/; do
  SUBTEST=${SUBTEST%*/}
  SUBTEST=./$TEST/${SUBTEST##*/}
  echo "\input{${SUBTEST}/header.tex}" >> ./$FILE
  echo "\input{${SUBTEST}/table1.tex}" >> ./$FILE
done
echo "\end{document}" >> ./$FILE
latexmk -silent $FILE


# Extended Profile File
FILE=${TEST}ExtendedProfile.tex
echo "\documentclass{test}" > ./$FILE
echo "\begin{document}" >> ./$FILE
for SUBTEST in ./$TEST/*/; do
  SUBTEST=${SUBTEST%*/}
  SUBTEST=./$TEST/${SUBTEST##*/}
  echo "\input{${SUBTEST}/header.tex}" >> ./$FILE
  echo "\input{${SUBTEST}/table2.tex}" >> ./$FILE
done
echo "\end{document}" >> ./$FILE
latexmk -silent $FILE
