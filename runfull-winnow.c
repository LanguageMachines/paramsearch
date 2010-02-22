/** runfull-winnow - run a full experiment.

   syntax: runfull-winnow <datafile> <testfile>

   assumes presence of <datafile>.winnow.bestsetting
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

  sprintf(fnaam,"%s.winnow.bestsetting",
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
  sprintf(cmd,"snow -train -g - -I %s -F %s.net -W",
	  argv[1],argv[1]);
  part=strtok(settings,"=");
  while (part!=NULL)
    {
      if (part[0]=='p')
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
	  strcat(cmd,",");
	}              
      if (part[0]=='d')
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
	  strcat(cmd,",");
	}
      if (part[0]=='t')
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
	  strcat(cmd,",1:0-");
	}
      if (part[0]=='c')
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
              
      if (part[0]=='r')
	{
	  strcat(cmd,"-r ");
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
	{
	  strcat(cmd,"-S ");
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

  sprintf(cmd,"snow -test -I %s -F %s.net\n",
	  argv[2],argv[1]);
  fprintf(stderr,"commandline: %s",
	  cmd);
  system(cmd);

  fprintf(stderr,"(best setting score was %s)\n\n",
	  dummy);

  return 0;
}
