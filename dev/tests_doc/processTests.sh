#!/bin/bash

# go to root of repo
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $script_dir/../..
echo "Working in folder $(pwd)"

# Post-processing for the extracted examples from the documentation.
# - Move files into test_dir
test_dir="tst/files/doc"
mkdir -p $test_dir
files=($(ls -1 tst/lins*.tst))
echo "Found ${#files[@]} test file(s)"
for file in ${files[@]}; do
    echo "Processing $file"
    mv $file $test_dir/${file#"tst/"}
done
