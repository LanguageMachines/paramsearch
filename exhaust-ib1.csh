#! /bin/csh -f
if ( -f $1.ib1.bestsetting ) then
  echo "$1.ib1.bestsetting already exists" ; exit 1
endif

if ( $2 == "10" ) then
  foreach p ( 0 1 2 3 4 5 6 7 8 9 )
    echo fold $p
    $PARAMSEARCH_DIR/partition-factor $1 10 $p 24101997 >& /dev/null
    rm -f $1*.out >& /dev/null
    rm -f ana-tmp.$p >& /dev/null
    touch ana-tmp.$p

    foreach w ( 0 1 2 )
      timbl -f $1.$p.data -t $1.$p.test -a0 -k1 -w$w -mO$5 +% >& /dev/null
      foreach file (`ls $1*.%`)
        echo $file >> ana-tmp.$p
        head -n 1 $file >> ana-tmp.$p
        rm $1*.out >& /dev/null
        rm $1*.% >& /dev/null
      end
      if ( $3 == "1" ) then
        timbl -f $1.$p.data -t $1.$p.test -a0 -k1 -w$w -mM$5 +% >& /dev/null
        timbl -f $1.$p.data -t $1.$p.test -a0 -k1 -w$w -mJ$5 +% >& /dev/null
        foreach file (`ls $1*.%`)
          echo $file >> ana-tmp.$p
          head -n 1 $file >> ana-tmp.$p
        end
        rm $1*.out >& /dev/null
        rm $1*.% >& /dev/null
      else
        foreach l ( 1 2 )
          timbl -f $1.$p.data -t $1.$p.test -a0 -k1 -w$w -mM$5 -L$l +% >& /dev/null
          timbl -f $1.$p.data -t $1.$p.test -a0 -k1 -w$w -mJ$5 -L$l +% >& /dev/null
          foreach file (`ls $1*.%`)
            echo $file >> ana-tmp.$p
            head -n 1 $file >> ana-tmp.$p
          end
          rm $1*.out >& /dev/null
          rm $1*.% >& /dev/null
        end
      endif
    end
    foreach k ( 3 5 7 9 11 15 19 25 35 )
      foreach d ( Z IL ID ED1 )
        foreach w ( 0 1 2 )
          timbl -f $1.$p.data -t $1.$p.test -a0 -k$k -w$w -mO$5 -d$d +% >& /dev/null
          foreach file (`ls $1*.%`)
            echo $file >> ana-tmp.$p
            head -n 1 $file >> ana-tmp.$p
  	    rm $1*.out >& /dev/null
  	    rm $1*.% >& /dev/null
          end
	  if ( $3 == "1" ) then
  	    timbl -f $1.$p.data -t $1.$p.test -a0 -k$k -w$w -mM$5 -d$d +% >& /dev/null
  	    timbl -f $1.$p.data -t $1.$p.test -a0 -k$k -w$w -mJ$5 -d$d +% >& /dev/null
  	    foreach file (`ls $1*.%`)
  	      echo $file >> ana-tmp.$p
  	      head -n 1 $file >> ana-tmp.$p
            end
	    rm $1*.out >& /dev/null
  	    rm $1*.% >& /dev/null
          else
            foreach l ( 1 2 )
    	      timbl -f $1.$p.data -t $1.$p.test -a0 -k$k -w$w -mM$5 -d$d -L$l +% >& /dev/null
    	      timbl -f $1.$p.data -t $1.$p.test -a0 -k$k -w$w -mJ$5 -d$d -L$l +% >& /dev/null
  	        foreach file (`ls $1*.%`)
	        echo $file >> ana-tmp.$p
  	        head -n 1 $file >> ana-tmp.$p
              end
	      rm $1*.out >& /dev/null
	      rm $1*.% >& /dev/null
            end
          endif
        end
      end
    end
    $PARAMSEARCH_DIR/ana-convert ana-tmp.$p | sort -k 1,1nr -k2,2 > $1.exhaust.$p
    rm -f ana-tmp.$p >& /dev/null
    rm -f $1.$p.data $1.$p.test >& /dev/null
  end
else
  if ( $2 == "5" ) then
    foreach p ( 0 1 2 3 4 )
      echo fold $p
      $PARAMSEARCH_DIR/partition-factor $1 5 $p 24101997 >& /dev/null
      rm -f $1*.out >& /dev/null
      rm -f ana-tmp.$p >& /dev/null
      touch ana-tmp.$p
      foreach w ( 0 1 2 )
        timbl -f $1.$p.data -t $1.$p.test -a0 -k1 -w$w -mO$5 +% >& /dev/null
        foreach file (`ls $1*.%`)
          echo $file >> ana-tmp.$p
          head -n 1 $file >> ana-tmp.$p
          rm $1*.out >& /dev/null
          rm $1*.% >& /dev/null
        end
        if ( $3 == "1" ) then
          timbl -f $1.$p.data -t $1.$p.test -a0 -k1 -w$w -mM$5 +% >& /dev/null
          timbl -f $1.$p.data -t $1.$p.test -a0 -k1 -w$w -mJ$5 +% >& /dev/null
          foreach file (`ls $1*.%`)
            echo $file >> ana-tmp.$p
            head -n 1 $file >> ana-tmp.$p
          end
          rm $1*.out >& /dev/null
          rm $1*.% >& /dev/null
        else
          foreach l ( 1 2 )
            timbl -f $1.$p.data -t $1.$p.test -a0 -k1 -w$w -mM$5 -L$l +% >& /dev/null
            timbl -f $1.$p.data -t $1.$p.test -a0 -k1 -w$w -mJ$5 -L$l +% >& /dev/null
            foreach file (`ls $1*.%`)
              echo $file >> ana-tmp.$p
              head -n 1 $file >> ana-tmp.$p
            end
            rm $1*.out >& /dev/null
            rm $1*.% >& /dev/null
          end
        endif
      end
      foreach k ( 3 5 7 9 11 15 19 25 35 )
        foreach d ( Z IL ID ED1 )
          foreach w ( 0 1 2 )
            timbl -f $1.$p.data -t $1.$p.test -a0 -k$k -w$w -mO$5 -d$d +% >& /dev/null
            foreach file (`ls $1*.%`)
    	      echo $file >> ana-tmp.$p
    	      head -n 1 $file >> ana-tmp.$p
    	      rm $1*.out >& /dev/null
    	      rm $1*.% >& /dev/null
            end
  	    if ( $3 == "1" ) then
    	      timbl -f $1.$p.data -t $1.$p.test -a0 -k$k -w$w -mM$5 -d$d +% >& /dev/null
    	      timbl -f $1.$p.data -t $1.$p.test -a0 -k$k -w$w -mJ$5 -d$d +% >& /dev/null
    	      foreach file (`ls $1*.%`)
    	        echo $file >> ana-tmp.$p
    	        head -n 1 $file >> ana-tmp.$p
              end
    	      rm $1*.out >& /dev/null
    	      rm $1*.% >& /dev/null
            else
              foreach l ( 1 2 )
      	      timbl -f $1.$p.data -t $1.$p.test -a0 -k$k -w$w -mM$5 -d$d -L$l +% >& /dev/null
      	      timbl -f $1.$p.data -t $1.$p.test -a0 -k$k -w$w -mJ$5 -d$d -L$l +% >& /dev/null
    	        foreach file (`ls $1*.%`)
    	          echo $file >> ana-tmp.$p
    	          head -n 1 $file >> ana-tmp.$p
                end
    	        rm $1*.out >& /dev/null
    	        rm $1*.% >& /dev/null
              end
            endif
          end
        end
      end
      $PARAMSEARCH_DIR/ana-convert ana-tmp.$p | sort -k 1,1nr -k2,2 > $1.exhaust.$p
      rm -f ana-tmp.$p >& /dev/null
      rm -f $1.$p.data $1.$p.test >& /dev/null
    end
  else
    foreach p ( 0 1 )
      echo fold $p
      $PARAMSEARCH_DIR/partition-factor $1 2 $p 24101997 >& /dev/null
      rm -f $1*.out >& /dev/null
      rm -f ana-tmp.$p >& /dev/null
      touch ana-tmp.$p
      foreach w ( 0 1 2 )
        timbl -f $1.$p.data -t $1.$p.test -a0 -k1 -w$w -mO$5 +% >& /dev/null
        foreach file (`ls $1*.%`)
          echo $file >> ana-tmp.$p
          head -n 1 $file >> ana-tmp.$p
          rm $1*.out >& /dev/null
          rm $1*.% >& /dev/null
        end
        if ( $3 == "1" ) then
          timbl -f $1.$p.data -t $1.$p.test -a0 -k1 -w$w -mM$5 +% >& /dev/null
          timbl -f $1.$p.data -t $1.$p.test -a0 -k1 -w$w -mJ$5 +% >& /dev/null
          foreach file (`ls $1*.%`)
            echo $file >> ana-tmp.$p
            head -n 1 $file >> ana-tmp.$p
          end
          rm $1*.out >& /dev/null
          rm $1*.% >& /dev/null
        else
          foreach l ( 1 2 )
            timbl -f $1.$p.data -t $1.$p.test -a0 -k1 -w$w -mM$5 -L$l +% >& /dev/null
            timbl -f $1.$p.data -t $1.$p.test -a0 -k1 -w$w -mJ$5 -L$l +% >& /dev/null
            foreach file (`ls $1*.%`)
              echo $file >> ana-tmp.$p
              head -n 1 $file >> ana-tmp.$p
            end
            rm $1*.out >& /dev/null
            rm $1*.% >& /dev/null
          end
        endif
      end
      foreach k ( 3 5 7 9 11 15 19 25 35 )
        foreach d ( Z IL ID ED1 )
          foreach w ( 0 1 2 )
            timbl -f $1.$p.data -t $1.$p.test -a0 -k$k -w$w -mO$5 -d$d +% >& /dev/null
            foreach file (`ls $1*.%`)
    	      echo $file >> ana-tmp.$p
    	      head -n 1 $file >> ana-tmp.$p
    	      rm $1*.out >& /dev/null
    	      rm $1*.% >& /dev/null
            end
  	    if ( $3 == "1" ) then
    	      timbl -f $1.$p.data -t $1.$p.test -a0 -k$k -w$w -mM$5 -d$d +% >& /dev/null
    	      timbl -f $1.$p.data -t $1.$p.test -a0 -k$k -w$w -mJ$5 -d$d +% >& /dev/null
    	      foreach file (`ls $1*.%`)
    	        echo $file >> ana-tmp.$p
    	        head -n 1 $file >> ana-tmp.$p
              end
    	      rm $1*.out >& /dev/null
    	      rm $1*.% >& /dev/null
              else
                foreach l ( 1 2 )
      	        timbl -f $1.$p.data -t $1.$p.test -a0 -k$k -w$w -mM$5 -d$d -L$l +% >& /dev/null
      	        timbl -f $1.$p.data -t $1.$p.test -a0 -k$k -w$w -mJ$5 -d$d -L$l +% >& /dev/null
    	        foreach file (`ls $1*.%`)
    	          echo $file >> ana-tmp.$p
    	          head -n 1 $file >> ana-tmp.$p
                end
    	        rm $1*.out >& /dev/null
    	        rm $1*.% >& /dev/null
              end
            endif
          end
        end
      end
      $PARAMSEARCH_DIR/ana-convert ana-tmp.$p | sort -k 1,1nr -k2,2 > $1.exhaust.$p
      rm -f ana-tmp.$p >& /dev/null
      rm -f $1.$p.data $1.$p.test >& /dev/null
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
rm -f $1.ib1.bestsetting >& /dev/null
rm -f $1.exhaust.? >& /dev/null
rm -f $1.mega-settings >& /dev/null
$PARAMSEARCH_DIR/ana-convert $1.exhaust.averages | sort -k 1,1nr -k2,2 | head -n 1 > $1.ib1.bestsetting
rm -f $1.ib1.log >& /dev/null
$PARAMSEARCH_DIR/ana-convert $1.exhaust.averages | sort -k 1,1nr -k2,2 > $1.ib1.log
rm -f $1.exhaust.averages >& /dev/null
echo "best setting found: " ; cat $1.ib1.bestsetting
