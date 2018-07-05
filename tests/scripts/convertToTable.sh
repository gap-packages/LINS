#!/bin/bash

FILE=$1

IsFirstLine=true
LineLength=0

while read LineOriginal; do
    LineConverted=""
    
    for Word in $LineOriginal; do 
      if [ "$IsFirstLine" = true ]; then
        LineLength=$((LineLength+1))
      fi
      LineConverted="$LineConverted $Word &"
    done
    
    if [ "$IsFirstLine" = true ]; then
      echo "\begin{center}" >> $FILE
      FirstLine="\begin{tabular}{||"
      for Counter in $(seq 1 1 $LineLength); do
        FirstLine="$FirstLine c"
      done
      FirstLine="$FirstLine ||}"
      echo $FirstLine >> $FILE
      echo "\hline" >> $FILE
      IsFirstLine=false
    fi
    
    echo "${LineConverted: 0 : -1}\\\\" >> $FILE
    echo "\hline" >> $FILE
done

echo "\end{tabular}" >> $FILE
echo "\end{center}" >> $FILE
