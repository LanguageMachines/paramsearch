/* ana-convert */

#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<time.h>

int main(int argc, char *argv[])
{
  FILE *bron;
  char settings[1024];
  char score[1024];
  float realscore;

  srand48((unsigned long int)time(NULL));

  bron=fopen(argv[1],"r");
  if (bron==NULL)
    {
      fprintf(stderr,"ana-convert error: %s: file not found\n",
	      argv[1]);
      exit(1);
    }
  while (!feof(bron))
    {
      strcpy(settings,"");
      fscanf(bron,"%s %s ",
	     settings,score);
      if (strlen(settings)>0)
	{
	  sscanf(score,"%f",&realscore);
	  fprintf(stdout,"%f %s\n",
		  realscore,settings);
	}
    }
  fclose(bron);
  return 0;
}
