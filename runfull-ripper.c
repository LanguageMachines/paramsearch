/** runfull-ripper - run a full experiment.

   syntax: runfull-ripper <filestem>

   assumes presence of <filestem.data.ripper.bestsetting>
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
  char memsettings[1024];
  char *part;
  char fnaam[1024];
  char cmd[1024];
  char inter[1024];

  sprintf(fnaam,"%s.data.ripper.bestsetting",
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
  strcpy(memsettings,"");
  for (j=0; j<strlen(settings); j++)
    {
      if (settings[j]=='!')
	strcat(memsettings,"\\");
      strcat(memsettings," ");
      memsettings[strlen(memsettings)-1]=settings[j];
    }

  fprintf(stderr,"best settings: %s %s\n",
	  dummy,memsettings);
  sprintf(cmd,"ripper %s ",
	      argv[1]);
  part=strtok(settings,"=");
  while (part!=NULL)
    {
      if (part[0]=='f')
	{
	  strcat(cmd,"-F");
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
              
      if (part[0]=='a')
	{
	  strcat(cmd,"-a");
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

      if (part[0]=='n')
	{
	  j=2;
	  strcpy(inter,"");
	  while (j<strlen(part))
	    {
	      if (part[j]=='!')
		strcat(inter,"\\");
	      strcat(inter," ");
	      inter[strlen(inter)-1]=part[j];
	      j++;
	    }
	  strcat(cmd,inter);
	  strcat(cmd," ");
	}
              
      if (part[0]=='s')
	{
	  strcat(cmd,"-S");
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

      if (part[0]=='o')
	{
	  strcat(cmd,"-O");
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

      if (part[0]=='l')
	{
	  strcat(cmd,"-L");
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
  
  strcat(cmd,"\n");
  fprintf(stderr,"commandline: %s",
	  cmd);
  system(cmd);

  sprintf(cmd,"ripper %s -N > %s.names\n",
	  argv[1],argv[1]);
  fprintf(stderr,"commandline: %s",
	  cmd);
  system(cmd);

  sprintf(cmd,"predict %s > %s.out\n",
	  argv[1],argv[1]);
  fprintf(stderr,"commandline: %s",
	  cmd);
  system(cmd);

  fprintf(stderr,"(best setting score was %s)\n\n",
	  dummy);

  return 0;
}
