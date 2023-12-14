#!/bin/bash

# go to root of repo
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $script_dir/../..
echo "Working in folder $(pwd)"

# get operating system
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac


# Post-processing for the extracted examples from the documentation.
# - Add a "\n" to all Print executions.
# - Move files into test_dir
test_dir="tst/files/doc"
mkdir -p $test_dir
files=($(ls -1 tst/lins*.tst))
echo "Found ${#files[@]} test file(s)"
for file in ${files[@]}; do
    echo "Processing $file"
    if [ "${machine}" == "Mac" ]; then
        sed -i "" 's|Print(\(.*\));|Print(\1, \"\\n\");|g' $file
    elif [ "${machine}" == "Linux" ]; then
        sed -i 's|Print(\(.*\));|Print(\1, \"\\n\");|g' $file
    else
        echo "ERROR: Unsupported operating system ${machine}"
        exit 1
    fi;
    mv $file $test_dir/${file#"tst/"}
done