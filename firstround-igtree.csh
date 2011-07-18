#! /bin/csh -f
rm ana-tmp >& /dev/null
rm $2*.out >& /dev/null
touch ana-tmp
foreach w ( 0 1 2 )
  timbl -f $1 -t $2 -a1 -w$w +%
  foreach file (`ls $2*.%`)
    echo $file >> ana-tmp
    head -n 1 $file >> ana-tmp
  end
  rm $2*.out >& /dev/null
  rm $2*.% >& /dev/null
end
rm -f ana-sorted >& /dev/null
$PARAMSEARCH_DIR/ana-convert ana-tmp | sort -k 1,1nr -k2,2 > ana-sorted
