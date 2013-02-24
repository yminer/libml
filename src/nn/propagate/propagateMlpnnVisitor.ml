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
  The propagateMlpnnVisitor class
  Propagates a learning example through the neural network.

  @author Matthieu Lagacherie
  @author Olivier Ricordeau
  @since 10/08/2003
*)

open Nn
open PropagateVisitor
open DefaultVisitor
open MlpNN

class propagateMlpnnVisitor =
object
  inherit [mlpNN] propagateVisitor

  initializer
    _moduleName <- "MLPNN propagation";
    _className <- "mlpnnVisitor"
		    
  val mutable _transfertFunction = function x -> (1. /. (1. +. exp (-.x)))

  method visit (network : mlpNN) =
    let step = network#getStep and
      transFun = _transfertFunction and 
      outputActivation = network#getOutputActivation and
      inputSum = network#getInputSum and
      weights = network#getWeights and
      layerNb = network#getLayerNb and
      neuronsPerLayer = network#getNeuronsPerLayer in
      begin
	(**
	  Propagation of the activation.
	*)
	for l = 0 to layerNb - 2 do
	  for i = 0 to (neuronsPerLayer.(l + 1)) - 1 do
	    !inputSum.(l + 1).(i) <- 0.0;
	    for j = 1 to (neuronsPerLayer.(l)) - 1 do
	      !inputSum.(l + 1).(i) <- !inputSum.(l + 1).(i)
	      +. !outputActivation.(l).(j)
	      *. !weights.(l).(j).(i)
	    done;
	    !outputActivation.(l + 1).(i)
	    <- transFun !inputSum.(l + 1).(i)
	  done
	done
      end

end
