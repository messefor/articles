#! /bin/bash

file1=src/file1.tar.gz
file2=src/file2.tar.gz

cmt=`cmp $file1 $file2`
if [ $? -eq 0 ]; then
  echo $cmt
fi





