#include <caml/mlvalues.h>
#include "serverMain.h"

value		serverLaunch(value cargc, value cargv)
{
  int		argc = Int_val(cargc);
  char		**argv;
  int		i;

  argv = malloc(sizeof (char *) * (argc + 1));
  for (i = 0; i < argc; i++)
    argv[i] = (char *)Field(cargv, i);
  argv[i] = NULL;
  return Val_int(serverMain(Int_val(cargc), argv));
}
