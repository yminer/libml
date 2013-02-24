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
   The propagateTdnnVisitor class
   Propagates a learning example through the neural network.

   @author Matthieu Lagacherie
   @since 08/10/2003
 *)

open Nn
open PropagateVisitor
open DefaultVisitor
open TdNN

class propagateTdnnVisitor =
  object
    inherit [tdNN] propagateVisitor
    val mutable _transfertFunction = function x -> (1. /. (1. +. exp (-.x)))
    method visit (network : tdNN) =
      let transFun = _transfertFunction and 
	  outputActivation = network#getOutputActivation and
	  inputSum = network#getInputSum and
	  weights = network#getWeights and
	  delay = network#getDelay and
	  timeNb = network#getTimeNb and
	  featuresNb = network#getFeaturesNb and
	  fieldSize = network#getFieldSize and
	  stepDelay = ref 0 in
      begin
	(**
	   Activation of the input layer.
	 *)
	for i = 0 to featuresNb.(0) - 1 do
	  for j = 0 to timeNb.(0) - 1 do
	    !outputActivation.(0).(i).(j) <- transFun !inputSum.(0).(i).(j)
	  done
	done;
	(**
	   Propagation of the activation.
	   l the layer
	   i neuron of the layer l + 1 in the feature direction
	   j neuron of the layer l + 1 in the time direction
	   k neuron of the layer l in the feature direction
	   m neuron of the layer l in the time direction
	   stepDelay used to keep the delay concept
	 *)
	for l = 0 to network#getLayerNb - 2 do
	  for j = 0 to timeNb.(l + 1) - 1 do
	    for i = 0 to featuresNb.(l + 1) - 1 do
              (**
		 We initialize the input sum of the layer l + 1.
	       *)
	      !inputSum.(l + 1).(i).(j) <- 0.;
	      for k = 0 to featuresNb.(l) - 1 do
		for m = !stepDelay to (!stepDelay + fieldSize.(l)) - 1 do
		  !inputSum.(l + 1).(i).(j) <- !inputSum.(l + 1).(i).(j)
		      +. !outputActivation.(l).(k).(m)
		      *. !weights.(l).(k).(m - !stepDelay).(i);
		done
	      done;
	      !outputActivation.(l + 1).(i).(j) <- transFun !inputSum.(l + 1).(i).(j);
	    done;
	    stepDelay := !stepDelay + !delay.(l)
	  done;
	  stepDelay := 0
	done
      end
  end

(*		  Printf.printf "Indices [l=%d] [i=%d] [j=%d] [k=%d] [m=%d] [stepDelay=%d]\n" l i j k m !stepDelay; *)
(*		  Printf.printf "Valeur !inputSum.(%d).(%d).(%d) <- " (l + 1) i j;
   Printf.printf "!inputSum.(%d).(%d).(%d)\n +. !outputActivation.(%d).(%d).(%d)\n *. !weights.(%d).(%d).(%d).(%d);\n" (l+1) i j l k m l k (m - !stepDelay) i;
   Printf.printf "\n = %f\n" !inputSum.(l + 1).(i).(j) *)
