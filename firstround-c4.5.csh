#! /bin/csh -f
rm ana-tmp >& /dev/null
rm $2*.out >& /dev/null
touch ana-tmp
foreach m ( 1 2 5 10 20 50 100 200 500 )
  foreach c ( 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 )

    c4.5 -f $1 -u -b -m $m -c $c > $1.out
    echo m-$m=c-$c >> ana-tmp
    grep "<<" $1.out | tail -n 1 | cut -d"(" -f3 | cut -d"%" -f 1 >> ana-tmp
    rm -f $1.out >& /dev/null

    c4.5 -f $1 -u -b -m $m -c $c -g > $1.out
    echo m-$m=c-$c=g >> ana-tmp
    grep "<<" $1.out | tail -n 1 | cut -d"(" -f3 | cut -d"%" -f 1 >> ana-tmp
    rm -f $1.out >& /dev/null

  end
end
rm ana-sorted >& /dev/null
$PARAMSEARCH_DIR/ana-convert ana-tmp | sort -k 1,1n -k2,2 > ana-sorted
