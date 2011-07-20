#! /bin/csh -f
rm ana-tmp >& /dev/null
rm $1.out >& /dev/null
touch ana-tmp
foreach f ( 1 2 5 10 20 50 )
  foreach a ( +freq -freq unordered )
    foreach n ( -n -\!n )
      foreach s ( 0.5 1.0 2.0 )
        foreach o ( 0 1 2 )
	  if ( $2 == "0" ) then
            ripper $1 -O$o -F$f -S$s -a$a $n >& $1.out
            echo f-$f=a-$a=n-$n=s-$s=o-$o >> ana-tmp
            grep "Test" $1.out | cut -c20- | cut -d"%" -f1 >> ana-tmp
            rm -f $1.out >& /dev/null
	    rm -f $1.hyp >& /dev/null
	  else
            foreach l ( 0.5 1.0 2.0 )
              ripper $1 -L$l -O$o -F$f -S$s -a$a $n >& $1.out
              echo f-$f=a-$a=n-$n=s-$s=o-$o=l-$l >> ana-tmp
              grep "Test" $1.out | cut -c20- | cut -d"%" -f1 >> ana-tmp
              rm -f $1.out >& /dev/null
	      rm -f $1.hyp >& /dev/null
            end
	  endif
        end
      end
    end
  end
end
rm ana-sorted >& /dev/null
$PARAMSEARCH_DIR/ana-convert ana-tmp | sort -k 1,1n -k2,2 > ana-sorted
