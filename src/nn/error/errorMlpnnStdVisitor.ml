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
  The errorMlpnnStdVisitor class

  @author Matthieu Lagacherie
  @author Olivier Ricordeau
  @since 10/08/2003
*)

open Nn
open ErrorVisitor
open MlpNN

(**
  Computes each neurone's output error in a Multi-Layer Perceptron.
*)
class errorMlpnnStdVisitor =
object
  inherit [mlpNN] errorVisitor

  initializer
    _moduleName <- "MLPNN error computing";
    _className <- "mlpnnVisitor"

  (**
    The transfer function.
  *)
  val mutable _transfertFunction = function x
      -> (tanh x)

  (**
    This function is the derivate of the transfer function above.
  *)
  val mutable _derivateFunction = function x
      -> (1. /. ((cosh x) *. (cosh x)))

  (**
    The generic "visit" method
  *)
  method visit (network : mlpNN) =
    let error = network#getError and
      gradients = network#getGradients and
      output = network#getOutputLearnVector and
      outputActivation = network#getOutputActivation and 
      inputSum = network#getInputSum and 
      weights = network#getWeights and
      derivate = _derivateFunction and
      nbL = network#getLayerNb and
      neurons = network#getNeuronsPerLayer in
      begin
	(**
	  Compute the error of the output layer
	*)
	for i = 0 to neurons.(nbL - 1) - 1 do
	  !error.(nbL - 1).(i)
	  <-  derivate(!inputSum.(nbL - 1).(i)) 
	  *. (!outputActivation.(nbL - 1).(i) -. output.(i));
	  network#addLearningError ((!outputActivation.(nbL - 1).(i) -. output.(i))
				    *. (!outputActivation.(nbL - 1).(i) -. output.(i)))
	done;
	(**
	  Compute the error and gradient of the hidden layers.
	  The last gradient is saved (off line learning)
	*)
	for l = nbL - 2 downto 0 do
	  for i = 0 to neurons.(l) - 1 do
	    !error.(l).(i) <- 0.;
	    for j = 0 to neurons.(l + 1) - 1 do
	      !error.(l).(i)
	      <- !error.(l).(i)
	      +. !error.(l + 1).(j) *. !weights.(l).(i).(j);
	      !gradients.(l).(i).(j)
	      <- !gradients.(l).(i).(j) +.
		!error.(l + 1).(j) *. !outputActivation.(l).(i)
	    done;
	    !error.(l).(i) <- !error.(l).(i) *. derivate(!inputSum.(l).(i))
	  done
	done
      end

end
