(******************************************************************
  [LibML - Machine Learning Library]
  http://libml.org
  Copyright (C) 2002 - 2003  LAGACHERIE Matthieu RICORDEAU Olivier
  
  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License
  as published by the Free Software Foundation; either version 2
  of the License, or (at your option) any later version. This
  program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details. You should have
  received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
  USA.
  
  SPECIAL NOTE (the beerware clause):
  This software is free software. However, it also falls under the beerware
  special category. That is, if you find this software useful, or use it
  every day, or want to grant us for our modest contribution to the
  free software community, feel free to send us a beer from one of
  your local brewery. Our preference goes to Belgium abbey beers and
  irish stout (Guiness for strength!), but we like to try new stuffs.

  Authors:
  Matthieu LAGACHERIE
  E-mail : matthieu@libml.org
  
  Olivier RICORDEAU
  E-mail : olivier@libml.org

 ****************************************************************)

(**
  The MLPNN class
  
  This class is a Multi-Layer Perceptron.
  @author Matthieu Lagacherie
  @author Olivier Ricordeau
  @since 07/10/2003
*)

open Nn
open DefaultVisitor
open CommonXml

class mlpNN =
object (this)
  
  inherit nn as super
    
  initializer
    _className <- "mlpNN";
    _classTag <- "mlpnn"
      
  (**
    The output activation 3-dimensional array. Stores the network's neuron's
    output activation.
  *)
  val mutable _outputActivation = [|[|0.0|]|]

  (**
    The input sum 3-dimensional array. Stores the network's neuron's input sum.
  *)
  val mutable _inputSum = [|[|0.0|]|]

  (**
    The error 3-dimensional array. Stores the network's neuron's error term.
  *)
  val mutable _error = [|[|0.0|]|]

  (**
    The weights 4-dimensional array. Stores the weights of the connections
    between the neurons.
  *)
  val mutable _weights = [|[|[|0.0|]|]|]

  (**
    The gradients 4-dimensional array. Stores component of the gradient
    (for the minimization by gradient decent).
  *)
  val mutable _gradients = [|[|[|0.0|]|]|]

  (**
    The number of layers in the network.
  *)
  val mutable _layerNb = 0

  (**
    The number of neurones per layer.
  *)
  val mutable _neuronsPerLayer = [|0|]

  (**
    A get*.
    @return The output activation 3-dimensional array.
  *)
  method getOutputActivation =
    ref _outputActivation

  (**
    A get*.
    @return The output activation 3-dimensional array (copy).
  *)
  method getIndexOutputActivation i =
    _outputActivation.(i)

  (**
    A get*.
    @return The input sum 3-dimensional array.
  *)
  method getInputSum =
    ref _inputSum

  (**
    A get*.
    @return The error sum 3-dimensional array.
  *)
  method getError =
    ref _error

  (**
    A get*.
    @return The error of the network for the last pattern
  *)
  method getLastError =
    let e = ref 0.0 in
      for i = 0 to (Array.length _error.((Array.length _error) -1))-1 do
	e := !e +. _error.((Array.length _error) -1).(i) *.
	  _error.((Array.length _error) -1).(i)
      done;!e

  (**
    A get*.
    @return The weights 4-dimensional array.
  *)
  method getWeights =
    ref _weights

  (**
    A get*.
    @return The gradients 4-dimensional array.
  *)
  method getGradients =
    ref _gradients

  (**
    A get*.
    @return The number of layers in the network.
  *)
  method getLayerNb =
    _layerNb

  (**
    A get*.
    @return The number of neurones per layer in network.
  *)
  method getNeuronsPerLayer =
    _neuronsPerLayer

  (**
    Sets the output activations array.
  *)
  method setOutputActivation outputActivation =
    _outputActivation <- outputActivation
						  
  (**
    Sets the input sums array.
  *)
  method setInputSum inputSum =
    _inputSum <- inputSum
				  
  (**
    Sets the errors array.
  *)
  method setError error =
    _error <- error
			    
  (**
    Sets the weights array.
  *)
  method setWeights weights =
    _weights <- weights
				
  (**
    Sets the gradients array.
  *)
  method setGradients gradients =
    _gradients <- gradients

  (**
    Sets the number of layers.
  *)
  method setLayerNb layerNb =
    _layerNb <- layerNb

  (**
    Sets the number of neurons per layer.
  *)
  method setNeuronsPerLayer neuronsPerLayer =
    _neuronsPerLayer <- neuronsPerLayer

  (**
    Sets the number of layers.
  *)
  method setLayerNb layerNb =
    _layerNb <- layerNb

  (**
    Sets the input activations.
  *)
  method setInputActivation inputSumActivation =
    _inputSum.(0) <- inputSumActivation

  (**
    Sets the first output activations.
  *)
  method setFirstOutputActivation inputActivation =
    _outputActivation.(0) <- inputActivation

  (**
    Return the marshal of the object
  *)
  method getMarshal =
    Printf.sprintf "TAG:%s\nSTEP:%f\nCORPUSTYPE:%s\nLEARNINGCORPUS:%s\n
TESTINGCORPUS:%s\nVALIDATINGCORPUS:%s\nLEARNLEARNPOS:%d\nTESTLEARNPOS:%d\n
VALIDATELEARNPOS:%d\nLAYER_NB:%d\nNEURONS_PER_LAYERS:%s\nOUTPUT_ACTIVATION:\n%s\n
INPUT_SUM:\n%s\nERROR:\n%s\nWEIGHTS:\n%s\nEND_MARSHAL\n"
      _classTag
      _step
      _corpus
      _learningCorpus#getMarshal
      _testingCorpus#getMarshal
      _validatingCorpus#getMarshal
      _learningCorpus#getLearnPos
      _testingCorpus#getLearnPos
      _validatingCorpus#getLearnPos
      _layerNb
      (Common.string_of_int_array(_neuronsPerLayer))
      (Common.string_of_float_array_array(_outputActivation))
      (Common.string_of_float_array_array(_inputSum))
      (Common.string_of_float_array_array(_error))
      (Common.string_of_float_array_array_array(_weights))
      
(**
      (Marshal.to_string _classTag [])
      (Marshal.to_string _weights [])
*)
  (**
    Dumps the neural network as XML.
  *)
  method toXml =
    super#toXml_nn_begin ^
    CommonXml.openTag _classTag ^
    CommonXml.openTag "mlpnn_output_activation" ^
    CommonXml.dump3dArray _outputActivation string_of_float ^
    CommonXml.closeTag "mlpnn_output_activation" ^
    CommonXml.openTag "mlpnn_input_sum" ^
    CommonXml.dump3dArray _inputSum string_of_float ^
    CommonXml.closeTag "mlpnn_input_sum" ^
    CommonXml.openTag "mlpnn_error" ^
    CommonXml.dump3dArray _error string_of_float ^
    CommonXml.closeTag "mlpnn_error" ^
    CommonXml.openTag "mlpnn_weights" ^
    CommonXml.dump4dArray _weights string_of_float ^
    CommonXml.closeTag "mlpnn_weights" ^
    CommonXml.openTag "mlpnn_gradients" ^
    CommonXml.dump4dArray _gradients string_of_float ^
    CommonXml.closeTag "mlpnn_gradients" ^
    "<layer_nb>" ^ (string_of_int _layerNb) ^ "</layer_nb>" ^
    CommonXml.openTag "mlpnn_neurons_per_layer" ^
    CommonXml.dump2dArray _neuronsPerLayer string_of_int ^
    CommonXml.closeTag "mlpnn_neurons_per_layer" ^
    CommonXml.closeTag _classTag ^
    super#toXml_nn_end
      
end


(**
  Compute the mean of the quadratic error
  The arguments are MQEL MlpNN InputVisitor PropagateVisitor.
  @return the MQEL error.
*)
let getMlpNNGenericError (obj : mlpNN) iV pV =
  let realOutput = ref [|[||]|] and
    output = ref [|[||]|] and
    corpus = obj#getCorpus and
    patternNb = (obj#getCorpus)#getPatternNumber and
    outputSize = obj#getNeuronsPerLayer.(obj#getLayerNb - 1) and
    error = ref 0.0 and
    errorTemp = ref 0.0 and
    lastLayer = obj#getLayerNb - 1 in
    begin
      obj#setLearnPos 0;
      output := Array.create patternNb [||];
      realOutput := Array.create patternNb [||];
      for i = 0 to patternNb - 1 do
	(!output).(i) <- obj#getOutputLearnVector;
	obj#incLearnPos
      done;
      for i = 0 to patternNb - 1 do
	obj#setLearnPos i;
	obj#accept iV;
	obj#accept pV;
	(!realOutput).(i) <- Common.float_array_of_string(
	  Common.string_of_float_array(obj#getIndexOutputActivation lastLayer))
      done;
      for i = 0 to outputSize - 1 do
	errorTemp := 0.0;
	for j = 0 to patternNb - 1 do
	  errorTemp := !errorTemp +.
	    (!realOutput.(j).(i) -. !output.(j).(i)) *.
	    (!realOutput.(j).(i) -. !output.(j).(i))
	done;
	errorTemp := !errorTemp /. float_of_int(patternNb);
	error := !error +. !errorTemp
      done;
      !error
    end;;

(**
  Compute the mean of the quadratic error on the learning base.
  The arguments are MQEL MlpNN InputVisitor PropagateVisitor.
  @return the MQEL error.
*)
let getMlpNNLearnError (obj : mlpNN) iV pV =
  obj#setCorpus "learningCorpus";
  getMlpNNGenericError obj iV pV;;

(**
  Compute the mean of the quadratic error on the testing base.
  The arguments are MQEL MlpNN InputVisitor PropagateVisitor.
  @return the MQEL error.
*)
let getMlpNNTestError (obj : mlpNN) iV pV =
  obj#setCorpus "testingCorpus";
  getMlpNNGenericError obj iV pV;;

(**
  Compute the mean of the quadratic error on the validating base.
  The arguments are MQEL MlpNN InputVisitor PropagateVisitor.
  @return the MQEL error.
*)
let getMlpNNValidateError (obj : mlpNN) iV pV =
  obj#setCorpus "validatingCorpus";
  getMlpNNGenericError obj iV pV;;
