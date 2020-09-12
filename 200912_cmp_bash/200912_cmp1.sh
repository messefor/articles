#! /bin/bash
# Compare all files in the first directory with those of the second directory

dir1=src1/  # 1st Directory
dir2=src2/  # 2nd Directory

fpaths=${dir1}*  # Fetch all file paths in the 1st directory

# Loop for all files
i=0
for f1path in $fpaths; do
  fnm=`basename $f1path`
  # echo $fnm
  f2path=${dir2}${fnm}
  cmt=`cmp $f1path $f2path`  # Compare 2 files
  if [ $? -eq 1 ]; then
    echo $cmt
    i=$(( $i + 1 ))
  fi
done

# If none of all files are different, print "the same"
if [ $i -eq 0 ]; then
  echo 'All file pairs are the same.'
fi



