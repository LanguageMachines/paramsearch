#! /bin/csh -f
if ( -f $1.fambl.bestsetting ) then
  echo "$1.fambl.bestsetting already exists" ; exit 1
endif

if ( $2 == "10" ) then
  foreach p ( 0 1 2 3 4 5 6 7 8 9 )
    echo fold $p
    $PARAMSEARCH_DIR/partition-factor $1 10 $p 24101997 >& /dev/null
    rm -f $1*.out >& /dev/null
    rm -f ana-tmp.$p >& /dev/null
    touch ana-tmp.$p
    foreach k ( 1 2 3 5 7 )
      foreach K ( 1 2 3 5 7 )
        foreach g ( 0 1 2 )
          Fambl -f $1.$p.data -t $1.$p.test -k$k -K$K -g$g -m0 -p >& /dev/null
          foreach file (`ls $1*.%`)
            echo $file >> ana-tmp.$p
            cat $file >> ana-tmp.$p
            rm $1*.out >& /dev/null
            rm $1*.% >& /dev/null
          end
          if ( $3 == "1" ) then
            Fambl -f $1.$p.data -t $1.$p.test -k$k -K$K -g$g -m1 -p >& /dev/null
            Fambl -f $1.$p.data -t $1.$p.test -k$k -K$K -g$g -m2 -p >& /dev/null
            foreach file (`ls $1*.%`)
              echo $file >> ana-tmp.$p
              cat $file >> ana-tmp.$p
            end
            rm $1*.out >& /dev/null
            rm $1*.% >& /dev/null
          else
            foreach l ( 1 2 )
              Fambl -f $1.$p.data -t $1.$p.test -k$k -K$K -g$g -m1 -L$l -p >& /dev/null
              Fambl -f $1.$p.data -t $1.$p.test -k$k -K$K -g$g -m2 -L$l -p >& /dev/null
              foreach file (`ls $1*.%`)
                echo $file >> ana-tmp.$p
                cat $file >> ana-tmp.$p
              end
              rm $1*.out >& /dev/null
              rm $1*.% >& /dev/null
            end
          endif
        end
      end
    end
    $PARAMSEARCH_DIR/ana-convert ana-tmp.$p | sort -k 1,1nr -k2,2 > $1.exhaust.$p
    rm -f ana-tmp.$p >& /dev/null
    rm -f $1.$p.data $1.$p.test >& /dev/null
  end
else
  if ( $2 == "5" ) then
    foreach p ( 0 1 2 3 4 )
      echo fold $p
      $PARAMSEARCH_DIR/partition-factor $1 5 $p 24101997 >& /dev/null
      rm -f $1*.out >& /dev/null
      rm -f ana-tmp.$p >& /dev/null
      touch ana-tmp.$p
      foreach k ( 1 2 3 5 7 )
        foreach K ( 1 2 3 5 7 )
          foreach g ( 0 1 2 )
            Fambl -f $1.$p.data -t $1.$p.test -k$k -K$K -g$g -m0 -p >& /dev/null
            foreach file (`ls $1*.%`)
              echo $file >> ana-tmp.$p
              cat $file >> ana-tmp.$p
            end
            rm $1*.out >& /dev/null
            rm $1*.% >& /dev/null
            if ( $3 == "1" ) then
              Fambl -f $1.$p.data -t $1.$p.test -k$k -K$K -g$g -m1 -p >& /dev/null
              Fambl -f $1.$p.data -t $1.$p.test -k$k -K$K -g$g -m2 -p >& /dev/null
              foreach file (`ls $1*.%`)
                echo $file >> ana-tmp.$p
                cat $file >> ana-tmp.$p
              end
              rm $1*.out >& /dev/null
              rm $1*.% >& /dev/null
            else
              foreach l ( 1 2 )
                Fambl -f $1.$p.data -t $1.$p.test -k$k -K$K -g$g -m1 -L$l -p >& /dev/null
                Fambl -f $1.$p.data -t $1.$p.test -k$k -K$K -g$g -m2 -L$l -p >& /dev/null
                foreach file (`ls $1*.%`)
                  echo $file >> ana-tmp.$p
                  cat $file >> ana-tmp.$p
                end
                rm $1*.out >& /dev/null
                rm $1*.% >& /dev/null
              end
            endif
          end
        end
      end
      $PARAMSEARCH_DIR/ana-convert ana-tmp.$p | sort -k 1,1nr -k2,2 > $1.exhaust.$p
      rm -f ana-tmp.$p >& /dev/null
      rm -f $1.$p.data $1.$p.test >& /dev/null
    end
  else
    foreach p ( 0 1 )
      echo fold $p
      $PARAMSEARCH_DIR/partition-factor $1 2 $p 24101997 >& /dev/null
      rm -f $1*.out >& /dev/null
      rm -f ana-tmp.$p >& /dev/null
      touch ana-tmp.$p
      foreach k ( 1 2 3 5 7 )
        foreach K ( 1 2 3 5 7 )
          foreach g ( 0 1 2 )
            Fambl -f $1.$p.data -t $1.$p.test -k$k -K$K -g$g -m0 -p >& /dev/null
            foreach file (`ls $1*.%`)
              echo $file >> ana-tmp.$p
              cat $file >> ana-tmp.$p
            end
            rm $1*.out >& /dev/null
            rm $1*.% >& /dev/null
            if ( $3 == "1" ) then
              Fambl -f $1.$p.data -t $1.$p.test -k$k -K$K -g$g -m1 -p >& /dev/null
              Fambl -f $1.$p.data -t $1.$p.test -k$k -K$K -g$g -m2 -p >& /dev/null
              foreach file (`ls $1*.%`)
                echo $file >> ana-tmp.$p
                cat $file >> ana-tmp.$p
              end
              rm $1*.out >& /dev/null
              rm $1*.% >& /dev/null
            else
              foreach l ( 1 2 )
                Fambl -f $1.$p.data -t $1.$p.test -k$k -K$K -g$g -m1 -L$l -p >& /dev/null
                Fambl -f $1.$p.data -t $1.$p.test -k$k -K$K -g$g -m2 -L$l -p >& /dev/null
                foreach file (`ls $1*.%`)
                  echo $file >> ana-tmp.$p
                  cat $file >> ana-tmp.$p
                end
                rm $1*.out >& /dev/null
                rm $1*.% >& /dev/null
              end
            endif
          end
        end
      end
      $PARAMSEARCH_DIR/ana-convert ana-tmp.$p | sort -k 1,1nr -k2,2 > $1.exhaust.$p
      rm -f ana-tmp.$p >& /dev/null
      rm -f $1.$p.data $1.$p.test >& /dev/null
    end
  endif  
endif

rm -f $1.exhaust.averages >& /dev/null
touch $1.exhaust.averages
cut -d" " -f2- $1.exhaust.0 | sort > $1.mega-settings
foreach setting ( `cat $1.mega-settings` )
  echo $setting >> $1.exhaust.averages
  rm -f ana-grep >& /dev/null
  grep $setting $1.exhaust.? > ana-grep
  rm -f ana-data >& /dev/null
  cut -d":" -f2 ana-grep | cut -d" " -f1 > ana-data
  rm -f ana-data2 >& /dev/null
  cat ana-data $PARAMSEARCH_DIR/filler > ana-data2
  $PARAMSEARCH_DIR/meanstd < ana-data2 | grep "mean:" | cut -c19- >> $1.exhaust.averages
end
rm -f ana-data ana-data2 ana-grep >& /dev/null
rm -f $1.fambl.bestsetting >& /dev/null
rm -f $1.exhaust.? >& /dev/null
rm -f $1.mega-settings >& /dev/null
$PARAMSEARCH_DIR/ana-convert $1.exhaust.averages | sort -k 1,1nr -k2,2 | head -n 1 > $1.fambl.bestsetting
rm -f $1.fambl.log >& /dev/null
$PARAMSEARCH_DIR/ana-convert $1.exhaust.averages | sort -k 1,1nr -k2,2 > $1.fambl.log
rm -f $1.exhaust.averages >& /dev/null
echo "best setting found: " ; cat $1.fambl.bestsetting
