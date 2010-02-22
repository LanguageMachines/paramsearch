/* meanstd - computes mean, variance, and standard deviation of list of numbers
   just type `meanstd', then the numbers, end with `s'.
   Tue Aug 23 1994, another attempt at writing C by Antal van den Bosch */

#include<stdio.h>
#include<string.h>
#include<math.h>

int main(void)
{ 
  int    i,n;
  float fsum,fmean,fvari,fsdev;
  float fdat[100];
  char  inl[100];

  printf("\n### Computation of mean and standard deviation - Antal Quicky Code\n");
  printf("### enter values, `stop' to stop:\n\n");
  n=0;
  strcpy(inl,"#");
  while (inl[0]!='s')
    { 
      scanf("%s",inl);
      if (inl[0]!='s')
	{ 
	  sscanf(inl,"%f ",&fdat[n]);
	  n++;
	}
    }
  printf("### %d values\n",n);
  fsum=0.0;
  for (i=0; i<n; i++)
    fsum+=fdat[i];
  fmean=fsum/n;
  fvari=0.0;
  for (i=0; i<n; i++)
    fvari+=((fdat[i]-fmean)*(fdat[i]-fmean));
  fvari/=n;
  fsdev=sqrt(fvari);
  printf("### mean:     %14.6f\n",fmean);
  printf("### variance: %14.6f\n",fvari);
  printf("### st.dev.:  %14.6f\n\n",fsdev);

  return 0;
}
