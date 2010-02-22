/* randomize: randomizes :-)
   syntax: randomize <datafile> */

#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<stddef.h>
#include<time.h>

#define TOPRAND 999999999
#define LINELEN 65536

int main(int argc, char *argv[])
{ 
  FILE *bron,*doel;
  char line[LINELEN];
  char commandline[LINELEN];
  int  seed;

  if (argc!=3)
    {
      fprintf(stderr,"\nsyntax error. Usage: randomize <datafile> <seed>\n\n");
      exit(1);
    }

  bron=fopen(argv[1],"r");
  if (bron==NULL)
    {
      fprintf(stderr,"%s: no such file\n\n",argv[1]);
      exit(1);
    }

  sscanf(argv[2],"%d",&seed);

  fprintf(stderr,"\n RANDOMIZE - Antal May 2003\n\n");
  fprintf(stderr,"randomizing %s with seed %d\n",
	  argv[1],seed);
  
  srand48((unsigned long int) seed);
  doel=fopen("effe","w");
  fgets(line,LINELEN,bron);
  while (!feof(bron))
  { 
    fprintf(doel,"%d %s",(int) lrand48()%seed,line);
    fgets(line,LINELEN,bron);
  }
  fclose(doel);
  fclose(bron);
  
  system("sort -n effe -o effe\n");
  system("cut -d\" \" -f2- effe > effe2\n");

  sprintf(commandline,"mv effe2 %s\n",
	  argv[1]);
  system(commandline);
  system("rm effe\n");

  fprintf(stderr,"ready.\n\n");

  return 0;
}
