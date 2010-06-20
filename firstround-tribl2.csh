#! /bin/csh -f
rm ana-tmp >& /dev/null
rm $2*.out >& /dev/null
touch ana-tmp
foreach w ( 0 1 2 )
  Timbl -f $1 -t $2 -a4 -k1 -w$w -mO$5 +%
  foreach file (`ls $2*.%`)
    echo $file >> ana-tmp
    head -n 1 $file >> ana-tmp
  end
  rm $2*.out >& /dev/null
  rm $2*.% >& /dev/null
  if ( $3 == "1" ) then
    Timbl -f $1 -t $2 -a4 -k1 -w$w -mM$5 +%
    Timbl -f $1 -t $2 -a4 -k1 -w$w -mJ$5 +%
    foreach file (`ls $2*.%`)
      echo $file >> ana-tmp
      head -n 1 $file >> ana-tmp
    end
    rm $2*.out >& /dev/null
    rm $2*.% >& /dev/null
  else
    foreach l ( 1 2 )
      Timbl -f $1 -t $2 -a4 -k1 -w$w -mM$5 -L$l +%
      Timbl -f $1 -t $2 -a4 -k1 -w$w -mJ$5 -L$l +%
      foreach file (`ls $2*.%`)
        echo $file >> ana-tmp
        head -n 1 $file >> ana-tmp
      end
      rm $2*.out >& /dev/null
      rm $2*.% >& /dev/null
    end
  endif
end
foreach k ( 3 5 7 9 11 15 19 25 35 )
  foreach d ( Z IL ID ED1 )
    foreach w ( 0 1 2 )
      Timbl -f $1 -t $2 -a4 -k$k -w$w -mO$5 -d$d +%
      foreach file (`ls $2*.%`)
        echo $file >> ana-tmp
        head -n 1 $file >> ana-tmp
      end
      rm $2*.out >& /dev/null
      rm $2*.% >& /dev/null
      if ( $3 == "1" ) then
        Timbl -f $1 -t $2 -a4 -k$k -w$w -mM$5 -d$d +%
        Timbl -f $1 -t $2 -a4 -k$k -w$w -mJ$5 -d$d +%
        foreach file (`ls $2*.%`)
          echo $file >> ana-tmp
          head -n 1 $file >> ana-tmp
        end
        rm $2*.out >& /dev/null
        rm $2*.% >& /dev/null
      else
        foreach l ( 1 2 )
          Timbl -f $1 -t $2 -a4 -k$k -w$w -mM$5 -d$d -L$l +%
          Timbl -f $1 -t $2 -a4 -k$k -w$w -mJ$5 -d$d -L$l +%
          foreach file (`ls $2*.%`)
            echo $file >> ana-tmp
            head -n 1 $file >> ana-tmp
          end
          rm $2*.out >& /dev/null
          rm $2*.% >& /dev/null
        end
      endif
    end
  end
end
rm -f ana-sorted >& /dev/null
$PARAMSEARCH_DIR/ana-convert ana-tmp | sort -k 1,1nr -k2,2 > ana-sorted
