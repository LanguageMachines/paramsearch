#! /bin/csh -f
if ( -f $1.c4.5.bestsetting ) then
  echo "$1.c4.5.bestsetting already exists" ; exit 1
endif
if ( -f $1.names ) then
  echo "OK, names file $1.names exists"
else
  echo "names file $1.names does not exist" ; exit 1
endif

if ( $2 == "10" ) then
  foreach p ( 0 1 2 3 4 5 6 7 8 9 )
    echo fold $p
    $PARAMSEARCH_DIR/partition-factor $1 10 $p 24101997 >& /dev/null
    cp $1.names $1.$p.names
    rm -f $1*.out >& /dev/null
    rm -f ana-tmp.$p >& /dev/null
    touch ana-tmp.$p
    foreach m ( 1 2 5 10 20 50 100 200 500 )
      foreach c ( 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 )

        c4.5 -f $1.$p -u -b -m $m -c $c > $1.$p.out
        echo m-$m=c-$c >> ana-tmp.$p
        grep "<<" $1.$p.out | tail -n 1 | cut -d"(" -f3 | cut -d"%" -f 1 >> ana-tmp.$p
        rm -f $1.$p.out >& /dev/null

        c4.5 -f $1.$p -u -b -m $m -c $c -g > $1.$p.out
        echo m-$m=c-$c=g >> ana-tmp.$p
        grep "<<" $1.$p.out | tail -n 1 | cut -d"(" -f3 | cut -d"%" -f 1 >> ana-tmp.$p
        rm -f $1.$p.out >& /dev/null

      end
    end

    $PARAMSEARCH_DIR/ana-convert ana-tmp.$p | sort -k 1,1n -k2,2 > $1.exhaust.$p
    rm -f ana-tmp.$p >& /dev/null
    rm -f $1.$p.data $1.$p.test $1.$p.names >& /dev/null
  end
else
  if ( $2 == "5" ) then
    foreach p ( 0 1 2 3 4 )
      echo fold $p
      $PARAMSEARCH_DIR/partition-factor $1 5 $p 24101997 >& /dev/null
      cp $1.names $1.$p.names
      rm -f $1*.out >& /dev/null
      rm -f ana-tmp.$p >& /dev/null
      touch ana-tmp.$p
      foreach m ( 1 2 5 10 20 50 100 200 500 )
        foreach c ( 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 )

          c4.5 -f $1.$p -u -b -m $m -c $c > $1.$p.out
          echo m-$m=c-$c >> ana-tmp.$p
          grep "<<" $1.$p.out | tail -n 1 | cut -d"(" -f3 | cut -d"%" -f 1 >> ana-tmp.$p
          rm -f $1.$p.out >& /dev/null

          c4.5 -f $1.$p -u -b -m $m -c $c -g > $1.$p.out
          echo m-$m=c-$c=g >> ana-tmp.$p
          grep "<<" $1.$p.out | tail -n 1 | cut -d"(" -f3 | cut -d"%" -f 1 >> ana-tmp.$p
          rm -f $1.$p.out >& /dev/null

        end
      end

      $PARAMSEARCH_DIR/ana-convert ana-tmp.$p | sort -k 1,1n -k2,2 > $1.exhaust.$p
      rm -f ana-tmp.$p >& /dev/null
      rm -f $1.$p.data $1.$p.test $1.$p.names >& /dev/null
    end
  else
    foreach p ( 0 1 )
      echo fold $p
      $PARAMSEARCH_DIR/partition-factor $1 2 $p 24101997 >& /dev/null
      cp $1.names $1.$p.names
      rm -f $1*.out >& /dev/null
      rm -f ana-tmp.$p >& /dev/null
      touch ana-tmp.$p
      foreach m ( 1 2 5 10 20 50 100 200 500 )
        foreach c ( 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 )

          c4.5 -f $1.$p -u -b -m $m -c $c > $1.$p.out
          echo m-$m=c-$c >> ana-tmp.$p
          grep "<<" $1.$p.out | tail -n 1 | cut -d"(" -f3 | cut -d"%" -f 1 >> ana-tmp.$p
          rm -f $1.$p.out >& /dev/null

          c4.5 -f $1.$p -u -b -m $m -c $c -g > $1.$p.out
          echo m-$m=c-$c=g >> ana-tmp.$p
          grep "<<" $1.$p.out | tail -n 1 | cut -d"(" -f3 | cut -d"%" -f 1 >> ana-tmp.$p
          rm -f $1.$p.out >& /dev/null

        end
      end

      $PARAMSEARCH_DIR/ana-convert ana-tmp.$p | sort -k 1,1n -k2,2 > $1.exhaust.$p
      rm -f ana-tmp.$p >& /dev/null
      rm -f $1.$p.data $1.$p.test $1.$p.names >& /dev/null
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
rm -f $1.c4.5.bestsetting >& /dev/null
rm -f $1.exhaust.? >& /dev/null
rm -f $1.mega-settings >& /dev/null
$PARAMSEARCH_DIR/ana-convert $1.exhaust.averages | sort -k 1,1n -k2,2 | head -n 1 > $1.c4.5.bestsetting
rm -f $1.c4.5.log >& /dev/null
$PARAMSEARCH_DIR/ana-convert $1.exhaust.averages | sort -k 1,1n -k2,2 > $1.c4.5.log
rm -f $1.exhaust.averages >& /dev/null
echo "best setting found: " ; cat $1.c4.5.bestsetting
