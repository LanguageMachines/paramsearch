#! /bin/csh -f
rm ana-tmp > /dev/null 2>&1
rm $2*.out > /dev/null 2>&1
touch ana-tmp
foreach w ( 0 1 2 )
  Fambl -f $1 -t $2 -a -b -k1 -g$w -m0 -p
  foreach file (`ls $2*.%`)
    echo $file >> ana-tmp
    cat $file >> ana-tmp
    rm $2*.out > /dev/null 2>&1
    rm $2*.% > /dev/null 2>&1
  end
  if ( $3 == "1" ) then
    Fambl -f $1 -t $2 -a -b -k1 -g$w -m1 -p
    Fambl -f $1 -t $2 -a -b -k1 -g$w -m2 -p
    foreach file (`ls $2*.%`)
      echo $file >> ana-tmp
      cat $file >> ana-tmp
    end
    rm $2*.out > /dev/null 2>&1
    rm $2*.% > /dev/null 2>&1
  else
    foreach l ( 1 2 )
      Fambl -f $1 -t $2 -a -b -k1 -g$w -m1 -L$l -p
      Fambl -f $1 -t $2 -a -b -k1 -g$w -m2 -L$l -p
      foreach file (`ls $2*.%`)
        echo $file >> ana-tmp
        cat $file >> ana-tmp
      end
      rm $2*.out > /dev/null 2>&1
      rm $2*.% > /dev/null 2>&1
    end
  endif
end
foreach k ( 3 5 7 9 11 15 19 25 35 )
  foreach d ( 0 1 2 3 )
    foreach w ( 0 1 2 )
      Fambl -f $1 -t $2 -a -b -k$k -g$w -m0 -d$d -p
      foreach file (`ls $2*.%`)
        echo $file >> ana-tmp
        cat $file >> ana-tmp
        rm $2*.out > /dev/null 2>&1
        rm $2*.% > /dev/null 2>&1
      end
        if ( $3 == "1" ) then
        Fambl -f $1 -t $2 -a -b -k$k -g$w -m1 -d$d -p
        Fambl -f $1 -t $2 -a -b -k$k -g$w -m2 -d$d -p
        foreach file (`ls $2*.%`)
          echo $file >> ana-tmp
          cat $file >> ana-tmp
        end
        rm $2*.out > /dev/null 2>&1
        rm $2*.% > /dev/null 2>&1
      else
        foreach l ( 1 2 )
          Fambl -f $1 -t $2 -a -b -k$k -g$w -m1 -d$d -L$l -p
          Fambl -f $1 -t $2 -a -b -k$k -g$w -m2 -d$d -L$l -p
          foreach file (`ls $2*.%`)
            echo $file >> ana-tmp
            cat $file >> ana-tmp
          end
          rm $2*.out > /dev/null 2>&1
          rm $2*.% > /dev/null 2>&1
        end
      endif
    end
  end
end
rm -f ana-sorted > /dev/null 2>&1
$PARAMSEARCH_DIR/ana-convert ana-tmp | sort -k 1,1nr -k2,2 > ana-sorted
