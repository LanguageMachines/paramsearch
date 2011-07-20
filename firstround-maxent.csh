#! /bin/csh -f
rm ana-tmp >& /dev/null
rm $2*.out >& /dev/null
touch ana-tmp
#foreach g ( 0.0 1 1.4142 2.2360 3.1622 10 31.6227 )
foreach g ( 0.0 0.01 0.015 0.02 0.03 0.04 0.05 0.06 0.08 0.1 0.15 0.2 0.3 0.4 0.5 0.6 0.8 1 1.5 2 3 4 5 6 8 10 15 20 30 40 50 60 80 100 )

  maxent $1 -m $1.model -g $g --lbfgs -i 100 -b -c 0
  maxent -p -m $1.model $2 > $2.out
  echo e---lbfgs=g-$g >> ana-tmp
  cut -c11- $2.out | cut -d"%" -f1 >> ana-tmp
  rm $2.out >& /dev/null
  rm $1.model >& /dev/null

  maxent $1 -m $1.model -g $g --gis -i 100 -b -c 0
  maxent -p -m $1.model $2 > $2.out
  echo e---gis=g-$g >> ana-tmp
  cut -c11- $2.out | cut -d"%" -f1 >> ana-tmp
  rm $2.out >& /dev/null
  rm $1.model >& /dev/null

end
rm ana-sorted >& /dev/null
$PARAMSEARCH_DIR/ana-convert ana-tmp | sort -k 1,1nr -k2,2 > ana-sorted
