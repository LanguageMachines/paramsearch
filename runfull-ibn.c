/** runfull - run a full experiment.

   syntax: runfull <data> <test>

   assumes presence of <data.bestsetting>
*/

#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main(int argc, char *argv[])
{
  FILE *bron;
  char dummy[32];
  char settings[1024];
  char *part;
  char fnaam[1024];
  char cmd[1024];
  char inter[1024];

  sprintf(fnaam,"%s.ibn.bestsetting",
	  argv[1]);
  bron=fopen(fnaam,"r");
  if (bron==NULL)
    {
      fprintf(stderr,"runfull error: %s not found\n\n",
	      fnaam);
      exit(1);
    }

  fscanf(bron,"%s %s ",
	 dummy,settings);
  fprintf(stderr,"best settings: %s %s\n",
	  dummy,settings);
  sprintf(cmd,"timbl -f %s -t %s ",
	      argv[1],argv[2]);
  part=strtok(settings,".");
  while ((part!=NULL)&&
	 (strcmp(part,"IB1")!=0))
    part=strtok(NULL,".");
  if (part==NULL)
    {
      fprintf(stderr,"Settings do not appear to be TiMBL settings.\n\n");
      exit(1);
    }
  while (part!=NULL)
    {
      if (part[0]=='k')
	{
	  sprintf(inter,"-%s ",
		  part);
	  strcat(cmd,inter);
	}
      
      if (part[0]=='L')
	{
	  sprintf(inter,"-%s ",
		  part);
	  strcat(cmd,inter);
	}
      
      if (part[0]=='M')
	{
	  sprintf(inter,"-m%s ",
		  part);
	  strcat(cmd,inter);
	}
      if (part[0]=='O')
	{
	  sprintf(inter,"-m%s ",
		  part);
	  strcat(cmd,inter);
	}
      if (part[0]=='J')
	{
	  sprintf(inter,"-m%s ",
		  part);
	  strcat(cmd,inter);
	}
      
      if (part[0]=='N')
	{
	  sprintf(inter,"-m%s ",
		  part);
	  strcat(cmd,inter);
	}
      if (part[0]=='D')
	{
	  sprintf(inter,"-m%s ",
		  part);
	  strcat(cmd,inter);
	}
      
      if (strcmp(part,"Z")==0)
	strcat(cmd,"-dZ ");
      if (strcmp(part,"IL")==0)
	strcat(cmd,"-dIL ");
      if (strcmp(part,"ID")==0)
	strcat(cmd,"-dID ");
      if ((part[0]=='E')&&
	  (part[1]=='D'))
	{
	  sprintf(inter,"-d%s ",
		  part);
	  strcat(cmd,inter);
	}
      
      if (strcmp(part,"nw")==0)
	strcat(cmd,"-w0 ");
      if (strcmp(part,"gr")==0)
	strcat(cmd,"-w1 ");
      if (strcmp(part,"ig")==0)
	strcat(cmd,"-w2 ");
      if (strcmp(part,"x2")==0)
	strcat(cmd,"-w3 ");
      if (strcmp(part,"sv")==0)
        strcat(cmd,"-w4 ");
      
      part=strtok(NULL,".");
    }
  strcat(cmd,"\n");
  fprintf(stderr,"commandline: %s",
	  cmd);
  system(cmd);
  fprintf(stderr,"(best setting score was %s)\n\n",
	  dummy);

  return 0;
}
