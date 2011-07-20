#! /bin/csh -f
rm ana-tmp > /dev/null 2>&1
rm $2*.out > /dev/null 2>&1
touch ana-tmp
foreach k ( 1 2 3 5 7 )
  foreach K ( 1 2 3 5 7 )
    foreach w ( 0 1 2 )
      Fambl -f $1 -t $2 -k$k -K$K -g$w -m0 -p
      foreach file (`ls $2*.%`)
        echo $file >> ana-tmp
        cat $file >> ana-tmp
        rm $2*.out > /dev/null 2>&1
        rm $2*.% > /dev/null 2>&1
      end
      if ( $3 == "1" ) then
        Fambl -f $1 -t $2 -k$k -K$K -g$w -m1 -p
        Fambl -f $1 -t $2 -k$k -K$K -g$w -m2 -p
        foreach file (`ls $2*.%`)
          echo $file >> ana-tmp
          cat $file >> ana-tmp
        end
        rm $2*.out > /dev/null 2>&1
        rm $2*.% > /dev/null 2>&1
      else
        foreach l ( 1 2 )
          Fambl -f $1 -t $2 -k$k -K$K -g$w -m1 -L$l -p
          Fambl -f $1 -t $2 -k$k -K$K -g$w -m2 -L$l -p
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
