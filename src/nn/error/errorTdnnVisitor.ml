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
   The errorTdnnVisitor class
   Computes each neurone's output error.

   @author Matthieu Lagacherie
   @since 10/08/2003
 *)

open Nn
open ErrorVisitor
open DefaultVisitor
open TdNN

class errorTdnnVisitor =
object
  inherit [tdNN] errorVisitor

  val mutable _transfertFunction = function x
      -> (1. /. (1. +. exp (-.x)))

  val mutable _derivateFunction = function x
      -> (((1. /. (1. +. exp (-.x)))) *. (1. -. (1. /. (1. +. exp (-.x)))))

  method visit (network : tdNN) =
    let 
      (**
	This method returns the neuron interval of the layer l + 1 which are connected
	to the neuron state of the layer l.

	state -> index of the neuron of the layer l in time direction.
	field -> the field of the layer l.
	delay -> the delay of the layer l.
	currentTimeNb -> the number of neuron in the time direction of the layer l
	nextTimeNb -> the number of neuron in the time direction of the layer l + 1
      *)

      nbConnected (state, field, delay, currentTimeNb, nextTimeNb) =
      let step = ref 0 and
	startState = ref 0 and
	endState = ref 0 and
	stop = ref 0 in
	begin
	  endState := -1;
	  startState := -1;
	  for i = 0 to nextTimeNb - 1 do
	    stop := if ((!step + field - 1) >= currentTimeNb) then (currentTimeNb - 1) else (!step + field - 1);
	    startState := if ((!step <= state) && (state <= !stop) && (!startState == -1)) then i else !startState;
	    endState := if ((state < !step) && (!endState == -1)) then (i - 1) else !endState;
	    step := !step + delay
	  done;
	  endState := if (!endState == -1) then nextTimeNb - 1 else !endState
	end; (!startState, !endState) and

      (**
	Compute the weight index which connect the neuron currentState
	of the layer l to the neuron nextState of the layer l + 1.
	field -> field of the layer l
	delay -> delay of the layer l
	currentTimeNb -> the number of neuron in the time direction of the layer l
      *)

      findWeightIndex (currentState, nextState, currentTimeNb, field, delay) =
      let index = ref 0 and
	start = ref 0 in
	begin
	  start := delay * nextState;
	  while ((!start != currentState) && (!index < (field - 1)) && (!start < currentTimeNb - 1)) do
	    index := !index + 1;
	    start := !start + 1
	  done
	end; !index and

      (**
	In order to simplify the notations
      *)

      error = network#getError and
      gradients = network#getGradients and
      output = network#getOutputLearnVector and
      outputActivation = network#getOutputActivation and 
      inputSum = network#getInputSum and 
      weights = network#getWeights and
      derivate = _derivateFunction and
      delay = network#getDelay and
      timeNb = network#getTimeNb and
      featuresNb = network#getFeaturesNb and
      fieldSize = network#getFieldSize and
      startEnd = ref (0, 0) and
      index = ref 0 and
      stepDelay = ref 0 in
      begin

        (**
	  Compute the error of the output layer
	  Here the output vector is mapped in a first time on
	  the feature direction and in a second time in the time direction.
	*)
	
	for i = 0 to featuresNb.(network#getLayerNb - 1) - 1 do
	  for j = 0 to timeNb.(network#getLayerNb - 1) - 1 do
	    !error.(network#getLayerNb - 1).(i).(j)
	    <- (* derivate(!inputSum.(network#getLayerNb - 1).(i).(j))
		*.*) (output.(i + j) -. !outputActivation.(network#getLayerNb - 1).(i).(j));
	  done
	done;
	(**
	  Initialize the gradients
	*)
	for i = 0 to Array.length !gradients - 1 do
	  for j = 0 to Array.length !gradients.(i) - 1 do
	    for k = 0 to Array.length !gradients.(i).(j) - 1 do
	      for l = 0 to Array.length !gradients.(i).(j).(k) - 1 do
		!gradients.(i).(j).(k).(l) <- 0.
	      done
	    done
	  done
	done;
        (**
	  Compute the error and gradient of the hidden layers.
	  l the layer
	  i neuron of the layer l + 1 in the feature direction
	  j neuron of the layer l + 1 in the time direction
	  k neuron of the layer l in the feature direction
	  m neuron of the layer l in the time direction
	  stepDelay used to keep the delay concept
	*)
	for l = network#getLayerNb - 2 downto 0 do
	  for m = 0 to timeNb.(l) - 1 do
	    startEnd := nbConnected (m, fieldSize.(l), !delay.(l), timeNb.(l), timeNb.(l + 1));
	    for k = 0 to featuresNb.(l) - 1 do
              (**
		Initialization of the error term.
	      *)
	      !error.(l).(k).(m) <- 0.;
	      for j = fst !startEnd to snd !startEnd do
		index := findWeightIndex(m, j, timeNb.(l), fieldSize.(l), !delay.(l));
		for i = 0 to featuresNb.(l + 1) - 1 do

		  (**
		    Backpropagation of the error term
		  *)

		  !error.(l).(k).(m)
		  <- !error.(l).(k).(m)
		  +. !error.(l + 1).(i).(j)
		  *. !weights.(l).(k).(!index).(i);

		  (**
		    We compute the gradient with the error term of
		    the layer l + 1.
		  *)

		  !gradients.(l).(k).(!index).(i)
		  <- !gradients.(l).(k).(!index).(i)
		  +. !error.(l + 1).(i).(j)
		  *. !outputActivation.(l).(k).(m)
		done;
	      done;
	      !error.(l).(k).(m) <- !error.(l).(k).(m)
	      *. derivate(!inputSum.(l).(k).(m))
	    done
	  done
	done
      end
end

(*	    Printf.printf "Index [i=%d] [stop=%d] [step=%d] [startState=%d] [endState=%d] [state=%d] [field=%d] [delay=%d] [current=%d] [next=%d]\n"
   i !stop !step !startState !endState state field delay currentTimeNb nextTimeNb *)
(*	    Printf.printf "value=%f output=%f activation=%f input=%f \n\n" 
   !error.(network#getLayerNb - 1).(i).(j) output.(i + j)
   !outputActivation.(network#getLayerNb - 1).(i).(j)
   !inputSum.(network#getLayerNb - 1).(i).(j) *)

(*		  Printf.printf "Index [l=%d] [m=%d] [k=%d] [j=%d] [i=%d] [start=%d] [endD=%d]\n" l m k j i (fst !startEnd) (snd !startEnd); *)


(*		  Printf.printf "!error.(%d).(%d).(%d) <- !error.(%d).(%d).(%d) +. !error.(%d).(%d).(%d) *. !weights.(%d).(%d).(%d).(%d);\n" 
   l k m l k m (l+1) i j l k m i;   
   Printf.printf "value = %f\n\n" !error.(l).(k).(m); *)

(*		  Printf.printf "!gradients.(%d).(%d).(%d).(%d) <- !error.(%d).(%d).(%d) *. !outputActivation.(%d).(%d).(%d)\n\n"
   l k m i (l+1) i j l k m *)
  
