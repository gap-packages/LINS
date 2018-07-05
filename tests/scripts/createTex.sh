TEST=$1
FILENAME=$2
FILE=${TEST}${FILENAME}.tex

echo "\documentclass{test}" > ./$FILE
echo "\usepackage{float}" >> ./$FILE
echo "\begin{document}" >> ./$FILE
echo "\title{${TEST}BaseGroup} \maketitle \noindent" >> ./$FILE
for SUBTEST in ./$TEST/*/; do
  SUBTEST=${SUBTEST%*/}
  SUBTEST=./$TEST/${SUBTEST##*/}
  COUNTER=1
  for TEX in $@; do
    if [ $COUNTER -le 2 ]; then
      COUNTER=$((COUNTER + 1))
      continue;
    fi
    echo "\input{${SUBTEST}/$TEX.tex}" >> ./$FILE
  done
done
echo "\end{document}" >> ./$FILE
latexmk -silent $FILE
