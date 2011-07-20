#! /bin/csh -f
rm ana-tmp > /dev/null 2>&1
rm $1.out > /dev/null 2>&1
touch ana-tmp
foreach p ( 1.05 1.1 1.25 1.5 )
  foreach d ( 0.75 0.9 0.95 )
    foreach t ( 1.0 2.0 4.0 )
      foreach r ( 2 5 10 )
        foreach s ( 0.0 0.1 0.2 0.5 1.0 2.0 4.0 )
          snow -train -g - -I $1 -F $1.net -W $p,$d,$t,1\:0-$3 -r $r -S $s
          snow -test -I $2 -F $1.net > $1.out
          echo p-$p=d-$d=t-$t=c-$3=r-$r=s-$s >> ana-tmp
          tail -n 1 $1.out | cut -c20- | cut -d"%" -f1 >> ana-tmp
          rm $1.net $1.out > /dev/null 2>&1
        end
      end
    end
  end
end
rm ana-sorted > /dev/null 2>&1
$PARAMSEARCH_DIR/ana-convert ana-tmp | sort -k 1,1nr -k2,2 > ana-sorted
