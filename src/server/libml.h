//gsoap ns service name: libml
//gsoap ns service namespace: http://127.0.0.1/libml/libml.wsdl
//gsoap ns service location: http://127.0.0.1:4242
//gsoap ns service encoding: encoded

//gsoap ns schema namespace: urn:libml-server

typedef char *xsd__string;
typedef double *xsd__double;

/*
  Main functions for handling sessions.
*/

/*
  
*/
int ns__createObject(char *obj, int *result);

/*
  
*/
int ns__acceptVisitor(int obj, int visitor, int *result);

/*
  
*/
int ns__memObject(int obj, int *result);

/*
  
*/
int ns__getMarshal(int obj, xsd__string *marshal);

/*

*/
int ns__newSession(int *result);

/*

*/
int ns__stopServer(int *result);


/*
  Calls to the environment (verbosity, etc.).
*/

/*
  Sets the verbosity level.
*/
int ns__setVerbosity(int nb, int *result);
/*
  Returns the current verbosity level.
*/
int ns__getVerbosity(int *result);


/*
  Calls for neural networks
*/

/*
  Adds a pattern.
*/
int ns__addPattern(int obj, char *input, char *output, int *result);

/*
  Adds a set of patterns.
*/
int ns__addPatternSet(int obj, xsd__string inputPatterns, xsd__string outputPatterns, int *result);

/*
  Sets the number of layers.
*/
int ns__setLayerNb(int obj, int nb, int *result);

/*
  Sets the number of neurons per layer.
*/
int ns__setNeuronsPerLayer(int obj, char *nbTab, int *result);

/*
  Returns the number on neurons per layer.
*/
int ns__getNeuronsPerLayer(int obj, xsd__string *nbTab);

/*

*/
int ns__onLineEpoch(int obj, int iVisitor, int pVisitor,
		    int eVisitor, int lVisitor, int nb, int *result);

/*

*/
int ns__offLineEpoch(int obj, int iVisitor, int pVisitor,
		    int eVisitor, int lVisitor, int nb, int *result);

/*

*/
int ns__customEpoch(int obj, int iVisitor, int pVisitor,
		    int eVisitor, int lVisitor, int nb, int startPos,
		    int nbPos, int *result);

/*
  
*/
int ns__getOutputActivation(int obj, xsd__string *output);

/*

*/
int ns__getLastError(int obj, xsd__double error);

/*
  Returns the last learning error.
*/
int ns__getLastLearningError(int obj, xsd__double error);

/*

*/
int ns__getLearnError(int obj, int iVisitor, int pVisitor,
		      xsd__double error);

/*

*/
int ns__getTestError(int obj, int iVisitor, int pVisitor,
		     xsd__double error);

/*

*/
int ns__getValidateError(int obj, int iVisitor, int pVisitor,
			 xsd__double error);

/*
  Sets the corpus.
*/
int ns__setCorpus(int obj, char *corpusType, int *result);

/*

*/
int ns__setLearnPos(int obj, int pos, int *result);

/*

*/
int ns__setStep(int obj, char *step, int *result);
