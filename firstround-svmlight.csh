#! /bin/csh -f
rm ana-tmp >& /dev/null
rm $2*.out >& /dev/null
touch ana-tmp
foreach j ( 0.5 1.0 2.0 )
  foreach c ( 0.001 0.005 0.01 0.05 1 5 10 50 100 500 1000 )
    foreach g ( 0.00025 0.0005 0.001 0.002 0.004 0.008 0.016 0.032 0.064 0.128 0.256 0.512 1.024 2.048 )
      svm_learn -t 2 -j $j -c $c -g $g $1 $1.model >& /dev/null
      svm_classify $2 $1.model >& $2.out
      echo c-$c=j-$j=t-2=g-$g >> ana-tmp
      grep "Accuracy" $2.out | cut -d":" -f2 | cut -d"%" -f1 >> ana-tmp
      rm $2.out >& /dev/null
      rm $1.model >& /dev/null
    end
    foreach d ( 1 2 3 4 5 )
      svm_learn -t 1 -j $j -c $c -d $d $1 $1.model >& /dev/null
      svm_classify $2 $1.model >& $2.out
      echo c-$c=j-$j=t-1=d-$d >> ana-tmp
      grep "Accuracy" $2.out | cut -d":" -f2 | cut -d"%" -f1 >> ana-tmp
      rm $2.out >& /dev/null
      rm $1.model >& /dev/null
    end
  end
end
rm ana-sorted >& /dev/null
$PARAMSEARCH_DIR/ana-convert ana-tmp | sort -k 1,1nr -k2,2 > ana-sorted
