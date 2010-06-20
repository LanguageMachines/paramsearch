/** Copyright (c) 1998-2010 Antal van den Bosch
    ILK / Tilburg University

    paramsearch - do SOME heuristic parameter optimization search;
    either exhaustive search with n-fold CV, or wrapped progressive
    sampling, with IB1 (from TiMBL), IB1 with binary input (from
    Fambl), IB1 with numeric input, TRIBL2 (from TiMBL), IGTree (from
    TiMBL), Fambl, SVM light, Ripper, maxent, C4.5, perceptron (from
    SNoW), winnow (from SNoW).

    syntax: paramsearch <algorithm> <trainingfile> [extra]

    where <algorithm> is ib1, ib1-bin, ibn, tribl, igtree, fambl,
    svmlight, ripper, maxent, c4.5, perceptron, or winnow, and
    <trainingfile> is a data file adhering to the conventions of
    <algorithm>, and [extra] is an optional metric modifier (ib1
    only), or an obligatory number of classes (winnow and perceptron).


    paramsearch is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.
    
    paramsearch is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program; if not, see <http://www.gnu.org/licenses/>.
    
*/

#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<time.h>

#define FREQTHRESHOLD    1000      // boundary between exhaustive and ID
#define MAXLINELEN       32768
#define MAXNRCANDIDATES  4096
#define CANDIDATELEN     1024
#define SEED             24101997  // for drand48 random number generator
#define DEBUG            0

int main(int argc, char *argv[])
{
  char commandline[MAXLINELEN];
  char fname[CANDIDATELEN];
  char *part;
  char algostring[CANDIDATELEN];
  char line[MAXLINELEN];
  char line2[MAXLINELEN];
  char line3[MAXLINELEN];
  char randomizedname[MAXLINELEN];
  char metricstring[CANDIDATELEN];
  char **candidatesettings;
  char defaultsetting[CANDIDATELEN];
  char readsetting[CANDIDATELEN];
  char topsetting[CANDIDATELEN];
  char delimiter[32];
  char dummy[CANDIDATELEN];
  int  i,j,nrinst,learntime,algo,nrcandidatesettings,randompick,nrfeat,nrclasses;
  int  startline=0,counter,lowestfreq,readfreq,thr,lowestfreqflag=0;
  char hasspace,hastab,hascomma,twocflag=0;
  float fract,topscore,readscore;
  FILE *bron,*doel;
  char defaultin;
  time_t begintime,endtime;

  // check if PARAMSEARCH_DIR is set
  part=getenv("PARAMSEARCH_DIR");
  if (part==NULL)
    {
      fprintf(stderr,"Error: environment variable PARAMSEARCH_DIR not set.\n\n");
      exit(1);
    }

  // set random seed using computer time
  srand48((unsigned long int)time(NULL));

  // welcome message
  fprintf(stderr,"\nparamsearch v 1.1\n\n");
  fprintf(stderr,"Heuristic parameter optimization search for IB1, IGTree, TRIBL2, Fambl,\n");
  fprintf(stderr,"Ripper, SVM-light, Maximum entropy, C4.5, Winnow, Perceptron.\n\n");
  fprintf(stderr,"Copyright 2003-2010 Tilburg University, ILK Research Group\n");
  fprintf(stderr,"Antal van den Bosch / antalb@uvt.nl / http://ilk.uvt.nl\n\n");

  if ((argc<3)||
      (argc>4))
    {
      fprintf(stderr,"Usage: paramsearch <algorithm> <trainingfile> [extra]\n\n");
      fprintf(stderr,"where <algorithm> is ib1, ib1-bin, ibn, igtree, tribl2, fambl, svmlight,\n");
      fprintf(stderr,"ripper, maxent, c4.5, winnow, or perceptron, and [extra] is an optional\n");
      fprintf(stderr,"metric modifier (ib1 only), or the number of classes (winnow & perceptron).\n");
      fprintf(stderr,"\n");
      fprintf(stderr,"Note: <trainingfile> must adhere to the syntax / assumed format of\n");
      fprintf(stderr,"<algorithm>. ib1-bin is equivalent to ib1 except that all input\n");
      fprintf(stderr,"is binarized. ibn is equivalent to ib1 but works exclusively for\n");
      fprintf(stderr,"numeric data.\n\n");
      exit(1);
    }

  if (DEBUG)
    {
      fprintf(stderr,"settings:\n");
      fprintf(stderr,"      below 10 instances:  default settings\n");
      fprintf(stderr,"        10- 99 instances:  10-fold CV pseudo-exhaustive search\n");
      fprintf(stderr,"       100-499 instances:  5-fold CV pseudo-exhaustive search\n");
      fprintf(stderr,"       500-999 instances:  2-fold CV pseudo-exhaustive search\n");
      fprintf(stderr,"  1000 or more instances:  wrapped progressive sampling\n\n");
    }

  // determine algorithm
  algo=-1;

  // we secretly allow timbl as command line argument, meaning ib1
  if ((strcmp(argv[1],"ib1")==0)||
      (strcmp(argv[1],"timbl")==0))
    {
      algo=0;
      strcpy(algostring,"ib1");
      strcpy(defaultsetting,"IB1.O.gr.k1.");
    }

  // we secretly allow fambl-bin as command line argument, meaning ib1-bin
  if ((strcmp(argv[1],"ib1-bin")==0)||
      (strcmp(argv[1],"fambl-bin")==0))
    {
      algo=2;
      strcpy(algostring,"ib1-bin");
      strcpy(defaultsetting,"IB1.O.gr.k1.bin");
    }

  if (strcmp(argv[1],"fambl")==0)
    {
      algo=6;
      strcpy(algostring,"fambl");
      strcpy(defaultsetting,"Fambl.O.gr.k1.K1.");
    }

  if (strcmp(argv[1],"ibn")==0)
    {
      algo=11;
      strcpy(algostring,"ibn");
      strcpy(defaultsetting,"IB1.N.gr.k1.");
    }

  if (strcmp(argv[1],"igtree")==0)
    {
      algo=12;
      strcpy(algostring,"igtree");
      strcpy(defaultsetting,"IGTree.gr.");
    }

  if (strcmp(argv[1],"tribl2")==0)
    {
      algo=13;
      strcpy(algostring,"tribl2");
      strcpy(defaultsetting,"TRIBL2.O.gr.k1.");
    }

  if (strcmp(argv[1],"svmlight")==0)
    {
      algo=4;
      strcpy(algostring,"svmlight");
      strcpy(defaultsetting,"c-1=t-1=d-1");
    }

  if (strcmp(argv[1],"ripper")==0)
    {
      algo=5;
      strcpy(algostring,"ripper");
      strcpy(defaultsetting,"f-1=a-+freq=n--!n=s-0.5=o-2=l-1.0");
    }

  if (strcmp(argv[1],"maxent")==0)
    {
      algo=7;
      strcpy(algostring,"maxent");
      strcpy(defaultsetting,"e---lbfgs=g-0.0");
    }

  if (strcmp(argv[1],"c4.5")==0)
    {
      algo=8;
      strcpy(algostring,"c4.5");
      strcpy(defaultsetting,"m-2=c-0.1");
    }

  if (strcmp(argv[1],"winnow")==0)
    {
      algo=9;
      if (argc!=4)
	{
	  fprintf(stderr,"Error: with winnow, also specify the number of classes\n\n");
	  exit(1);
	}
      strcpy(algostring,"winnow");
      sscanf(argv[3],"%d",&lowestfreqflag);
      if (lowestfreqflag<2)
	{
	  fprintf(stderr,"Error: number of classes should be 2 or larger; %d is too low\n\n");
	  exit(1);
	}
      sprintf(defaultsetting,"p-1.35=d-0.8=t-4.0=c-%d=r-2=s-0.0",
	      lowestfreqflag-1);
    }
  if (strcmp(argv[1],"perceptron")==0)
    {
      algo=10;
      if (argc!=4)
	{
	  fprintf(stderr,"Error: with perceptron, also specify the number of classes\n\n");
	  exit(1);
	}
      strcpy(algostring,"perceptron");
      sscanf(argv[3],"%d",&lowestfreqflag);
      if (lowestfreqflag<2)
	{
	  fprintf(stderr,"Error: number of classes should be 2 or larger\n\n");
	  exit(1);
	}
      sprintf(defaultsetting,"p-0.1=d-4=c-%d=r-2=s-0.0",
	      lowestfreqflag-1);
    }

  if (algo==-1)
    {
      fprintf(stderr,"Error: \'%s\' not recognised as an algorithm setting.\n\n",
	      argv[1]);
      exit(1);
    }

  // check if data file exists
  bron=fopen(argv[2],"r");
  if (bron==NULL)
    {
      fprintf(stderr,"Error: %s: no such file.\n\n",
	      argv[2]);
      exit(1);
    }
  fclose(bron);

  // check if algorithm is there.
  
  system("rm -f algocheck >& /dev/null\n");
  if ((algo==0)||
      (algo==11)||
      (algo==12)||
      (algo==13))
    {
      system("Timbl -V >& algocheck\n");
      bron=fopen("algocheck","r");
      if (bron==NULL)
	{
	  fprintf(stderr,"Write error - could not check TiMBL version\n\n");
	  exit(1);
	}
      fgets(line,MAXLINELEN,bron);
      if ((strstr(line,"ommand not found"))||
	  (strstr(line,"no such")))
	{
	  fprintf(stderr,"Error: Timbl: command not found.\n\n");
	  exit(1);
	}
      fprintf(stderr,"using TiMBL version:\n%s\n",
	      line);
      fclose(bron);
    }
  if ((algo==2)||
      (algo==6))
    {
      system("Fambl >& algocheck\n");
      bron=fopen("algocheck","r");
      if (bron==NULL)
	{
	  fprintf(stderr,"Write error - could not check Fambl version\n");
	  exit(1);
	}
      fgets(line,MAXLINELEN,bron);
      if (!feof(bron))
	fgets(line,MAXLINELEN,bron);
      if ((strstr(line,"ommand not found"))||
	  (strstr(line,"no such")))
	{
	  fprintf(stderr,"Error: Fambl: command not found.\n\n");
	  exit(1);
	}
      fprintf(stderr,"using Fambl version:\n%s\n",
	      line);
      fclose(bron);
    }
  if (algo==4)
    {
      system("which svm_learn > algocheck; which svm_classify >> algocheck\n");
      bron=fopen("algocheck","r");
      if (bron==NULL)
	{
	  fprintf(stderr,"Write error - could not check SVM\n\n");
	  exit(1);
	}
      fgets(line,MAXLINELEN,bron);
      if (!strstr(line,"svm_learn"))
	{
	  fprintf(stderr,"Error: svm_learn: command not found.\n\n");
	  exit(1);
	}
      fgets(line,MAXLINELEN,bron);
      if (!strstr(line,"svm_classify"))
	{
	  fprintf(stderr,"Error: svm_classify: command not found.\n\n");
	  exit(1);
	}
      fclose(bron);
    }
  if (algo==5)
    {
      system("ripper >& algocheck\n");
      bron=fopen("algocheck","r");
      if (bron==NULL)
	{
	  fprintf(stderr,"Write error - could not check Ripper\n\n");
	  exit(1);
	}
      fgets(line,MAXLINELEN,bron);
      if (!feof(bron))
	fgets(line,MAXLINELEN,bron);
      if ((strstr(line,"ommand not found"))||
	  (strstr(line,"no such")))
	{
	  fprintf(stderr,"Error: ripper: command not found.\n\n");
	  exit(1);
	}
      fprintf(stderr,"using ripper version:\n%s\n",
	      line);
      fclose(bron);
      system("rm -f algocheck >& /dev/null\n");
      system("predict >& algocheck\n");
      bron=fopen("algocheck","r");
      if (bron==NULL)
	{
	  fprintf(stderr,"Write error - could not check Ripper version\n\n");
	  exit(1);
	}
      fgets(line,MAXLINELEN,bron);
      if ((strstr(line,"ommand not found"))||
	  (strstr(line,"no such")))
	{
	  fprintf(stderr,"Error: predict: command not found.\n\n");
	  exit(1);
	}
      fclose(bron);
    }
  if (algo==7)
    {
      system("maxent >& algocheck\n");
      bron=fopen("algocheck","r");
      if (bron==NULL)
	{
	  fprintf(stderr,"Write error - could not check maxent\n\n");
	  exit(1);
	}
      fgets(line,MAXLINELEN,bron);
      if ((strstr(line,"ommand not found"))||
	  (strstr(line,"no such")))
	{
	  fprintf(stderr,"Error: maxent: command not found.\n\n");
	  exit(1);
	}
      fprintf(stderr,"using maxent version:\n%s\n",
	      line);
      fclose(bron);
    }
  if (algo==8)
    {
      system("c4.5 >& algocheck\n");
      bron=fopen("algocheck","r");
      if (bron==NULL)
	{
	  fprintf(stderr,"Write error - could not check c4.5\n\n");
	  exit(1);
	}
      fgets(line,MAXLINELEN,bron);
      if ((strstr(line,"ommand not found"))||
	  (strstr(line,"no such")))
	{
	  fprintf(stderr,"Error: c4.5: command not found.\n\n");
	  exit(1);
	}
      fgets(line,MAXLINELEN,bron);
      fprintf(stderr,"using C4.5 version:\n%s\n",
	      line);
      fclose(bron);
    }
  if ((algo==9)||
      (algo==10))
    {
      system("snow >& algocheck\n");
      bron=fopen("algocheck","r");
      if (bron==NULL)
	{
	  fprintf(stderr,"Write error - could not check SNoW version\n");
	  exit(1);
	}
      fgets(line,MAXLINELEN,bron);
      if (!feof(bron))
	fgets(line,MAXLINELEN,bron);
      if (!feof(bron))
	fgets(line2,MAXLINELEN,bron);
      if (!feof(bron))
	fgets(line3,MAXLINELEN,bron);
      if (strstr(line,"ommand not found"))
	{
	  fprintf(stderr,"Error: snow: command not found.\n\n");
	  exit(1);
	}
      fprintf(stderr,"using SNoW version:\n%s%s%s\n",
	      line,line2,line3);
      fclose(bron);
    }

  system("rm -f algocheck >& /dev/null\n");

  // some cleanup
  sprintf(commandline,"rm -f ana-tmp ana-sorted %s.*.%% %s.*.out >& /dev/null\n",
	  argv[2],argv[2]);
  system(commandline);

  // allocation of candidate settings buffers
  candidatesettings=malloc(MAXNRCANDIDATES*sizeof(char*));
  for (i=0; i<MAXNRCANDIDATES; i++)
    {
      candidatesettings[i]=malloc(CANDIDATELEN*sizeof(char));
    }

  // determine number of instances 
  sprintf(commandline,"wc -l %s > %s.nrinst\n",
	  argv[2],argv[2]);
  system(commandline);
  sprintf(fname,"%s.nrinst",
	  argv[2]);
  bron=fopen(fname,"r");
  if (bron==NULL)
    {
      fprintf(stderr,"Write error\n\n");
      exit(1);
    }
  fscanf(bron,"%d",&nrinst);
  fclose(bron);

  // below 10 instances, just write default setting for robustness' sake
  if (nrinst<10)
    {
      fprintf(stderr,"Warning: file %s is too small (should be 10 instances or more)\n",
	      argv[2]);
      fprintf(stderr,"writing a best settings file with default setting.\n\n");
      
      sprintf(fname,"%s.%s.bestsetting",
	      argv[2],algostring);
      doel=fopen(fname,"w");
      if (doel==NULL)
	{
	  fprintf(stderr,"Write error\n\n");
	  exit(1);
	}
      fprintf(doel,"0.0 %s\n",
	      defaultsetting);
      fclose(doel);

      exit(1);
    }

  // determine number of features
  bron=fopen(argv[2],"r");
  if (bron==NULL)
    {
      fprintf(stderr,"Cannot read %s\n\n",
	      argv[2]);
      exit(1);
    }
  fgets(line,MAXLINELEN,bron);
  fclose(bron);
  hastab=hascomma=hasspace=0;
  if (strstr(line,","))
    hascomma=1;
  if (strstr(line," "))
    hasspace=1;
  if (strstr(line,"\t"))
    hastab=1;
  if (!((hascomma)||(hasspace)||(hastab)))
    {
      fprintf(stderr,"Error: first line of data does not make sense.\n\n");
      exit(1);
    }
  if (hascomma)
    strcpy(delimiter,",\n");
  if (hasspace)
    strcpy(delimiter," \n");
  if (hastab)
    strcpy(delimiter,"\t\n");
  nrfeat=0;
  part=strtok(line,delimiter);
  while (part!=NULL)
    {
      nrfeat++;
      part=strtok(NULL,delimiter);
    }
  if (DEBUG)
    fprintf(stderr,"counted %d features, determined delimiter [ ]\n",
	    nrfeat,delimiter[0]);

  // check for avoidable redundancies in TiMBL and Fambl settings

  if ((algo==0)||
      (algo==2)||
      (algo==6)||
      (algo==11)||
      (algo==12)||
      (algo==13))
    {
      if (DEBUG)
	fprintf(stderr,"checking setting redundancies\n");
      // find out the number of classes 
      sprintf(commandline,"cut -d\"%c\" -f %d %s > %s.classes; sort -u %s.classes | wc > %s.nrclasses\n",
	      delimiter[0],nrfeat,argv[2],argv[2],argv[2],argv[2]);
      system(commandline);
      sprintf(fname,"%s.nrclasses",
	      argv[2]);
      bron=fopen(fname,"r");
      if (bron==NULL)
	{
	  fprintf(stderr,"Cannot read %s\n\n",
		  fname);
	  exit(1);
	}
      fscanf(bron,"%d",&nrclasses);
      fclose(bron);
      
      // abort if there's only one class!
      // (except with SNoW which can have one class bit)
      if ((nrclasses==1)&&
	  (!((algo==9)||
	     (algo==10))))
	{
	  fprintf(stderr,"Error: data has one class. There is nothing to learn.\n\n");
	  exit(1);
	}

      // find the lowest frequency of values
      lowestfreq=nrinst;
      for (i=0; i<nrfeat-1; i++)
	{
	  sprintf(commandline,"cut -d\"%c\" -f %d %s > %s.feat; sort %s.feat | uniq -c > %s.featcount\n",
		  delimiter[0],i+1,argv[2],argv[2],argv[2],argv[2]);
	  if (DEBUG)
	    fprintf(stderr,"commandline: %s",
		    commandline);
	  system(commandline);
	  sprintf(fname,"%s.featcount",
		  argv[2]);
	  bron=fopen(fname,"r");
	  if (bron==NULL)
	    {
	      fprintf(stderr,"Cannot read %s\n\n",
		      fname);
	      exit(1);
	    }
	  fgets(line,MAXLINELEN,bron);
	  while (!feof(bron))
	    {
	      sscanf(line,"%d %s ",
		     &readfreq,dummy);
	      if (readfreq<lowestfreq)
		lowestfreq=readfreq;
	      fgets(line,MAXLINELEN,bron);
	    }
	  fclose(bron);
	}
      
      fprintf(stderr,"%s has\n\t%9d instances\n\t%9d features (lowest value frequency %d)\n\t%9d classes\n",
	      argv[2],nrinst,nrfeat-1,lowestfreq,nrclasses);

      // set the appropriate setting-avoidance flags passed on later to the
      // exhaustive or ID scripts
      if (lowestfreq>1)
	{
	  lowestfreqflag=1;
	  fprintf(stderr,"-L 1 or 2 option is not tested (all values occur more than once)\n");
	}
      if (nrclasses==2)
	{
	  twocflag=1;
	  fprintf(stderr,"-w4 option is not tested (is redundant w.r.t. -w3 with 2 classes)\n");
	}

    }
  else
    {
      fprintf(stderr,"%s has %d instances\n",
	      argv[2],nrinst);
    }

  // check for avoidable redundancy in Ripper settings

  if (algo==5)
    {
      if (DEBUG)
	fprintf(stderr,"checking Ripper setting redundancy\n");
      // find out the number of classes 
      sprintf(commandline,"cut -d\"%c\" -f %d %s > %s.classes; sort -u %s.classes | wc > %s.nrclasses\n",
	      delimiter[0],nrfeat,argv[2],argv[2],argv[2],argv[2]);
      system(commandline);
      sprintf(fname,"%s.nrclasses",
	      argv[2]);
      bron=fopen(fname,"r");
      if (bron==NULL)
	{
	  fprintf(stderr,"Cannot read %s\n\n",
		  fname);
	  exit(1);
	}
      fscanf(bron,"%d",&nrclasses);
      fclose(bron);
      
      // abort if there's only one class!
      if (nrclasses==1)
	{
	  fprintf(stderr,"Error: data has one class. There is nothing to learn.\n\n");
	  exit(1);
	}

      fprintf(stderr,"%s has\n\t%9d instances\n\t%9d classes\n",
	      argv[2],nrinst,nrclasses);

      if (nrclasses>2)
	{
	  twocflag=0;
	  fprintf(stderr,"-L option is not tested (only works with 2 classes)\n");
	}
      else
	twocflag=1;
    }

  // check the m-string
  if (argc==4)
    {
      if ((algo==0)&&(argv[3][0]!=':'))
	{
	  fprintf(stderr,"Error: metric string \"%s\" is not a proper metric modifier\n\n",
		  argv[3]);
	  exit(1);
	}
      else
	{
	  strcpy(metricstring,argv[3]);
	  fprintf(stderr,"\n");
	  if ((algo==9)||
	      (algo==10))
	    {
	      sscanf(metricstring,"%d",&nrclasses);
	      if (nrclasses<2)
		{
		  fprintf(stderr,"Error: %s is not a number of classes needed by SNoW\n\n",
			  metricstring);
		  exit(1);
		}
	      fprintf(stderr,"passing number of classes (%s) to SNoW\n",
		      metricstring);
	      sprintf(metricstring,"%d",nrclasses-1);
	    }
	  if (algo==0)
	    {
	      algo=3;
	      fprintf(stderr,"adding \"%s\" to TiMBL metric parameter\n",
		      metricstring);
	    }

	}
    }
  else
    strcpy(metricstring,"");

  fprintf(stderr,"optimizing algorithmic parameters of %s\n",
	  algostring);

  // warn the user that in case of Ripper and C4.5, accuracies are replaced by errors
  if ((algo==5)||
      (algo==8))
    fprintf(stderr,"note that all numbers below are errors, not accuracies\n");

  // time stamp
  time(&begintime);

  // make randomized version of data
  sprintf(randomizedname,"paramtmpfile.%d",
	  lrand48()%32768);
  sprintf(commandline,"cp %s %s >& /dev/null\n",
	  argv[2],randomizedname);
  system(commandline);

  sprintf(commandline,"$PARAMSEARCH_DIR/randomize %s %d >& /dev/null\n",
	  randomizedname,SEED);
  system(commandline);


  // determine whether to go for exhaustive 10-fold, or for wrapped progressive sampling
  if (nrinst<FREQTHRESHOLD)
    {
      if (nrinst<100)
	  thr=10;
      else
	{
	  if (nrinst<500)
	    thr=5;
	  else
	    thr=2;
	}
      fprintf(stderr,"running pseudo-exhaustive %d-fold CV parameter search\n",
	      thr);
      sprintf(commandline,"$PARAMSEARCH_DIR/exhaust-%s.csh %s %d %d %d %s\n",
	      algostring,
	      argv[2],
	      thr,
	      lowestfreqflag,
	      twocflag,
	      metricstring);
      system(commandline);

      // check the logfile. are there ties? Then (1) pick the default
      // setting or (2) pick a random setting

      sprintf(fname,"%s.%s.log",
	      argv[2],algostring);
      bron=fopen(fname,"r");
      if (bron==NULL)
	{
	  fprintf(stderr,"Cannot read %s\n\n",
		  fname);
	  exit(1);
	}
      nrcandidatesettings=0;
      defaultin=0;
      fscanf(bron,"%f %s ",
	     &topscore,candidatesettings[0]);
      if (strstr(candidatesettings[0],defaultsetting))
	{
	  defaultin=1;
	  strcpy(topsetting,candidatesettings[0]);
	}
      fscanf(bron,"%f %s ",
	     &readscore,readsetting);
      while ((!feof(bron))&&
	     (readscore==topscore))
	{
	  nrcandidatesettings++;
	  strcpy(candidatesettings[nrcandidatesettings],readsetting);
	  if (strstr(candidatesettings[nrcandidatesettings],defaultsetting))
	    {
	      defaultin=1;
	      strcpy(topsetting,candidatesettings[nrcandidatesettings]);
	    }
	  fscanf(bron,"%f %s ",
		 &readscore,readsetting);
	}
      fclose(bron);
      if (nrcandidatesettings>1)
	{
	  fprintf(stderr,"%d settings have the same score!\n",
		  nrcandidatesettings);
	  sprintf(fname,"%s.%s.bestsetting",
		  argv[2],algostring);
	  doel=fopen(fname,"w");
	  if (doel==NULL)
	    {
	      fprintf(stderr,"Cannot write %s\n\n",
		      fname);
	      exit(1);
	    }
	  if (defaultin)
	    {
	      fprintf(stderr,"the default setting (%s) is among them.\nusing that setting as best setting.\n",
		      topsetting);
	      fprintf(doel,"%f %s\n",
		      topscore,topsetting);
	    }
	  else
	    {
	      randompick=(int) lrand48()%nrcandidatesettings;
	      fprintf(stderr,"picking a random best setting: %s\n",
		      candidatesettings[randompick]);
	      fprintf(doel,"%f %s\n",
		      topscore,candidatesettings[randompick]);
	    }
	  fclose(doel);
	}
      fprintf(stderr,"\npseudo-exhaustive process finished in ");

    }
  else
    {
      // wrapped progressive sampling

      fprintf(stderr,"running WPS parameter search\n");

      // create steplist
      fract=0.8*nrinst;
      sprintf(commandline,"$PARAMSEARCH_DIR/generate-steplist %d > %s.steplist\n",
	      (int) fract,argv[2]);
      system(commandline);

      // start the process
      fprintf(stderr,"starting WPS with first pseudo-exhaustive round, stepsize 500\n");
      sprintf(commandline,"$PARAMSEARCH_DIR/iterativedeepening.csh %s %s %d %d %s %s\n",
	      argv[2],
	      algostring,
	      lowestfreqflag,
	      twocflag,
	      randomizedname,
	      metricstring);
      system(commandline);
      
      // check the logfile. are there ties? Then (1) pick the default
      // setting or (2) pick a random setting

      if (DEBUG)
	fprintf(stderr,"checking log... 1\n");

      // first find the last step.
      sprintf(fname,"%s.%s.log",
	      argv[2],algostring);
      bron=fopen(fname,"r");
      if (bron==NULL)
	{
	  fprintf(stderr,"Cannot read %s\n\n",
		  fname);
	  exit(1);
	}
      fgets(line,MAXLINELEN,bron);
      counter=0;
      while (!feof(bron))
	{
	  counter++;
	  if (line[0]=='-')
	    startline=counter;
	  fgets(line,MAXLINELEN,bron);
	}
      fclose(bron);

      if (DEBUG)
	fprintf(stderr,"checking log... 2\n");

      bron=fopen(fname,"r");
      if (bron==NULL)
	{
	  fprintf(stderr,"Cannot read %s\n\n",
		  fname);
	  exit(1);
	}
      for (j=0; j<startline; j++)
	fgets(line,MAXLINELEN,bron);
      defaultin=0;
      fscanf(bron,"%f %s ",
	     &topscore,candidatesettings[0]);
      nrcandidatesettings=1;
      if (strstr(candidatesettings[0],defaultsetting))
	{
	  defaultin=1;
	  strcpy(topsetting,candidatesettings[0]);
	}
      readscore=topscore;
      while ((!feof(bron))&&
	     (readscore==topscore))
	{
	  fscanf(bron,"%f %s ",
		 &readscore,readsetting);
	  if (readscore==topscore)
	    {
	      strcpy(candidatesettings[nrcandidatesettings],readsetting);
	      if (strstr(candidatesettings[nrcandidatesettings],defaultsetting))
		{
		  defaultin=1;
		  strcpy(topsetting,candidatesettings[nrcandidatesettings]);
		}
	      nrcandidatesettings++;
	    }
	}
      fclose(bron);

      if (DEBUG)
	fprintf(stderr,"checking log... 3\n");

      if (nrcandidatesettings>1)
	{
	  fprintf(stderr,"%d settings have the same score!\n",
		  nrcandidatesettings);
	  sprintf(fname,"%s.%s.bestsetting",
		  argv[2],algostring);
	  doel=fopen(fname,"w");
	  if (doel==NULL)
	    {
	      fprintf(stderr,"Cannot write %s\n\n",
		      fname);
	      exit(1);
	    }
	  if (defaultin)
	    {
	      fprintf(stderr,"the default setting (%s) is among them.\nusing that setting as best setting.\n",
		      topsetting);
	      fprintf(doel,"%f %s\n",
		      topscore,topsetting);
	    }
	  else
	    {
	      randompick=(int) lrand48()%nrcandidatesettings;
	      fprintf(stderr,"picking a random best setting #%d: %s\n",
		      randompick+1,candidatesettings[randompick]);
	      fprintf(doel,"%f %s\n",
		      topscore,candidatesettings[randompick]);
	    }
	  fclose(doel);
	}
      fprintf(stderr,"wrapped progressive sampling process finished in ");
      
    }

  time(&endtime);
  learntime=(int) endtime - (int) begintime;
  fprintf(stderr,"%d second",
	  learntime);
  if (learntime>1)
    fprintf(stderr,"s");
  fprintf(stderr,"\n\n");

  // cleanup time
  sprintf(commandline,"rm %s.nrinst %s.nrclasses %s.classes %s.featcount %s.feat %s >& /dev/null\n",
	  argv[2],argv[2],argv[2],argv[2],argv[2],randomizedname);
  system(commandline);
  
  return 0;
}
