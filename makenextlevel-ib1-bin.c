/* makenextlevel-ib1-bin */

#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define DENSITYBLOCKS 10

int main(int argc, char *argv[])
{
  FILE *bron,*doel;
  int  nrlines=0,limit=1,i,j,lowestblocknr,nrnewblocks;
  char dummy[1024];
  char settings[1024];
  char *part;
  float realscore=0.0,lowest,highest,interval,thisbound;
  float data[4096];
  int   densityblock[DENSITYBLOCKS];
  int   newblock[DENSITYBLOCKS];
  int   orignr[DENSITYBLOCKS];
  char  ready;

  bron=fopen("ana-sorted","r");
  if (bron==NULL)
    {
      fprintf(stderr,"makenextlevel error: cannot open ana-sorted\n\n");
      exit(1);
    }

  lowest=100.;
  highest=0.;
  while (!feof(bron))
    {
      fscanf(bron,"%f %s ",
	     &data[nrlines],settings);
      realscore=data[nrlines];
      if (realscore<lowest)
	lowest=realscore;
      if (realscore>highest)
	highest=realscore;
      nrlines++;
    }
  fclose(bron);

  if (nrlines==1)
    {
      limit=1;
    }
  else
    {
      highest+=0.001;
      fprintf(stderr,"%d settings in current selection\n",
	      nrlines);
      fprintf(stderr,"computing density in intervals between lowest %6.2f and highest %6.2f\n",
	      lowest,highest);
      for (i=0; i<DENSITYBLOCKS; i++)
	densityblock[i]=0;
      interval=(highest-lowest)/(1.*DENSITYBLOCKS);
      thisbound=0;
      for (j=0; j<nrlines; j++)
	{
	  i=0;
	  while ((data[j]>=(lowest+((1.*(i+1))*interval)))&&
		 (i<DENSITYBLOCKS))
	    i++;
	  densityblock[i]++;
	}

      for (i=0; i<nrnewblocks-1; i++)
        fprintf(stderr,"density block %d (%6.2f - %6.2f): %6d\n",
                i,
                lowest+interval*(1.*orignr[i]),
                lowest+interval*(1.*(orignr[i+1])),
                newblock[i]);
      fprintf(stderr,"density block %d (%6.2f - %6.2f): %6d\n",
              i,
              lowest+interval*(1.*orignr[i]),
              lowest+interval*(1.*(orignr[i]+1)),
              newblock[i]);

      lowestblocknr=nrnewblocks-1;
      while ((lowestblocknr>0)&&
             (newblock[lowestblocknr]<=newblock[lowestblocknr-1]))
        lowestblocknr--;
      
      limit=nrlines-1;
      while (data[limit]<(lowest+((interval*(1.*orignr[lowestblocknr])))))
	limit--;
      limit++;

      fprintf(stderr,"keeping the top %d settings with accuracy %6.2f and up\n",
              limit,
              lowest+interval*(1.*orignr[lowestblocknr]));

      if (limit==0)
	limit=1;
    }

  doel=fopen("nextlevel.csh","w");
  fprintf(doel,"#! /bin/csh -f\n");
  fprintf(doel,"rm ana-tmp >& /dev/null\n");
  fprintf(doel,"touch ana-tmp\n");

  if (limit<4)
    {
      bron=fopen("ana-sorted","r");
      fscanf(bron,"%s %s ",
	     dummy,settings);
      fclose(bron);
      
      fprintf(doel,"echo ------------------------- 1 of %d: %s %s\n",
	      limit,dummy,settings);
      fprintf(doel,"echo %s >> ana-tmp\n",
	      settings);
      fprintf(doel,"echo %s >> ana-tmp\n",
	      dummy);
    }
  else
    {
      bron=fopen("ana-sorted","r");
      for (i=0; i<limit; i++)
	{
	  fscanf(bron,"%s %s ",
		 dummy,settings);
	  fprintf(doel,"echo ------------------------- %d of %d: %s %s\n",
		  i+1,limit,dummy,settings);
	  fprintf(doel,"Fambl -f $1 -t $2 -b -a ");
	  part=strtok(settings,".");
          while ((part!=NULL)&&
                 (strcmp(part,"IB1")!=0)&&
		 (strcmp(part,"Fambl")!=0))
            part=strtok(NULL,".");
	  while (part!=NULL)
	    {
	      if (part[0]=='k')
		fprintf(doel,"-%s ",
			part);
	      
	      if (part[0]=='L')
		fprintf(doel,"-%s ",
			part);
	      
	      if (part[0]=='C')
		fprintf(doel,"-%s ",
			part);
	      
	      if (part[0]=='z')
		fprintf(doel,"-%s ",
			part);
	      
	      if (part[0]=='y')
		fprintf(doel,"-%s ",
			part);
	      
	      if (strcmp(part,"M")==0)
		fprintf(doel,"-m1 ");
	      if (strcmp(part,"O")==0)
		fprintf(doel,"-m0 ");
	      if (strcmp(part,"J")==0)
		fprintf(doel,"-m2 ");
	      
	      if (strcmp(part,"IL")==0)
		fprintf(doel,"-d1 ");
	      if (strcmp(part,"ID")==0)
		fprintf(doel,"-d2 ");
	      if (strcmp(part,"ED")==0)
		fprintf(doel,"-d3 ");
	      
	      if (strcmp(part,"nw")==0)
		fprintf(doel,"-g0 ");
	      if (strcmp(part,"gr")==0)
		fprintf(doel,"-g2 ");
	      if (strcmp(part,"ig")==0)
		fprintf(doel,"-g1 ");
	      if (strcmp(part,"x2")==0)
		fprintf(doel,"-g3 ");
	      if (strcmp(part,"sv")==0)
		fprintf(doel,"-g4 ");
	      if (strcmp(part,"ll")==0)
		fprintf(doel,"-g5 ");
	      
	      part=strtok(NULL,".");
	    }
	  fprintf(doel,"-p >& /dev/null\n");
	  fprintf(doel,"foreach file (`ls $2*.%%`)\n");
	  fprintf(doel,"  echo $file >> ana-tmp\n");
	  fprintf(doel,"  cat $file >> ana-tmp\n");
	  fprintf(doel,"end\n");
	  fprintf(doel,"rm $2*.out >& /dev/null\n");
	  fprintf(doel,"rm $2*.%% >& /dev/null\n");
	}
      fclose(bron);
    }
  fprintf(doel,"rm ana-sorted >& /dev/null\n");
  fprintf(doel,"$PARAMSEARCH_DIR/ana-convert ana-tmp | sort -k 1,1nr -k2,2 > ana-sorted\n");

  fclose(doel);

  return 0;
}
