/* getlast10percent - get last 10% of data set to be used as
   heldout test set in iterative deepening */

#include<stdio.h>
#include<string.h>

#define LINELEN 32768

int main(int argc, char *argv[])
{
  FILE *bron;
  char line[LINELEN];
  int  nrlines=0,limit;

  bron=fopen(argv[1],"r");
  fgets(line,LINELEN,bron);
  while (!feof(bron))
    {
      nrlines++;
      fgets(line,LINELEN,bron);
    }
  fclose(bron);

  limit=nrlines*0.9;

  nrlines=0;
  bron=fopen(argv[1],"r");
  fgets(line,LINELEN,bron);
  while (!feof(bron))
    {
      if (nrlines>limit)
	fprintf(stdout,"%s",line);
      nrlines++;
      fgets(line,LINELEN,bron);
    }
  fclose(bron);


  return 0;
}
