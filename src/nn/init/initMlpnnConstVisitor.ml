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
  The initMlpNNVisitor class

  @author Matthieu Lagacherie
  @author Olivier Ricordeau
  @since 10/08/2003
*)

open Random

open Nn
open InitVisitor
open MlpNN
     
(**
  Initializes a Multi Layer Perceptron.
*)      
class initMlpnnConstVisitor =
object
  inherit [mlpNN] initVisitor

  initializer
    _moduleName <- "MLPNN initialization";
    _className <- "mlpnnVisitor"

  (**
    The method which initializes the network.
    It uses the Random module to initialize the weights.
    @see
    <http://caml.inria.fr/oreilly-book/html/book-ora076.html>
    Using the Random module (provided in the standard OCaml
    distribution).
    @see <http://caml.inria.fr/devtools/doc_ocaml/Unix.html#VALtime>
    Used to initialize the random number generator.
  *)
  method visit (network : mlpNN) =

    (**
      First, define a bunch of functions which initializes the different
      stuffs.
    *)
    let neuronsPerLayer = network#getNeuronsPerLayer in
 
    (**
      Initializes the output activation.
    *)
    let initOutputActivation network =
      let outputActivation = Array.make network#getLayerNb [||] in
	for i = 0 to network#getLayerNb - 1 do
	  outputActivation.(i)
	  <- Array.make (neuronsPerLayer.(i)) 0.0
	done;
	network#setOutputActivation outputActivation
    and	  
      
      (**
	Initializes the the input sum.
      *)
      initInputSum network =
      let inputSum = Array.make network#getLayerNb [||] in
	for i = 0 to network#getLayerNb - 1 do
	  inputSum.(i)
	  <- Array.make (neuronsPerLayer.(i)) 0.0
	done;
	network#setInputSum inputSum
    and
      
      (**
	Initializes the error.
      *)
      initError network =
      let error = Array.make network#getLayerNb [||] in
	for i = 0 to network#getLayerNb - 1 do
	  error.(i)
	  <- Array.make (neuronsPerLayer.(i)) 0.0
	done;
	network#setError error
    and	
      
      (**
	Initializes the weights (using random numbers).
      *)
      initWeights network = 
      let weights = Array.make (network#getLayerNb - 1) [|[||]|] in
	for i = 0 to network#getLayerNb - 2 do
	  weights.(i) <- Array.make (neuronsPerLayer.(i)) [||];
	  for j = 0 to (neuronsPerLayer.(i)) - 1 do
	    weights.(i).(j)
	    <- Array.make (neuronsPerLayer.(i + 1)) 0.0
(*	      (Random.float (Env.getEnv())#getRandLimit) *)
	  done;
	done;
	for i = 0 to network#getLayerNb - 2 do
	  for j = 0 to (neuronsPerLayer.(i)) - 1 do
	    for k = 0 to (neuronsPerLayer.(i + 1)) - 1 do
	      weights.(i).(j).(k) <- 0.5
	    done;
	  done;
	done;
	network#setWeights weights
    and	

      
      (**
	Initializes the gradients.
      *)
      initGradients network =
      let gradients = Array.make (network#getLayerNb - 1) [|[||]|] in
	for i = 0 to network#getLayerNb - 2 do
	  gradients.(i) <- Array.make (neuronsPerLayer.(i)) [||];
	  for j = 0 to ((neuronsPerLayer.(i)) - 1) do
	    gradients.(i).(j)
	    <- Array.make (neuronsPerLayer.(i + 1)) 0.0
	  done
	done;
	network#setGradients gradients
    in
      
      (** Initialize the random number generator. *)
      Random.self_init();
      
      (** Initialize everything *)
      initOutputActivation network;
      initInputSum network;
      initError network;
      initGradients network;
      initWeights network
	
end
