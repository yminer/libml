#include "soapH.h"
#include "libml.nsmap"
#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>

int serverMain(int argc, char **argv)
{ 
  int m, s; /* master and slave sockets */
  int i;
  struct soap soap;

  if (argc < 3)
    {
      printf("Usage : mld Host Port\n");
      printf("-> Ex for a local use : ./mld \"127.0.0.1\" 4242\n");
      exit(1);
    }
  soap_init(&soap);
  m = soap_bind(&soap, argv[1], atoi(argv[2]), 100);
  if (m < 0)
    soap_print_fault(&soap, stderr);
  else
    {
      fprintf(stderr, "Socket connection successful: master socket = %d\n", m);
      for (i = 1; ; i++)
	{
	  s = soap_accept(&soap);
	  if (s < 0)
	    { 
	      soap_print_fault(&soap, stderr);
	      break;
	    } 
	  fprintf(stderr, 
		  "%d : accepted connection from IP=%d.%d.%d.%d socket=%d\n",
		  i,
		  (soap.ip >> 24) & 0xFF,
		  (soap.ip >> 16) & 0xFF,
		  (soap.ip >> 8) & 0xFF,
		  soap.ip & 0xFF, s);
	  soap_serve(&soap);
	  fprintf(stderr, "request served\n");
	  soap_destroy(&soap);
	  soap_end(&soap);
	}
    }
  soap_done(&soap);
  return 0;
} 

int ns__stopServer(struct soap *soap, int *result)
{
  *result = 0;
  printf("Stopping the server...\n");
  exit(0);
  return SOAP_OK;
}

int ns__createObject(struct soap *soap, char *obj, int *result)
{
  value v = copy_string(obj);
  static value *functionLibML = NULL;

  printf("Creation of %s object\n", obj);
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("createObject");
  *result = Int_val(callback(*functionLibML, v));
  if (*result == -1)
    {
      char *s = (char*)soap_malloc(soap, 1024);
      sprintf(s, "<error xmlns=\"http://libml.org/\">Unable to create the object %s.</error>", obj);
      return soap_sender_fault(soap, "createObject function error : ", s);
    }
  return SOAP_OK;
}

int ns__memObject(struct soap *soap, int obj, int *result)
{
  value v = Val_int(obj);
  static value *functionLibML = NULL;

  printf("Test the object %d\n", obj);
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("memObject");
  *result = Int_val(callback(*functionLibML, v));
  return SOAP_OK;
}


int ns__acceptVisitor(struct soap *soap, int obj, int visitor, int *result)
{
  value vObj = Val_int(obj);
  value vVisitor = Val_int(visitor);
  static value *functionLibML = NULL;

  printf("The object %d trying to accept %d\n", obj, visitor);
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("acceptVisitor");
  *result = Int_val(callback2(*functionLibML, vObj, vVisitor));
  if (*result == -1)
    {
      char *s = (char*)soap_malloc(soap, 1024);
      sprintf(s, "Unable to apply the visitor %d to %d.", visitor, obj);
      return soap_sender_fault(soap, "acceptVisitor function error : ", s);
    }
  return SOAP_OK;
}

int ns__addPattern(struct soap *soap, int obj, char *input, char *output, int *result)
{
  value vObj = Val_int(obj);
  value vInput = copy_string(input);
  value vOutput = copy_string(output);
  static value *functionLibML = NULL;

  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("addPattern");
  *result = Int_val(callback3(*functionLibML, vObj, vInput, vOutput));
  if (*result == -1)
    {
      char *s = (char*)soap_malloc(soap, 1024);
      sprintf(s, "Unable to add the pattern input:%s output:%s to object %d.", input, output, obj);
      return soap_sender_fault(soap, "addPattern function error : ", s);
    }
  return SOAP_OK;
}

int ns__addPatternSet(struct soap *soap, int obj, char *inputPatterns, char *outputPatterns, int *result)
{
  value vObj = Val_int(obj);
  static value *functionLibML = NULL;
  char	*precIn, *posIn;
  char	*posOut, *precOut;
  int	i, j;

  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("addPattern");
  precIn = inputPatterns;
  precOut = outputPatterns;
  while ((*precIn != '\0') && (*precOut != '\0'))
    {
      posIn = precIn;
      posOut = precOut;
      while (*posIn != ':')
	posIn++;
      while (*posOut != ':')
	posOut++;
      *posIn = '\0';
      *posOut = '\0';
      /*      printf("IN=%s\n", precIn);
	      printf("OUT=%s\n", precOut); */
      *result = Int_val(callback3(*functionLibML, vObj, copy_string(precIn), copy_string(precOut)));
      precIn = posIn + 1;
      precOut = posOut + 1;
    }
  if (*result == -1)
    {
      char *s = (char*)soap_malloc(soap, 1024);
      sprintf(s, "Unable to add the pattern set to object %d.", obj);
      return soap_sender_fault(soap, "addPatternSet function error : ", s);
    }
  return SOAP_OK;
}

int ns__setLayerNb(struct soap *soap, int obj, int nb, int *result)
{
  value vObj = Val_int(obj);
  value vNb = Val_int(nb);
  static value *functionLibML = NULL;

  printf("Set the nb of layers for the object %d\n", obj);
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("setLayerNb");
  *result = Int_val(callback2(*functionLibML, vObj, vNb));
  if (*result == -1)
    {
      char *s = (char*)soap_malloc(soap, 1024);
      sprintf(s, "<error xmlns=\"http://libml.org/\">Unable to set the number of layers of the object %d.</error>", obj);
      return soap_sender_fault(soap, "setLayerNb function error : ", s);
    }
  return SOAP_OK;
}

int ns__setNeuronsPerLayer(struct soap *soap, int obj,
			   char *nbTab, int *result)
{
  value vObj = Val_int(obj);
  value vNb = copy_string(nbTab);
  static value *functionLibML = NULL;

  printf("Set the nb of neurons for the object %d\n", obj);
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("setNeuronsPerLayer");
  *result = Int_val(callback2(*functionLibML, vObj, vNb));
  if (*result == -1)
    {
      char *s = (char*)soap_malloc(soap, 1024);
      sprintf(s, "<error xmlns=\"http://libml.org/\">Unable to set the number of neurons for the object %d.</error>", obj);
      return soap_sender_fault(soap, "setNeuronsPerLayer function error : ", s);
    }
  return SOAP_OK;
}

int ns__getNeuronsPerLayer(struct soap *soap, int obj,
			   xsd__string *nbTab)
{
  value vObj = Val_int(obj);
  static value *functionLibML = NULL;

  printf("Get the nb of neurons for the object %d\n", obj);
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("getNeuronsPerLayer");
  *nbTab = String_val(callback(*functionLibML, vObj));
  return SOAP_OK;
}

int ns__onLineEpoch(struct soap *soap, int obj, int iVisitor, int pVisitor, 
	       int eVisitor, int lVisitor, int nb, int *result)
{
  value vObj = Val_int(obj);
  value vNb = Val_int(nb);
  value viVisitor = Val_int(iVisitor);
  value vpVisitor = Val_int(pVisitor);
  value veVisitor = Val_int(eVisitor);
  value vlVisitor = Val_int(lVisitor);
  static value *functionLibML = NULL;
  value res = alloc_tuple(6);

  Field(res, 0) = vObj;
  Field(res, 1) = viVisitor;
  Field(res, 2) = vpVisitor;
  Field(res, 3) = veVisitor;
  Field(res, 4) = vlVisitor;
  Field(res, 5) = vNb;
  printf("Launch a epoch with the object %d\n", obj);
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("onLineEpoch");
  *result = Int_val(callbackN(*functionLibML, 6, res));
  return SOAP_OK;
}


int ns__offLineEpoch(struct soap *soap, int obj, int iVisitor, int pVisitor, 
	       int eVisitor, int lVisitor, int nb, int *result)
{
  value vObj = Val_int(obj);
  value vNb = Val_int(nb);
  value viVisitor = Val_int(iVisitor);
  value vpVisitor = Val_int(pVisitor);
  value veVisitor = Val_int(eVisitor);
  value vlVisitor = Val_int(lVisitor);
  static value *functionLibML = NULL;
  value res = alloc_tuple(6);

  Field(res, 0) = vObj;
  Field(res, 1) = viVisitor;
  Field(res, 2) = vpVisitor;
  Field(res, 3) = veVisitor;
  Field(res, 4) = vlVisitor;
  Field(res, 5) = vNb;
  printf("Launch a epoch with the object %d\n", obj);
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("offLineEpoch");
  *result = Int_val(callbackN(*functionLibML, 6, res));
  return SOAP_OK;
}

int ns__getLastError(struct soap *soap, int obj, xsd__double error)
{
  value vObj = Val_int(obj);
  static value *functionLibML = NULL;

  printf("Get the error of the object %d\n", obj);
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("getLastError");
  *error = Double_val(callback(*functionLibML, vObj));
  return SOAP_OK;
}

int ns__getLastLearningError(struct soap *soap, int obj, xsd__double error)
{
  value vObj = Val_int(obj);
  static value *functionLibML = NULL;

  printf("Get the last learning error of the object %d\n", obj);
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("getLastLearningError");
  *error = Double_val(callback(*functionLibML, vObj));
  return SOAP_OK;
}

int ns__getOutputActivation(struct soap *soap, int obj, xsd__string *output)
{
  value vObj = Val_int(obj);
  static value *functionLibML = NULL;

  printf("Get the output activation of the object %d\n", obj);
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("getOutputActivation");
  *output = String_val(callback(*functionLibML, vObj));
  return SOAP_OK;
}

int ns__getLearnError(struct soap *soap, int obj, int iVisitor, int pVisitor, 
		      xsd__double error)
{
  value vObj = Val_int(obj);
  value viVisitor = Val_int(iVisitor);
  value vpVisitor = Val_int(pVisitor);
  static value *functionLibML = NULL;

  printf("Get the learning error for the object %d\n", obj);
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("getLearnError");
  *error = Double_val(callback3(*functionLibML, vObj, viVisitor, vpVisitor));
  return SOAP_OK;
}


int ns__getTestError(struct soap *soap, int obj, int iVisitor, int pVisitor, 
		     xsd__double error)
{
  value vObj = Val_int(obj);
  value viVisitor = Val_int(iVisitor);
  value vpVisitor = Val_int(pVisitor);
  static value *functionLibML = NULL;

  printf("Get the testing error for the object %d\n", obj);
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("getTestError");
  *error = Double_val(callback3(*functionLibML, vObj, viVisitor, vpVisitor));
  return SOAP_OK;
}


int ns__getValidateError(struct soap *soap, int obj, int iVisitor, int pVisitor, 
			 xsd__double error)
{
  value vObj = Val_int(obj);
  value viVisitor = Val_int(iVisitor);
  value vpVisitor = Val_int(pVisitor);
  static value *functionLibML = NULL;

  printf("Get the validating error for the object %d\n", obj);
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("getValidateError");
  *error = Double_val(callback3(*functionLibML, vObj, viVisitor, vpVisitor));
  return SOAP_OK;
}


int ns__getMarshal(struct soap *soap, int obj, xsd__string *marshal)
{
  value vObj = Val_int(obj);
  value v;
  static value *functionLibML = NULL;
  char *c;

  printf("Get the marshal for the object %d\n", obj);
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("getMarshal");
  *marshal = String_val(callback(*functionLibML, vObj));
  return SOAP_OK;
}


int ns__newSession(struct soap *soap, int *result)
{
  value v = Val_int(*result);
  static value *functionLibML = NULL;

  printf("NEW SESSION\n");
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("newSession");
  *result = Int_val(callback(*functionLibML, v));
  return SOAP_OK;
}

int ns__setCorpus(struct soap *soap, int obj, char *corpusType, int *result)
{
  value vObj = Val_int(obj);
  value vCorpusType = copy_string(corpusType);
  static value *functionLibML = NULL;

  printf("Set the corpus of the object %d\n", obj);
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("setCorpus");
  *result = Int_val(callback2(*functionLibML, vObj, vCorpusType));
  return SOAP_OK;
}

int ns__setLearnPos(struct soap *soap, int obj, int pos, int *result)
{
  value vObj = Val_int(obj);
  value vPos = Val_int(pos);
  static value *functionLibML = NULL;

  printf("Set the learning position of the object %d\n", obj);
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("setLearnPos");
  *result = Int_val(callback2(*functionLibML, vObj, vPos));
  return SOAP_OK;
}

int ns__setStep(struct soap *soap, int obj, char *step, int *result)
{
  value vObj = Val_int(obj);
  value v = copy_string(step);
  static value *functionLibML = NULL;

  printf("Set the step of the object %d\n", obj);
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("setStep");
  callback2(*functionLibML, vObj, v);
  *result = 0;
  return SOAP_OK;
}

int ns__customEpoch(struct soap *soap, int obj, int iVisitor, int pVisitor,
		    int eVisitor, int lVisitor, int nb, int startPos,
		    int nbPos, int *result)
{
  value vObj = Val_int(obj);
  value vNb = Val_int(nb);
  value vStartPos = Val_int(startPos);
  value vNbPos = Val_int(nbPos);
  value viVisitor = Val_int(iVisitor);
  value vpVisitor = Val_int(pVisitor);
  value veVisitor = Val_int(eVisitor);
  value vlVisitor = Val_int(lVisitor);
  static value *functionLibML = NULL;
  value res = alloc_tuple(8);

  Field(res, 0) = vObj;
  Field(res, 1) = viVisitor;
  Field(res, 2) = vpVisitor;
  Field(res, 3) = veVisitor;
  Field(res, 4) = vlVisitor;
  Field(res, 5) = vNb;
  Field(res, 6) = vStartPos;
  Field(res, 7) = vNbPos;
  printf("Launching a custom epoch with the object %d (nb=%d, startPos=%d, nbPos=%d)\n",
	 obj, nb, startPos, nbPos);
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("customEpoch");
  *result = Int_val(callbackN(*functionLibML, 8, res));
  return SOAP_OK;
}


/*
  calls to the environment (verbosity, etc.).
*/

int ns__setVerbosity(struct soap *soap, int nb, int *result)
{
  value vNb = Val_int(nb);
  static value *functionLibML = NULL;
  
  printf("Setting verbosity to %d\n", nb);
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("setVerbosity");
  *result = Int_val(callback2(*functionLibML, vNb));
  if (*result == -1)
    {
      char *s = (char*)soap_malloc(soap, 1024);
      sprintf(s, "<error xmlns=\"http://libml.org/\">Unable to set verbosity to %d.</error>", nb);
      return soap_sender_fault(soap, "setVerbosity function error : ", s);
    }
  return SOAP_OK;
}

int ns__getVerbosity(struct soap *soap, int *result)
{
  static value *functionLibML = NULL;
  
  printf("Getting verbosity\n");
  if (functionLibML == NULL)
    functionLibML = (value *)caml_named_value("getVerbosity");
  *result = Int_val(callback2(*functionLibML));
  if (*result == -1)
    {
      char *s = (char*)soap_malloc(soap, 1024);
      sprintf(s, "<error xmlns=\"http://libml.org/\">Unable to get verbosity.</error>");
      return soap_sender_fault(soap, "getVerbosity function error : ", s);
    }
  return SOAP_OK;
}
