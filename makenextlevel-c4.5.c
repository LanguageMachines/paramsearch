/* makenextlevel-c4.5 */

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
  char memsettings[1024];
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

  lowest=0.;
  highest=100.;
  while (!feof(bron))
    {
      fscanf(bron,"%f %s ",
             &data[nrlines],settings);
      realscore=data[nrlines];
      if (realscore>lowest)
        lowest=realscore;
      if (realscore<highest)
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
      highest-=0.001;
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
          while ((data[j]<=(lowest+((1.*(i+1))*interval)))&&
                 (i<DENSITYBLOCKS))
            i++;
          densityblock[i]++;
        }

      nrnewblocks=0;
      for (i=0; i<DENSITYBLOCKS; i++)
        {
          if (densityblock[i]!=0)
            {
              newblock[nrnewblocks]=densityblock[i];
              orignr[nrnewblocks]=i;
              nrnewblocks++;
            }
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
      while (data[limit]>(lowest+((interval*(1.*orignr[lowestblocknr])))))
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
  fprintf(doel,"rm ana-tmp >/dev/null 2>&1\n");
  fprintf(doel,"touch ana-tmp\n");

  if (limit<4)
    {
      bron=fopen("ana-sorted","r");
      fscanf(bron,"%s %s ",
	     dummy,settings);
      
      fclose(bron);
      
      fprintf(doel,"echo ------------------------- 1 of 1: %s\n",
	      dummy);
      fprintf(doel,"echo ");
      for (i=0; i<strlen(settings); i++)
	{
	  if (settings[i]=='!')
	    fprintf(doel,"\\");
	  fprintf(doel,"%c",settings[i]);
	}
      fprintf(doel," >> ana-tmp\n");
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
	  strcpy(memsettings,"");
	  for (j=0; j<strlen(settings); j++)
	    {
	      if (settings[j]=='!')
		strcat(memsettings,"\\");
	      strcat(memsettings," ");
	      memsettings[strlen(memsettings)-1]=settings[j];
	    }
	  fprintf(doel,"echo ------------------------- %d of %d: %s %s\n",
		  i+1,limit,dummy,memsettings);
	  fprintf(doel,"c4.5 -f $1 -u -b ");
	  part=strtok(settings,"=");
	  while (part!=NULL)
	    {
              if (part[0]=='m')
                {
                  fprintf(doel,"-m ");
                  j=2;
                  while (j<strlen(part))
                    {
                      fprintf(doel,"%c",
                              part[j]);
                      j++;
                    }
                  fprintf(doel," ");
                }

              if (part[0]=='c')
                {
                  fprintf(doel,"-c ");
                  j=2;
                  while (j<strlen(part))
                    {
                      fprintf(doel,"%c",
                              part[j]);
                      j++;
                    }
                  fprintf(doel," ");
                }

              if (part[0]=='s')
                fprintf(doel,"-s ");

              if (part[0]=='g')
                fprintf(doel,"-g ");

	      part=strtok(NULL,"=");
	    }
	  fprintf(doel,"> $1.out\n");
	  fprintf(doel,"echo %s >> ana-tmp\n",
		  memsettings);
	  fprintf(doel,"grep \"<<\" $1.out | tail -n 1 | cut -d\"(\" -f3 | cut -d\"%%\" -f 1 >> ana-tmp\n");
	  fprintf(doel,"rm $1.out >/dev/null 2>&1\n");
	}
      fclose(bron);
    }
  fprintf(doel,"rm ana-sorted >/dev/null 2>&1\n");
  fprintf(doel,"$PARAMSEARCH_DIR/ana-convert ana-tmp | sort -k 1,1n -k2,2 > ana-sorted\n");

  fclose(doel);

  return 0;
}
