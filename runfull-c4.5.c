/** runfull-c4.5 - run a full experiment.

   syntax: runfull-c4.5 <filestem>

   assumes presence of <filestem.data.c4.5.bestsetting>
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

  sprintf(fnaam,"%s.data.c4.5.bestsetting",
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
  sprintf(cmd,"c4.5 -f %s -u -b ",
	  argv[1]);
  part=strtok(settings,"=");
  while (part!=NULL)
    {
      if (part[0]=='m')
	{
	  strcat(cmd,"-m ");
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
              
      if (part[0]=='c')
	{
	  strcat(cmd,"-c ");
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

      if (part[0]=='s')
	strcat(cmd,"-s ");

      if (part[0]=='g')
	strcat(cmd,"-g ");
                    
      part=strtok(NULL,"=");
    }
  
  sprintf(inter,"\n");
  strcat(cmd,inter);
  fprintf(stderr,"commandline: %s",
	  cmd);
  system(cmd);

  fprintf(stderr,"(best setting score was %s)\n\n",
	  dummy);

  return 0;
}
