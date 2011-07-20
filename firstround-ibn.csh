#! /bin/csh -f
rm ana-tmp > /dev/null 2>&1
rm $2*.out > /dev/null 2>&1
touch ana-tmp
foreach w ( 0 1 2 )
  timbl -f $1 -t $2 -a0 -k1 -w$w -mN$5 +%
  timbl -f $1 -t $2 -a0 -k1 -w$w -mD$5 +%
  foreach file (`ls $2*.%`)
    echo $file >> ana-tmp
    head -n 1 $file >> ana-tmp
  end
  rm $2*.out > /dev/null 2>&1
  rm $2*.% > /dev/null 2>&1
end
foreach k ( 3 5 7 9 11 15 19 25 35 )
  foreach d ( Z IL ID ED1 )
    foreach w ( 0 1 2 3 4 )
      timbl -f $1 -t $2 -a0 -k$k -w$w -mN$5 -d$d +%
      timbl -f $1 -t $2 -a0 -k$k -w$w -mD$5 -d$d +%
      foreach file (`ls $2*.%`)
        echo $file >> ana-tmp
        head -n 1 $file >> ana-tmp
      end
      rm $2*.out > /dev/null 2>&1
      rm $2*.% > /dev/null 2>&1
    end
  end
end
rm -f ana-sorted > /dev/null 2>&1
$PARAMSEARCH_DIR/ana-convert ana-tmp | sort -k 1,1nr -k2,2 > ana-sorted
