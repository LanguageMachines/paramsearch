/** runfull-maxent - run a full experiment.

   syntax: runfull-maxent <datafile> <testfile>

   assumes presence of <datafile.maxent.bestsetting>
*/

#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main(int argc, char *argv[])
{
  FILE *bron;
  int  j;
  char dummy[32];
  char settings[1024];
  char *part;
  char fnaam[1024];
  char cmd[1024];
  char inter[1024];

  sprintf(fnaam,"%s.maxent.bestsetting",
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
  sprintf(cmd,"maxent ");
  part=strtok(settings,"=");
  while (part!=NULL)
    {
      if (part[0]=='e')
	{
	  j=2;
	  strcpy(inter,"");
	  while (j<strlen(part))
	    {
	      strcat(inter," ");
	      inter[strlen(inter)-1]=part[j];
	      j++;
	    }
	  strcat(cmd,inter);
	  strcat(cmd," ");
	}
              
      if (part[0]=='g')
	{
	  strcat(cmd,"-g ");
	  j=2;
	  strcpy(inter,"");
	  while (j<strlen(part))
	    {
	      strcat(inter," ");
	      inter[strlen(inter)-1]=part[j];
	      j++;
	    }
	  strcat(cmd,inter);
	  strcat(cmd," ");
	}
              
      part=strtok(NULL,"=");
    }
  
  sprintf(inter,"%s -m %s.model -i 100 -b -c 0 >& /dev/null\n",
	  argv[1],argv[1]);
  strcat(cmd,inter);
  fprintf(stderr,"commandline: %s",
	  cmd);
  system(cmd);

  sprintf(cmd,"maxent -p -m %s.model %s -o %s.out\n",
	  argv[1],argv[2],argv[2]);
  fprintf(stderr,"commandline: %s",
	  cmd);
  system(cmd);

  fprintf(stderr,"(best setting score was %s)\n\n",
	  dummy);

  return 0;
}
