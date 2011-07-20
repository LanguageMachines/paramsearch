#! /bin/csh -f
rm ana-tmp > /dev/null 2>&1
rm $1.out > /dev/null 2>&1
touch ana-tmp
foreach p ( 0.1 0.2 0.3 0.4 0.5 0.6 0.8 1.0 1.5 2.0 4.0 )
  foreach t ( 1.0 2.0 3.0 4.0 5.0 )
    foreach r ( 2 3 5 )
      foreach s ( 0.0 0.1 0.2 0.3 0.4 )
        snow -train -I $1 -F $1.net -P $p,$t,1\:0-$3 -r $r -S $s
        snow -test -I $2 -F $1.net > $1.out
        echo p-$p=t-$t=c-$3=r-$r=s-$s >> ana-tmp
        tail -n 1 $1.out | cut -c20- | cut -d"%" -f1 >> ana-tmp
        rm $1.net $1.out > /dev/null 2>&1
      end
    end
  end
end
rm ana-sorted > /dev/null 2>&1
$PARAMSEARCH_DIR/ana-convert ana-tmp | sort -k 1,1nr -k2,2 > ana-sorted
