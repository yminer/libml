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
   The initTdnnVisitor class.

   @author Matthieu Lagacherie
   @author Olivier Ricordeau
   @since 07/29/2003
 *)

open Random

open Nn
open InitVisitor
open DefaultVisitor
open TdNN
  
  
(**
   Initializes a Time Delay Neural Network.
 *)
class initTdnnVisitor =
  object
    inherit [tdNN] initVisitor
	
    initializer
      _moduleName <- "TDNN initialization"
	  
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
    method visit (network : tdNN) =
      
      (**
	 First, define a bunch of functions which initializes the different
	 stuffs.
       *)

      let featuresNb = network#getFeaturesNb and
	  timeNb = network#getTimeNb and
	  fieldSize = network#getFieldSize in

      (**
	 Define a function designed to test the tdnn architecture
       *)

(*   
   let rec test_couches window_t field_t delay = match (window_t,field_t,delay) wit
   h
   |(a,b,c) when (b=[] && c=[]) -> true
   |(a,b,c) -> ((List.hd b + List.hd c)<=List.hd a &&
   (List.hd a - List.hd b) mod (List.hd c)=0 &&
   (1 + (List.hd a - List.hd b)/(List.hd c))=(List.hd (List.tl a)))
   &&
   test_couches (List.tl a) (List.tl b) (List.tl c) and
   
   let test_config nb_data nb_layers window_t nb_feat field_t delay = match (nb_dat
   a,nb_layers,window_t,nb_feat,field_t,delay) with
   |(a,b,c,d,e,f) when (a = 0 || b < 3 || c = [] || nb_elt c != b || d = [] || nb
   _elt d != b || e = [] || nb_elt e != b-1 || f = [] || nb_elt f != b-1) ->false
   |(a,b,c,d,e,f) when (a = (List.hd c)*(List.hd d) && test_couches c e f) -> tru
   e
   |_ -> false in
 *)
      
      (**
	 Initializes the output activation.
       *)
      let initOutputActivation network =
	let outputActivation =
	  Array.make network#getLayerNb [|[||]|] in
	for i = 0 to network#getLayerNb - 1 do
	  outputActivation.(i) <- Array.make (featuresNb.(i)) [||];
	  for j = 0 to (featuresNb.(i)) - 1 do
	    outputActivation.(i).(j) <- Array.make (timeNb.(i)) 0.0
	  done
	done;
	network#setOutputActivation outputActivation
      and
	  
	  (**
	     Initializes the the input sum.
	   *)
	  initInputSum (network : tdNN) =
	let inputSum = Array.make network#getLayerNb [|[||]|] in
	for i = 0 to network#getLayerNb - 1 do
	  inputSum.(i) <- Array.create (featuresNb.(i)) [||];
	  for j = 0 to (featuresNb.(i)) - 1 do
	    inputSum.(i).(j) <- Array.create (timeNb.(i)) 0.0
	  done
	done;
	network#setInputSum inputSum
      and
	  
	  (**
	     Initializes the error.
	   *)
	  initError (network : tdNN) =
	let error = Array.make network#getLayerNb [|[||]|] in
	for i = 0 to network#getLayerNb - 1 do
	  error.(i) <- Array.make (featuresNb.(i)) [||];
	  for j = 0 to (featuresNb.(i)) - 1 do
	    error.(i).(j) <- Array.make (timeNb.(i)) 0.0
	  done
	done;
	network#setError error
      and
	  
	  (**
	     Initializes the weights (using random numbers).
	     weights[layer][feat layer][time layer][feat layer + 1]
	   *)
	  initWeights (network : tdNN) = 
	let weights = Array.make (network#getLayerNb - 1) [|[|[||]|]|] in
	for i = 0 to network#getLayerNb - 2 do
	  weights.(i) <- Array.make (featuresNb.(i)) [|[||]|];
	  for j = 0 to (featuresNb.(i)) - 1 do
	    weights.(i).(j)
	    <- Array.make (fieldSize.(i)) [||];
	    for k = 0 to (fieldSize.(i)) - 1 do
	      weights.(i).(j).(k)
	      <- Array.make (featuresNb.(i + 1))
		  (Random.float (Env.getEnv())#getRandLimit)
	    done
	  done
	done;
	network#setWeights weights
      and
	  
	  (**
	     Initializes the gradients.
	     gradients[layer][feat layer][time layer][feat layer + 1]
	   *)
	  initGradients (network : tdNN) =
	let gradients = Array.make (network#getLayerNb - 1) [|[|[||]|]|] in
	for i = 0 to network#getLayerNb - 2 do
	  gradients.(i) <- Array.make (featuresNb.(i)) [|[||]|];
	  for j = 0 to (featuresNb.(i)) - 1 do
	    gradients.(i).(j)
	    <- Array.make (fieldSize.(i)) [||];
	    for k = 0 to (fieldSize.(i)) - 1 do
	      gradients.(i).(j).(k)
	      <- Array.make (featuresNb.(i + 1))
		  (Random.float (Env.getEnv())#getRandLimit)
	    done
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
