#! /bin/csh -f
# echo -------------------------------------------------------
# echo iterative deepening parameter selection, Antal Sep 2002
# date
if ( -f $1.$2.bestsetting ) then
  echo "$1.$2.bestsetting already exists" ; exit 1
endif
rm -f $1.$2.log >& /dev/null
touch $1.$2.log
if ( $2 == "ripper" || $2 == "c4.5" ) then
  head -n 500 $5 > $1.data
else
  head -n 500 $5 > $1.id
endif
tail -n 100 $5 > $1.test
if ( $2 == "ripper" || $2 == "c4.5" ) then
  $PARAMSEARCH_DIR/firstround-$2.csh $1 $4 >& /dev/null
else
  if ( $2 == "winnow" || $2 == "perceptron" ) then
    $PARAMSEARCH_DIR/firstround-$2.csh $1.id $1.test $6 >& /dev/null
  else
    $PARAMSEARCH_DIR/firstround-$2.csh $1.id $1.test $3 $4 $6 >& /dev/null
  endif
endif
rm -f nextlevel.csh >& /dev/null
$PARAMSEARCH_DIR/makenextlevel-$2 $1 > nextlevel.csh
chmod +x nextlevel.csh
rm -f ana-tmp >& /dev/null
mv ana-sorted $1.step500
echo ---------- stepsize 500 --------- >> $1.$2.log
cat $1.step500 >> $1.$2.log
rm -f $1*.out >& /dev/null
foreach c ( `cat $1.steplist` )
  if ( $2 == "ripper" || $2 == "c4.5" ) then
    head -n $c $5 > $1.data
  else
    head -n $c $5 > $1.id
  endif
  tail -n `echo "$c/5" |bc` $5 > $1.test
  echo stepsize $c
  if ( $2 == "ripper" || $2 == "c4.5" ) then
    ./nextlevel.csh $1 >& /dev/null
  else
    ./nextlevel.csh $1.id $1.test >& /dev/null
  endif
  $PARAMSEARCH_DIR/analysebunch.csh $1 $2
  mv ana-sorted $1.step$c
  echo ---------- stepsize $c --------- >> $1.$2.log
  cat $1.step$c >> $1.$2.log   
  rm -f $1*.out >& /dev/null
end
foreach c (`tail -n 1 $1.steplist`)
  head -n 1 $1.step$c > $1.$2.bestsetting
end
rm -f $1.step* >& /dev/null
rm -f $1.test >& /dev/null
if ( $2 == "ripper" || $2 == "c4.5" ) then
  rm -f $1.data >& /dev/null
  rm -f $1.hyp >& /dev/null
else
  rm -f $1.id >& /dev/null
endif
rm -f nextlevel.csh >& /dev/null
if ( $2 == "svmlight" ) then
  rm -f svm_predictions >& /dev/null
endif
echo "best setting found: " ; cat $1.$2.bestsetting
