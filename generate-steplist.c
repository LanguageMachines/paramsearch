/* generate-steplist */

#include<stdio.h>
#include<string.h>
#include<math.h>

#define NRSTEPS 20

int main(int argc, char *argv[])
{
  int   i,nrinst;
  double factor,counter;

  sscanf(argv[1],"%d",&nrinst);
  //fprintf(stderr,"%d instances\n",
  //  nrinst);

  factor=pow((1.*nrinst),(1./(1.*NRSTEPS)));

  fprintf(stderr,"multiplication factor for steps: %f\n",
	  factor);

  counter=1.;
  counter*=factor;
  for (i=1; i<=(NRSTEPS); i++)
    {
      if (counter>500.)
	fprintf(stdout,"%.0f\n",
		counter);
      counter*=factor;

    }

  return 0;
}
