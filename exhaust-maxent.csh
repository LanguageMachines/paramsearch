#! /bin/csh -f
if ( -f $1.maxent.bestsetting ) then
  echo "$1.maxent.bestsetting already exists" ; exit 1
endif

if ( $2 == "10" ) then
  foreach p ( 0 1 2 3 4 5 6 7 8 9 )
    echo fold $p
    $PARAMSEARCH_DIR/partition-factor $1 10 $p 24101997 > /dev/null 2>&1
    rm -f $1*.model > /dev/null 2>&1
    rm -f $1*.out > /dev/null 2>&1
    rm -f ana-tmp.$p > /dev/null 2>&1
    touch ana-tmp.$p
    foreach g ( 0.0 1 1.4142 2.2360 3.1622 10 31.6227 )

      maxent $1.$p.data -m $1.$p.model -g $g --lbfgs -i 100 -b -c0
      maxent -p -m $1.$p.model $1.$p.test > $1.$p.test.out
      echo e---lbfgs=g-$g >> ana-tmp.$p
      cut -c11- $1.$p.test.out | cut -d"%" -f1 >> ana-tmp.$p
      rm $1.$p.test.out > /dev/null 2>&1
      rm $1.$p.model > /dev/null 2>&1

      maxent $1.$p.data -m $1.$p.model -g $g --gis -i 100 -b -c0
      maxent -p -m $1.$p.model $1.$p.test > $1.$p.test.out
      echo e---gis=g-$g >> ana-tmp.$p
      cut -c11- $1.$p.test.out | cut -d"%" -f1 >> ana-tmp.$p
      rm $1.$p.test.out > /dev/null 2>&1
      rm $1.$p.model > /dev/null 2>&1

    end
    $PARAMSEARCH_DIR/ana-convert ana-tmp.$p | sort -k 1,1nr -k2,2 > $1.exhaust.$p
    rm -f ana-tmp.$p > /dev/null 2>&1
    rm -f $1.$p.data $1.$p.test > /dev/null 2>&1
  end
else
  if ( $2 == "5" ) then
    foreach p ( 0 1 2 3 4 )
      echo fold $p
      $PARAMSEARCH_DIR/partition-factor $1 5 $p 24101997 > /dev/null 2>&1
      rm -f $1*.model > /dev/null 2>&1
      rm -f $1*.out > /dev/null 2>&1
      rm -f ana-tmp.$p > /dev/null 2>&1
      touch ana-tmp.$p
      foreach g ( 0.0 1 1.4142 2.2360 3.1622 10 31.6227 )

        maxent $1.$p.data -m $1.$p.model -g $g --lbfgs -i 100 -b -c0
        maxent -p -m $1.$p.model $1.$p.test > $1.$p.test.out
        echo e---lbfgs=g-$g >> ana-tmp.$p
        cut -c11- $1.$p.test.out | cut -d"%" -f1 >> ana-tmp.$p
        rm $1.$p.test.out > /dev/null 2>&1
        rm $1.$p.model > /dev/null 2>&1

        maxent $1.$p.data -m $1.$p.model -g $g --gis -i 100 -b -c0
        maxent -p -m $1.$p.model $1.$p.test > $1.$p.test.out
        echo e---gis=g-$g >> ana-tmp.$p
        cut -c11- $1.$p.test.out | cut -d"%" -f1 >> ana-tmp.$p
        rm $1.$p.test.out > /dev/null 2>&1
        rm $1.$p.model > /dev/null 2>&1

      end
      $PARAMSEARCH_DIR/ana-convert ana-tmp.$p | sort -k 1,1nr -k2,2 > $1.exhaust.$p
      rm -f ana-tmp.$p > /dev/null 2>&1
      rm -f $1.$p.data $1.$p.test > /dev/null 2>&1
    end
  else
    foreach p ( 0 1 )
      echo fold $p
      $PARAMSEARCH_DIR/partition-factor $1 2 $p 24101997 > /dev/null 2>&1
      rm -f $1*.model > /dev/null 2>&1
      rm -f $1*.out > /dev/null 2>&1
      rm -f ana-tmp.$p > /dev/null 2>&1
      touch ana-tmp.$p
      foreach g ( 0.0 1 1.4142 2.2360 3.1622 10 31.6227 )

        maxent $1.$p.data -m $1.$p.model -g $g --lbfgs -i 100 -b -c0
        maxent -p -m $1.$p.model $1.$p.test > $1.$p.test.out
        echo e---lbfgs=g-$g >> ana-tmp.$p
        cut -c11- $1.$p.test.out | cut -d"%" -f1 >> ana-tmp.$p
        rm $1.$p.test.out > /dev/null 2>&1
        rm $1.$p.model > /dev/null 2>&1

        maxent $1.$p.data -m $1.$p.model -g $g --gis -i 100 -b -c0
        maxent -p -m $1.$p.model $1.$p.test > $1.$p.test.out
        echo e---gis=g-$g >> ana-tmp.$p
        cut -c11- $1.$p.test.out | cut -d"%" -f1 >> ana-tmp.$p
        rm $1.$p.test.out > /dev/null 2>&1
        rm $1.$p.model > /dev/null 2>&1

      end
      $PARAMSEARCH_DIR/ana-convert ana-tmp.$p | sort -k 1,1nr -k2,2 > $1.exhaust.$p
      rm -f ana-tmp.$p > /dev/null 2>&1
      rm -f $1.$p.data $1.$p.test > /dev/null 2>&1
    end
  endif
endif

rm -f $1.exhaust.averages > /dev/null 2>&1
touch $1.exhaust.averages
cut -d" " -f2- $1.exhaust.0 | sort > $1.mega-settings
foreach setting ( `cat $1.mega-settings` )
  echo $setting >> $1.exhaust.averages
  rm -f ana-grep > /dev/null 2>&1
  grep $setting $1.exhaust.? > ana-grep
  rm -f ana-data > /dev/null 2>&1
  cut -d":" -f2 ana-grep | cut -d" " -f1 > ana-data
  rm -f ana-data2 > /dev/null 2>&1
  cat ana-data $PARAMSEARCH_DIR/filler > ana-data2
  $PARAMSEARCH_DIR/meanstd < ana-data2 | grep "mean:" | cut -c19- >> $1.exhaust.averages
end
rm -f ana-data ana-data2 ana-grep > /dev/null 2>&1
rm -f $1.maxent.bestsetting > /dev/null 2>&1
rm -f $1.exhaust.? > /dev/null 2>&1
rm -f $1.mega-settings > /dev/null 2>&1
$PARAMSEARCH_DIR/ana-convert $1.exhaust.averages | sort -k 1,1nr -k2,2 | head -n 1 > $1.maxent.bestsetting
rm -f $1.maxent.log > /dev/null 2>&1
$PARAMSEARCH_DIR/ana-convert $1.exhaust.averages | sort -k 1,1nr -k2,2 > $1.maxent.log
rm -f $1.exhaust.averages > /dev/null 2>&1
echo "best setting found: " ; cat $1.maxent.bestsetting
