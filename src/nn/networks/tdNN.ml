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
  The tdNN virtual class (Time Delay Neural Network)
  
  @author Matthieu Lagacherie
  @author Olivier Ricordeau
  @since 28/07/2003
*)

open Nn
open DefaultVisitor
open CommonXml

class tdNN =
object (this)

  inherit nn as super

  (**
    The Ctor.
  *)
  initializer
    _className <- "tdNN";
    _classTag <- "tdnn"

  val mutable _outputActivation = [|[|[|0.0|]|]|]

  val mutable _inputSum = [|[|[|0.0|]|]|]

  val mutable _error = [|[|[|0.0|]|]|]

  val mutable _weights = [|[|[|[|0.0|]|]|]|]

  val mutable _gradients = [|[|[|[|0.0|]|]|]|]

  val mutable _layerNb = 0

  val mutable _delay = [|0|]

  val mutable _featuresNb = [|0|]

  val mutable _timeNb = [|0|]

  val mutable _fieldSize = [|0|]

  (**

  *)
  method getOutputActivation =
    ref _outputActivation

  method getInputSum =
    ref _inputSum

  method getError =
    ref _error

  method getWeights =
    ref _weights

  method getGradients =
    ref _gradients

  method getLayerNb =
    _layerNb

  method getDelay =
    ref _delay

  method getFeaturesNb =
    _featuresNb

  method getTimeNb =
    _timeNb

  method getFieldSize =
    _fieldSize

  (**
    Accessors set
  *)
  method setOutputActivation outputActivation =
    _outputActivation <- outputActivation

  method setInputSum inputSum =
    _inputSum <- inputSum

  method setError error =
    _error <- error

  method setWeights weights =
    _weights <- weights
      
  method setGradients gradients =
    _gradients <- gradients

  method setLayerNb layerNb =
    _layerNb <- layerNb

  method setDelay delay =
    _delay <- delay
      
  method setFeaturesNb featuresNb =
    _featuresNb <- featuresNb

  method setTimeNb timeNb =
    _timeNb <- timeNb
   
  method setFieldSize fieldSize =
    _fieldSize <- fieldSize

  method setInputActivation inputSumActivation =
    _inputSum.(0) <- inputSumActivation

  (**
    Dumps the neural network as XML.
  *)
  method toXml =
    super#toXml_nn_begin ^
    CommonXml.openTag _classTag ^
    CommonXml.openTag "tdnn_output_activation" ^
    CommonXml.dump4dArray _outputActivation string_of_float ^
    CommonXml.closeTag "tdnn_output_activation" ^
    CommonXml.openTag "tdnn_input_sum" ^
    CommonXml.dump4dArray _inputSum string_of_float ^
    CommonXml.closeTag "tdnn_input_sum" ^
    CommonXml.openTag "tdnn_error" ^
    CommonXml.dump4dArray _error string_of_float ^
    CommonXml.closeTag "tdnn_error" ^
    CommonXml.openTag "tdnn_weights" ^
    CommonXml.dump5dArray _weights string_of_float ^
    CommonXml.closeTag "tdnn_weights" ^
    CommonXml.openTag "tdnn_gradients" ^
    CommonXml.dump5dArray _gradients string_of_float ^
    CommonXml.closeTag "tdnn_gradients" ^
    ("<layer_nb>" ^ (string_of_int _layerNb) ^ "</layer_nb>") ^
    CommonXml.openTag "tdnn_delay" ^
    CommonXml.dump2dArray _delay string_of_int ^
    CommonXml.closeTag "tdnn_delay" ^
    CommonXml.openTag "tdnn_features_nb" ^
    CommonXml.dump2dArray _featuresNb string_of_int ^
    CommonXml.closeTag "tdnn_features_nb" ^
    CommonXml.openTag "tdnn_time_nb" ^
    CommonXml.dump2dArray _timeNb string_of_int ^
    CommonXml.closeTag "tdnn_time_nb" ^
    CommonXml.openTag "tdnn_field_size" ^
    CommonXml.dump2dArray _fieldSize string_of_int ^
    CommonXml.closeTag "tdnn_field_size" ^
    CommonXml.closeTag _classTag ^
    super#toXml_nn_end
    
end
  
