#! /bin/csh -f
# echo --- making next level shell script
rm -f nextlevel.csh > /dev/null 2>&1
$PARAMSEARCH_DIR/makenextlevel-$2 $1 > nextlevel.csh
chmod +x nextlevel.csh
rm -f ana-tmp > /dev/null 2>&1
