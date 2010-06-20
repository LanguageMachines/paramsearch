# the lines below assume the gnu c compiler.
C_ARGS = -O2
CC = gcc

# You shouldn't need to make any more changes below this line.

all:	ana-convert generate-steplist getlast10percent makenextlevel-igtree makenextlevel-tribl2 makenextlevel-ib1-bin makenextlevel-ibn makenextlevel-fambl makenextlevel-ripper makenextlevel-svmlight makenextlevel-ib1 makenextlevel-maxent makenextlevel-c4.5 makenextlevel-winnow makenextlevel-perceptron meanstd paramsearch partition-factor randomize runfull-ib1-bin runfull-fambl runfull-ripper runfull-svmlight runfull-ib1 runfull-maxent runfull-c4.5 runfull-winnow runfull-perceptron runfull-ibn runfull-igtree runfull-tribl2 executable

executable:
	chmod +x *.csh *.pl

ana-convert:	ana-convert.c
	$(CC) $(C_ARGS) -o $@ $^

generate-steplist:	generate-steplist.c
	$(CC) $(C_ARGS) -o $@ $^ -lm

getlast10percent:	getlast10percent.c
	$(CC) $(C_ARGS) -o $@ $^

makenextlevel-ib1-bin:	makenextlevel-ib1-bin.c
	$(CC) $(C_ARGS) -o $@ $^

makenextlevel-ibn:	makenextlevel-ibn.c
	$(CC) $(C_ARGS) -o $@ $^

makenextlevel-igtree:	makenextlevel-igtree.c
	$(CC) $(C_ARGS) -o $@ $^

makenextlevel-tribl2:	makenextlevel-tribl2.c
	$(CC) $(C_ARGS) -o $@ $^

makenextlevel-fambl:	makenextlevel-fambl.c
	$(CC) $(C_ARGS) -o $@ $^

makenextlevel-maxent:	makenextlevel-maxent.c
	$(CC) $(C_ARGS) -o $@ $^

makenextlevel-ripper:	makenextlevel-ripper.c
	$(CC) $(C_ARGS) -o $@ $^

makenextlevel-svmlight:	makenextlevel-svmlight.c
	$(CC) $(C_ARGS) -o $@ $^

makenextlevel-ib1:	makenextlevel-ib1.c
	$(CC) $(C_ARGS) -o $@ $^

makenextlevel-c4.5:	makenextlevel-c4.5.c
	$(CC) $(C_ARGS) -o $@ $^

makenextlevel-winnow:	makenextlevel-winnow.c
	$(CC) $(C_ARGS) -o $@ $^

makenextlevel-perceptron:	makenextlevel-perceptron.c
	$(CC) $(C_ARGS) -o $@ $^

meanstd:	meanstd.c
	$(CC) $(C_ARGS) -o $@ $^ -lm

paramsearch:	paramsearch.c
	$(CC) $(C_ARGS) -o $@ $^

partition-factor:	partition-factor.c
	$(CC) $(C_ARGS) -o $@ $^

randomize:	randomize.c
	$(CC) $(C_ARGS) -o $@ $^

runfull-ib1-bin:	runfull-ib1-bin.c
	$(CC) $(C_ARGS) -o $@ $^

runfull-ibn:	runfull-ibn.c
	$(CC) $(C_ARGS) -o $@ $^

runfull-igtree:	runfull-igtree.c
	$(CC) $(C_ARGS) -o $@ $^

runfull-fambl:	runfull-fambl.c
	$(CC) $(C_ARGS) -o $@ $^

runfull-ripper:	runfull-ripper.c
	$(CC) $(C_ARGS) -o $@ $^

runfull-svmlight:	runfull-svmlight.c
	$(CC) $(C_ARGS) -o $@ $^

runfull-ib1:	runfull-ib1.c
	$(CC) $(C_ARGS) -o $@ $^

runfull-maxent:	runfull-maxent.c
	$(CC) $(C_ARGS) -o $@ $^

runfull-c4.5:	runfull-c4.5.c
	$(CC) $(C_ARGS) -o $@ $^

runfull-winnow:	runfull-winnow.c
	$(CC) $(C_ARGS) -o $@ $^

runfull-perceptron:	runfull-perceptron.c
	$(CC) $(C_ARGS) -o $@ $^

clean:
	-rm ana-convert generate-steplist getlast10percent makenextlevel-ibn makenextlevel-ib1-bin makenextlevel-fambl makenextlevel-igtree makenextlevel-tribl2 makenextlevel-ripper makenextlevel-svmlight makenextlevel-ib1 makenextlevel-maxent makenextlevel-c4.5 makenextlevel-winnow makenextlevel-perceptron meanstd paramsearch partition-factor randomize runfull-ib1-bin runfull-fambl runfull-ripper runfull-svmlight runfull-ib1 runfull-maxent runfull-c4.5 runfull-winnow runfull-perceptron runfull-ibn runfull-igtree runfull-tribl2
