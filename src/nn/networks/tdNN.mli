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
  @since 07/28/2003
*)

open Nn
open DefaultVisitor

class tdNN :
object
  inherit nn

  val mutable _outputActivation : float array array array

  val mutable _inputSum : float array array array

  val mutable _error : float array array array

  val mutable _weights : float array array array array

  val mutable _gradients : float array array array array

  val mutable _layerNb : int

  val mutable _delay : int array

  val mutable _featuresNb : int array

  val mutable _timeNb : int array

  val mutable _fieldSize : int array

  method getOutputActivation : float array array array ref

  method getInputSum : float array array array ref
    
  method getError : float array array array ref

  method getWeights : float array array array array ref

  method getGradients : float array array array array ref

  method getLayerNb : int

  method getDelay : int array ref

  method getFeaturesNb : int array

  method getTimeNb : int array

  method getFieldSize : int array

  method setOutputActivation : float array array array -> unit

  method setInputSum : float array array array -> unit

  method setError : float array array array -> unit

  method setWeights :float array array array array -> unit
      
  method setGradients :float array array array array -> unit

  method setLayerNb : int -> unit

  method setDelay : int array -> unit
      
  method setFeaturesNb : int array -> unit

  method setTimeNb : int array -> unit
   
  method setFieldSize : int array -> unit

  method setInputActivation : float array array -> unit

  (**
    Dumps the neural network as XML.
  *)
  method toXml : string
   
end
