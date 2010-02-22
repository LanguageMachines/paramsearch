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

  sprintf(fnaam,"%s.fambl.bestsetting",
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
  sprintf(cmd,"Fambl -f %s -t %s ",
	      argv[1],argv[2]);
  part=strtok(settings,".");
  while ((part!=NULL)&&
         (strcmp(part,"Fambl")!=0))
    part=strtok(NULL,".");
  if (part==NULL)
    {
      fprintf(stderr,"Settings do not appear to be Fambl settings.\n\n");
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
      
      if (part[0]=='K')
	{
	  sprintf(inter,"-%s ",
		  part);
	  strcat(cmd,inter);
	}
      
      if (part[0]=='x')
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
	  strcat(cmd,"-m1 ");
	}
      if (part[0]=='O')
	{
	  strcat(cmd,"-m0 ");
	}
      if (part[0]=='J')
	{
	  strcat(cmd,"-m2 ");
	}
      
      if (part[0]=='S')
	{
	  sprintf(inter,"-%s ",
		  part);
	  strcat(cmd,inter);
	}

      if (strcmp(part,"IL")==0)
	strcat(cmd,"-d1 ");
      if (strcmp(part,"ID")==0)
	strcat(cmd,"-d2 ");
      if (strcmp(part,"ED")==0)
	strcat(cmd,"-d3 ");

      if (strcmp(part,"nw")==0)
	strcat(cmd,"-g0 ");
      if (strcmp(part,"gr")==0)
	strcat(cmd,"-g2 ");
      if (strcmp(part,"ig")==0)
	strcat(cmd,"-g1 ");
      if (strcmp(part,"x2")==0)
	strcat(cmd,"-g3 ");
      if (strcmp(part,"sv")==0)
        strcat(cmd,"-g4 ");
      
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
