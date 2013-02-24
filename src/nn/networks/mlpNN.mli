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
  The MLPNN virtual class
  
  This class is an abstract Multi-Layer Perceptron.
  @author Matthieu Lagacherie
  @author Olivier Ricordeau
  @since 07/10/2003
*)

open Nn
open DefaultVisitor

class mlpNN :
object 
  
  inherit nn
    
  (**
    The output activation 3-dimensional array. Stores the network's neuron's
    output activation.
  *)
  val mutable _outputActivation : float array array

  (**
    The input sum 3-dimensional array. Stores the network's neuron's input sum.
  *)
  val mutable _inputSum : float array array

  (**
    The error 3-dimensional array. Stores the network's neuron's error term.
  *)
  val mutable _error : float array array

  (**
    The weights 4-dimensional array. Stores the weights of the connections
    between the neurons.
  *)
  val mutable _weights : float array array array

  (**
    The gradients 4-dimensional array. Stores component of the gradient
    (for the minimization by gradient decent).
  *)
  val mutable _gradients : float array array array

  (**
    The number of layers in the network.
  *)
  val mutable _layerNb : int

  (**
    The number of neurones per layer.
  *)
  val mutable _neuronsPerLayer : int array

  (**
    A get*.
    @return The output activation 3-dimensional array.
  *)
  method getOutputActivation : float array array ref

  (**
    A get*.
    @return The output activation 3-dimensional array (copy).
  *)
  method getIndexOutputActivation : int -> float array

  (**
    A get*.
    @return The input sum 3-dimensional array.
  *)
  method getInputSum : float array array ref

  (**
    A get*.
    @return The error sum 3-dimensional array.
  *)
  method getError : float array array ref

  (**
    A get*.
    @return The error for the last pattern
  *)
  method getLastError : float
		      
  (**
    A get*.
    @return The weights 4-dimensional array.
  *)
  method getWeights : float array array array ref

  (**
    A get*.
    @return The gradients 4-dimensional array.
  *)
  method getGradients : float array array array ref

  (**
    A get*.
    @return The number of layers in the network.
  *)
  method getLayerNb : int

  (**
    A get*.
    @return The number of neurones per layer in network.
  *)
  method getNeuronsPerLayer : int array

  (**
    Sets the output activations array.
  *)
  method setOutputActivation : float array array -> unit
						  
  (**
    Sets the input sums array.
  *)
  method setInputSum : float array array -> unit
				  
  (**
    Sets the errors array.
  *)
  method setError : float array array -> unit
			    
  (**
    Sets the weights array.
  *)
  method setWeights : float array array array -> unit
				
  (**
    Sets the gradients array.
  *)
  method setGradients : float array array array -> unit

  (**
    Sets the number of layers.
  *)
  method setLayerNb : int -> unit

  (**
    Sets the number of neurons per layer.
  *)
  method setNeuronsPerLayer : int array -> unit

  (**
    Sets the number of layers.
  *)
  method setLayerNb : int -> unit

  (**
    Sets the input activations.
  *)
  method setInputActivation : float array -> unit

  (**
    Sets the first output activations.
  *)
  method setFirstOutputActivation : float array -> unit

  (**
    Return the marshal of the object
  *)
  method getMarshal : string

  (**
    Dumps the neural network as XML.
  *)
  method toXml : string
    
end

val getMlpNNLearnError : mlpNN -> (mlpNN)defaultVisitor
  -> (mlpNN)defaultVisitor -> float

val getMlpNNTestError : mlpNN -> (mlpNN)defaultVisitor
  -> (mlpNN)defaultVisitor -> float

val getMlpNNValidateError : mlpNN -> (mlpNN)defaultVisitor
  -> (mlpNN)defaultVisitor -> float
